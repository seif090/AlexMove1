using AlexandriaMobilityPlatform.Application.Common.Interfaces;
using AlexandriaMobilityPlatform.Application.Common.Models;
using AlexandriaMobilityPlatform.Application.DTOs.Tracking;
using AlexandriaMobilityPlatform.Application.Interfaces.Services;
using AlexandriaMobilityPlatform.Domain.Entities;
using AlexandriaMobilityPlatform.Domain.Enums;
using Microsoft.EntityFrameworkCore;

namespace AlexandriaMobilityPlatform.Infrastructure.Services;

public class TrackingService : ITrackingService
{
    private readonly IApplicationDbContext _context;
    public TrackingService(IApplicationDbContext context) => _context = context;

    public async Task<Result> UpdateDriverLocationAsync(DriverLocationUpdateDto request, CancellationToken cancellationToken = default)
    {
        var trip = await _context.Trips
            .Include(t => t.Group)
            .FirstOrDefaultAsync(t => t.Id == request.TripId, cancellationToken);

        var location = new DriverLocation
        {
            TripId = request.TripId,
            DriverId = trip?.Group?.DriverId ?? 0,
            Latitude = request.Latitude,
            Longitude = request.Longitude,
            AccuracyMeters = request.AccuracyMeters,
            RecordedAt = DateTimeOffset.UtcNow
        };
        _context.DriverLocations.Add(location);
        await _context.SaveChangesAsync(cancellationToken);
        return Result.Success("Location updated");
    }

    public async Task<Result<DriverLocationResponseDto>> GetDriverLocationAsync(long driverId, CancellationToken cancellationToken = default)
    {
        var location = await _context.DriverLocations
            .Include(dl => dl.Driver)
            .Where(dl => dl.DriverId == driverId)
            .OrderByDescending(dl => dl.RecordedAt)
            .FirstOrDefaultAsync(cancellationToken);

        if (location == null) return Result<DriverLocationResponseDto>.NotFound("Driver location not found");

        return Result<DriverLocationResponseDto>.Success(new DriverLocationResponseDto(
            location.DriverId, location.Driver?.FullName ?? "",
            location.Latitude, location.Longitude, location.RecordedAt.DateTime));
    }

    public async Task<Result> UpdateTripStatusAsync(TripStatusUpdateDto request, CancellationToken cancellationToken = default)
    {
        var trip = await _context.Trips.FindAsync(new object[] { request.TripId }, cancellationToken);
        if (trip == null) return Result.Failure("Trip not found");

        trip.Status = Enum.Parse<TripStatusEnum>(request.Status);
        if (trip.Status == TripStatusEnum.Started) trip.StartedAt = DateTimeOffset.UtcNow;
        if (trip.Status == TripStatusEnum.Completed) trip.CompletedAt = DateTimeOffset.UtcNow;

        await _context.SaveChangesAsync(cancellationToken);
        return Result.Success("Trip status updated");
    }
}
