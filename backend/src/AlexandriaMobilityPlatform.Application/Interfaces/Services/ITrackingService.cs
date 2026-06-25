using AlexandriaMobilityPlatform.Application.Common.Models;
using AlexandriaMobilityPlatform.Application.DTOs.Tracking;

namespace AlexandriaMobilityPlatform.Application.Interfaces.Services;

public interface ITrackingService
{
    Task<Result> UpdateDriverLocationAsync(DriverLocationUpdateDto request, CancellationToken cancellationToken = default);
    Task<Result<DriverLocationResponseDto>> GetDriverLocationAsync(long driverId, CancellationToken cancellationToken = default);
    Task<Result> UpdateTripStatusAsync(TripStatusUpdateDto request, CancellationToken cancellationToken = default);
}
