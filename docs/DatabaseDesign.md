# Alexandria Community Mobility Platform - Database Design

## Conventions

- Primary keys are `bigint` identity columns named `Id`.
- Audit fields: `CreatedAt`, `UpdatedAt`, `CreatedBy`, `UpdatedBy`.
- Soft delete via `IsDeleted` + `DeletedAt`.
- Use appropriate indexes on foreign keys and search fields.
- All string fields use Unicode (NVARCHAR).
- Geographic coordinates use `decimal(9,6)` for safe precision.

## Entities

### Users
Central identity entity. Passwords are hashed by ASP.NET Core Identity.

| Column | Type | Notes |
|--------|------|-------|
| Id | bigint PK | Identity |
| FullName | nvarchar(200) | Required |
| Email | nvarchar(256) | Unique, normalized |
| PhoneNumber | nvarchar(20) | Unique, required for Egypt market |
| PasswordHash | nvarchar(max) | Identity managed |
| ProfileImageUrl | nvarchar(500) | Optional CDN URL |
| PreferredLanguage | nvarchar(10) | 'en' or 'ar' |
| IsActive | bit | Soft-block flag |
| EmailConfirmed | bit | Identity |
| PhoneNumberConfirmed | bit | Identity |
| CreatedAt | datetimeoffset | Audit |
| UpdatedAt | datetimeoffset | Audit |

### Roles (IdentityRole<long>)
Provided by ASP.NET Identity:
- Passenger
- Driver
- CommunityAdmin
- SuperAdmin

### UserRoles
Linking table from Identity.

### Communities
| Column | Type | Notes |
|--------|------|-------|
| Id | bigint PK | Identity |
| Name | nvarchar(200) | Required |
| Type | tinyint | Enum: Company, University, School, Compound, Organization |
| City | nvarchar(100) | e.g., Alexandria, Cairo |
| Area | nvarchar(100) | e.g., Smouha, Maadi |
| Address | nvarchar(500) | Full address |
| AdminId | bigint FK → Users | Community manager |
| LogoUrl | nvarchar(500) | Optional |
| IsActive | bit | |
| CreatedAt | datetimeoffset | |

### CommunityMembers
| Column | Type | Notes |
|--------|------|-------|
| Id | bigint PK | |
| UserId | bigint FK | |
| CommunityId | bigint FK | |
| Status | tinyint | Pending, Approved, Rejected, Blocked |
| JoinedAt | datetimeoffset | |

### CommunityAdmins
Optional mapping for sub-admins per community.

| Column | Type | Notes |
|--------|------|-------|
| Id | bigint PK | |
| UserId | bigint FK | |
| CommunityId | bigint FK | |
| AddedAt | datetimeoffset | |

### Vehicles
| Column | Type | Notes |
|--------|------|-------|
| Id | bigint PK | |
| DriverId | bigint FK → Users | Assigned driver |
| CommunityId | bigint FK | Optional grouping |
| PlateNumber | nvarchar(50) | Unique within city |
| Model | nvarchar(100) | |
| Color | nvarchar(50) | |
| Capacity | int | Max passengers |
| Year | int | |
| IsActive | bit | |
| CreatedAt | datetimeoffset | |

### Routes
| Column | Type | Notes |
|--------|------|-------|
| Id | bigint PK | |
| CommunityId | bigint FK | |
| Name | nvarchar(200) | e.g., "Route A - Smouha to New Borg" |
| StartPoint | nvarchar(300) | Human-readable start |
| EndPoint | nvarchar(300) | Human-readable end |
| StartLatitude | decimal(9,6) | |
| StartLongitude | decimal(9,6) | |
| EndLatitude | decimal(9,6) | |
| EndLongitude | decimal(9,6) | |
| DistanceKm | decimal(8,3) | |
| EstimatedTimeMinutes | int | |
| IsActive | bit | |
| CreatedAt | datetimeoffset | |

### Stops
| Column | Type | Notes |
|--------|------|-------|
| Id | bigint PK | |
| RouteId | bigint FK | |
| Name | nvarchar(200) | |
| Latitude | decimal(9,6) | |
| Longitude | decimal(9,6) | |
| OrderNumber | int | Sequence within route |
| EstimatedArrivalMinutes | int | Offset from trip start |

### Groups
| Column | Type | Notes |
|--------|------|-------|
| Id | bigint PK | |
| CommunityId | bigint FK | |
| RouteId | bigint FK | |
| DriverId | bigint FK → Users | |
| VehicleId | bigint FK | |
| Name | nvarchar(200) | e.g., "Morning Group A" |
| Capacity | int | Max seats |
| AvailableSeats | int | Computed/cache |
| DepartureTime | time | Daily departure |
| ReturnTime | time | Optional return |
| WorkingDays | tinyint | Bitmask: Sun=1..Sat=64 |
| Status | tinyint | Active, Inactive, Full, Cancelled |
| SubscriptionType | tinyint | Free, Monthly, PerTrip |
| Price | decimal(10,2) | For paid groups |
| CreatedAt | datetimeoffset | |

### GroupSubscriptions (for monthly model)
| Column | Type | Notes |
|--------|------|-------|
| Id | bigint PK | |
| UserId | bigint FK | |
| GroupId | bigint FK | |
| StartDate | date | |
| EndDate | date | |
| Status | tinyint | Active, Expired, Cancelled |

### Bookings
| Column | Type | Notes |
|--------|------|-------|
| Id | bigint PK | |
| UserId | bigint FK | |
| GroupId | bigint FK | |
| BookingDate | date | Travel date |
| PickupStopId | bigint FK | Optional precise pickup |
| Status | tinyint | Confirmed, Cancelled, Completed, NoShow |
| PaymentStatus | tinyint | Pending, Paid, Refunded, Failed |
| CreatedAt | datetimeoffset | |

### Trips
Represents an actual execution of a group on a specific date.

| Column | Type | Notes |
|--------|------|-------|
| Id | bigint PK | |
| GroupId | bigint FK | |
| TripDate | date | |
| Status | tinyint | Scheduled, Started, Completed, Cancelled |
| StartedAt | datetimeoffset | |
| CompletedAt | datetimeoffset | |
| DriverNotes | nvarchar(1000) | |

### DriverLocations
| Column | Type | Notes |
|--------|------|-------|
| Id | bigint PK | |
| TripId | bigint FK | |
| DriverId | bigint FK | |
| Latitude | decimal(9,6) | |
| Longitude | decimal(9,6) | |
| RecordedAt | datetimeoffset | |
| AccuracyMeters | decimal(6,2) | |

### TripEvents
| Column | Type | Notes |
|--------|------|-------|
| Id | bigint PK | |
| TripId | bigint FK | |
| EventType | tinyint | Started, StopReached, Completed, Incident |
| MetadataJson | nvarchar(max) | Flexible event data |
| OccurredAt | datetimeoffset | |

### Payments
| Column | Type | Notes |
|--------|------|-------|
| Id | bigint PK | |
| UserId | bigint FK | |
| BookingId | bigint FK | Nullable |
| SubscriptionId | bigint FK | Nullable |
| Amount | decimal(10,2) | |
| Currency | nvarchar(3) | EGP |
| PaymentMethod | tinyint | Cash, Card, Wallet, Fawry |
| Status | tinyint | Pending, Success, Failed, Refunded |
| ProviderReference | nvarchar(255) | Payment gateway ref |
| PaidAt | datetimeoffset | |

### Notifications
| Column | Type | Notes |
|--------|------|-------|
| Id | bigint PK | |
| UserId | bigint FK | |
| Title | nvarchar(200) | |
| Message | nvarchar(1000) | |
| Type | tinyint | Info, Booking, Trip, Payment |
| IsRead | bit | |
| CreatedAt | datetimeoffset | |

### RefreshTokens
| Column | Type | Notes |
|--------|------|-------|
| Id | bigint PK | |
| UserId | bigint FK | |
| Token | nvarchar(500) | Hashed |
| ExpiresAt | datetimeoffset | |
| CreatedAt | datetimeoffset | |
| RevokedAt | datetimeoffset | |
| ReplacedByToken | nvarchar(500) | |

### AuditLogs
| Column | Type | Notes |
|--------|------|-------|
| Id | bigint PK | |
| UserId | bigint FK | Nullable |
| EntityType | nvarchar(100) | |
| EntityId | bigint | |
| Action | nvarchar(50) | |
| OldValuesJson | nvarchar(max) | |
| NewValuesJson | nvarchar(max) | |
| IpAddress | nvarchar(50) | |
| UserAgent | nvarchar(500) | |
| OccurredAt | datetimeoffset | |

## Indexes

- `IX_Users_Email`, `IX_Users_PhoneNumber`
- `IX_CommunityMembers_UserId_CommunityId` unique
- `IX_Bookings_UserId_BookingDate`
- `IX_Bookings_GroupId_BookingDate`
- `IX_DriverLocations_TripId_RecordedAt`
- `IX_Groups_CommunityId_Status`
- `IX_Groups_RouteId`
