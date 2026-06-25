namespace AlexandriaMobilityPlatform.Application.DTOs.Group;

public record GroupDto(
    long Id,
    long CommunityId,
    string CommunityName,
    long RouteId,
    string RouteName,
    long DriverId,
    string DriverName,
    long VehicleId,
    string VehiclePlate,
    string Name,
    int Capacity,
    int AvailableSeats,
    TimeSpan DepartureTime,
    TimeSpan? ReturnTime,
    int WorkingDays,
    string Status,
    decimal Price,
    bool IsSubscribed);

public record CreateGroupRequest(
    long CommunityId,
    long RouteId,
    long DriverId,
    long VehicleId,
    string Name,
    int Capacity,
    TimeSpan DepartureTime,
    TimeSpan? ReturnTime,
    int WorkingDays,
    decimal Price);

public record UpdateGroupRequest(
    long DriverId,
    long VehicleId,
    string Name,
    int Capacity,
    TimeSpan DepartureTime,
    TimeSpan? ReturnTime,
    int WorkingDays,
    string Status,
    decimal Price);

public record GroupSearchRequest(
    long CommunityId,
    string? Query,
    int PageNumber = 1,
    int PageSize = 10);

public record GroupRecommendationDto(
    long GroupId,
    string GroupName,
    string RouteName,
    string DriverName,
    TimeSpan DepartureTime,
    int AvailableSeats,
    decimal Score);
