namespace AlexandriaMobilityPlatform.Application.DTOs.Vehicle;

public record VehicleDto(
    long Id,
    long DriverId,
    string DriverName,
    string PlateNumber,
    string Model,
    string Color,
    int Capacity,
    int Year,
    bool IsActive);

public record CreateVehicleRequest(
    long DriverId,
    string PlateNumber,
    string Model,
    string Color,
    int Capacity,
    int Year);

public record UpdateVehicleRequest(
    string PlateNumber,
    string Model,
    string Color,
    int Capacity,
    int Year,
    bool IsActive);
