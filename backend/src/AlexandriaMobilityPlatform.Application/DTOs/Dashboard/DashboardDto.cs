namespace AlexandriaMobilityPlatform.Application.DTOs.Dashboard;

public record SuperAdminDashboardDto(
    int TotalUsers,
    int TotalDrivers,
    int TotalCommunities,
    int TotalGroups,
    int TotalBookings,
    int ActiveBookings,
    decimal TotalRevenue,
    List<RecentActivityDto> RecentActivities,
    List<PopularRouteDto> PopularRoutes,
    List<DailyStatDto> DailyStats);

public record CommunityAdminDashboardDto(
    long CommunityId,
    string CommunityName,
    int TotalMembers,
    int TotalRoutes,
    int TotalGroups,
    int ActiveGroups,
    int TodayBookings,
    List<RouteStatDto> RouteStats);

public record DriverDashboardDto(
    int TotalTrips,
    int TodayTrips,
    int CompletedTrips,
    int TotalPassengers,
    List<UpcomingTripDto> UpcomingTrips);

public record RecentActivityDto(
    string Type,
    string Description,
    DateTime OccurredAt);

public record PopularRouteDto(
    string RouteName,
    int BookingCount);

public record DailyStatDto(
    DateTime Date,
    int Bookings,
    decimal Revenue);

public record RouteStatDto(
    string RouteName,
    int BookingCount,
    decimal Revenue);

public record UpcomingTripDto(
    long TripId,
    string GroupName,
    string RouteName,
    DateTime TripDate,
    TimeSpan DepartureTime,
    int PassengerCount);
