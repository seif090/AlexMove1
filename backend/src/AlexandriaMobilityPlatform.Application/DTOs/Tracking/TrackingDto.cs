namespace AlexandriaMobilityPlatform.Application.DTOs.Tracking;

public record DriverLocationUpdateDto(
    long TripId,
    decimal Latitude,
    decimal Longitude,
    decimal? AccuracyMeters);

public record DriverLocationResponseDto(
    long DriverId,
    string DriverName,
    decimal Latitude,
    decimal Longitude,
    DateTime RecordedAt);

public record TripStatusUpdateDto(
    long TripId,
    string Status);
