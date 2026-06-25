# Alexandria Community Mobility Platform - Architecture

## Overview

The Alexandria Community Mobility Platform is a community-based scheduled transportation system built with enterprise-grade patterns and practices. It enables users within specific communities (companies, universities, schools, compounds) to join transportation groups with fixed routes, schedules, drivers, and limited seats.

## Phase 1: System Analysis & Architecture

### Domain Analysis

The platform operates around these core domain concepts:

1. **Community**: A closed network (e.g., a company or university) with an admin who manages routes, groups, and members.
2. **Route**: Fixed path with StartPoint, EndPoint, and an ordered list of Stops.
3. **Group**: A scheduled trip (e.g., "Morning Route A") with capacity, departure/return times, working days, driver, and vehicle.
4. **Booking**: A passenger reservation for a specific group on a specific day.
5. **Trip**: A real-world execution of a group schedule, tracked via GPS and driver actions.

### Architecture Decisions

#### Backend: Clean Architecture

We adopt **Clean Architecture** to achieve separation of concerns, testability, and maintainability.

| Layer | Responsibility | Dependencies |
|-------|---------------|--------------|
| **Domain** | Entities, enums, domain logic, domain events | None |
| **Application** | Use cases, DTOs, interfaces, validators, mappings | Domain only |
| **Infrastructure** | Data access (EF Core), identity, caching (Redis), email, file storage, SignalR backing | Application |
| **Presentation** | Web API controllers, SignalR hubs, middleware | Application, Infrastructure |

**Why Clean Architecture?**
- Business rules are isolated from frameworks (EF Core, ASP.NET Core).
- Easy to unit test domain and application layers.
- Swapping infrastructure (e.g., SQL Server → PostgreSQL) does not affect business logic.
- Aligns with SOLID principles.

#### Backend Stack Choices

| Technology | Purpose | Justification |
|------------|---------|---------------|
| ASP.NET Core 8 Web API | HTTP API | Industry standard, high performance, built-in DI |
| Entity Framework Core | ORM | Productivity, strong SQL Server integration |
| SQL Server | Relational DB | ACID compliance, scalable, familiar to Egypt market |
| Repository + Unit of Work | Data access abstraction | Testability, transaction control |
| AutoMapper | DTO mapping | Reduces boilerplate mapping code |
| FluentValidation | Input validation | Declarative, testable validation rules |
| JWT + Refresh Tokens | Auth stateless auth | Scalable authentication for SPAs and mobile |
| Identity Core | User management | Secure password hashing, role management |
| SignalR | Real-time tracking | Native .NET real-time communication |
| Redis | Distributed caching | Performance, session store, SignalR backplane ready |
| Hangfire | Background jobs | Reliable scheduling for notifications and reports |
| Serilog | Logging | Structured logging for diagnostics |
| Swagger/OpenAPI | API documentation | Auto-generated API contract |

#### Frontend: Angular 19

We selected **Angular 19** with:
- Standalone components
- Signals for state management
- Angular Material + TailwindCSS
- NGXS for complex global state
- `ngx-translate` for Arabic/English i18n + RTL

**Why Angular?**
- Strong enterprise tooling and conventions.
- Excellent TypeScript integration.
- Built-in dependency injection, lazy loading, and guards.
- First-class support for RTL layouts.

#### DevOps Strategy

- Docker multi-stage builds for backend and frontend.
- Docker Compose for local development (SQL Server, Redis, API, Web, Hangfire).
- GitHub Actions CI pipeline for build, test, and image push.
- Production-ready configuration via environment variables.
- Cloud-agnostic deployment (Azure Container Apps, AWS ECS, DigitalOcean App Platform).

## Database ERD (Summary)

```
Users ||--o{ CommunityMembers : belongs_to
Users ||--o{ Communities : manages
Users ||--o{ Groups : drives
Users ||--o{ Bookings : books
Users ||--o{ Payments : pays
Users ||--o{ RefreshTokens : owns
Users ||--o{ Notifications : receives
Users ||--o{ Vehicles : owns

Communities ||--o{ CommunityMembers : has
Communities ||--o{ Routes : has
Communities ||--o{ Groups : operates
Communities ||--o{ CommunityAdmins : administered_by

Routes ||--o{ Stops : contains
Routes ||--o{ Groups : served_by

Groups ||--o{ Bookings : receives
Groups ||--o{ Trips : executes
Groups ||--|| Vehicles : uses

Trips ||--o{ DriverLocations : tracks
Trips ||--o{ TripEvents : logs
```

## Scalability Roadmap

1. **Phase 1 (Alexandria)**: Single-region SQL Server + Redis + monolithic API.
2. **Phase 2 (Cairo)**: CDN + multi-region read replicas + Azure Service Bus/Hangfire scale-out.
3. **Phase 3 (Multi-city)**: Microservices split for booking, tracking, payments; Kubernetes deployment.
