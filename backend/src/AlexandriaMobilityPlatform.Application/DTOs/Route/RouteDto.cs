namespace AlexandriaMobilityPlatform.Application.DTOs.Route;

public record RouteDto(
    long Id,
    long CommunityId,
    string CommunityName,
    string Name,
    string StartPoint,
    string EndPoint,
    decimal StartLatitude,
    decimal StartLongitude,
    decimal EndLatitude,
    decimal EndLongitude,
    decimal DistanceKm,
    int EstimatedTimeMinutes,
    List<StopDto> Stops,
    bool IsActive);

public record CreateRouteRequest(
    long CommunityId,
    string Name,
    string StartPoint,
    string EndPoint,
    decimal StartLatitude,
    decimal StartLongitude,
    decimal EndLatitude,
    decimal EndLongitude,
    decimal DistanceKm,
    int EstimatedTimeMinutes,
    List<CreateStopRequest> Stops);

public record UpdateRouteRequest(
    string Name,
    string StartPoint,
    string EndPoint,
    decimal StartLatitude,
    decimal StartLongitude,
    decimal EndLatitude,
    decimal EndLongitude,
    decimal DistanceKm,
    int EstimatedTimeMinutes,
    List<CreateStopRequest> Stops,
    bool IsActive);

public record StopDto(
    long Id,
    string Name,
    decimal Latitude,
    decimal Longitude,
    int OrderNumber,
    int EstimatedArrivalMinutes);

public record CreateStopRequest(
    string Name,
    decimal Latitude,
    decimal Longitude,
    int OrderNumber,
    int EstimatedArrivalMinutes);
