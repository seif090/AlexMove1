using AlexandriaMobilityPlatform.Application.Common.Interfaces;
using AlexandriaMobilityPlatform.Application.Common.Models;
using AlexandriaMobilityPlatform.Application.DTOs.Route;
using AlexandriaMobilityPlatform.Application.Interfaces.Services;
using AlexandriaMobilityPlatform.Domain.Entities;
using Microsoft.EntityFrameworkCore;

namespace AlexandriaMobilityPlatform.Infrastructure.Services;

public class RouteService : IRouteService
{
    private readonly IApplicationDbContext _context;
    public RouteService(IApplicationDbContext context) => _context = context;

    public async Task<Result<RouteDto>> GetByIdAsync(long id, CancellationToken cancellationToken = default)
    {
        var route = await _context.Routes
            .Include(r => r.Stops)
            .Include(r => r.Community)
            .FirstOrDefaultAsync(r => r.Id == id, cancellationToken);

        if (route == null) return Result<RouteDto>.NotFound("Route not found");

        var dto = new RouteDto(
            route.Id, route.CommunityId, route.Community?.Name ?? "",
            route.Name, route.StartPoint, route.EndPoint,
            route.StartLatitude, route.StartLongitude,
            route.EndLatitude, route.EndLongitude,
            route.DistanceKm, route.EstimatedTimeMinutes,
            route.Stops.OrderBy(s => s.OrderNumber).Select(s => new StopDto(s.Id, s.Name, s.Latitude, s.Longitude, s.OrderNumber, s.EstimatedArrivalMinutes)).ToList(),
            route.IsActive);

        return Result<RouteDto>.Success(dto);
    }

    public async Task<Result<PaginatedList<RouteDto>>> GetByCommunityAsync(long communityId, int pageNumber, int pageSize, CancellationToken cancellationToken = default)
    {
        var query = _context.Routes
            .Include(r => r.Stops)
            .Include(r => r.Community)
            .Where(r => r.CommunityId == communityId);

        var count = await query.CountAsync(cancellationToken);
        var items = await query
            .OrderByDescending(r => r.CreatedAt)
            .Skip((pageNumber - 1) * pageSize)
            .Take(pageSize)
            .Select(r => new RouteDto(
                r.Id, r.CommunityId, r.Community!.Name,
                r.Name, r.StartPoint, r.EndPoint,
                r.StartLatitude, r.StartLongitude,
                r.EndLatitude, r.EndLongitude,
                r.DistanceKm, r.EstimatedTimeMinutes,
                r.Stops.Select(s => new StopDto(s.Id, s.Name, s.Latitude, s.Longitude, s.OrderNumber, s.EstimatedArrivalMinutes)).ToList(),
                r.IsActive))
            .ToListAsync(cancellationToken);

        return Result<PaginatedList<RouteDto>>.Success(new PaginatedList<RouteDto>(items, count, pageNumber, pageSize));
    }

    public async Task<Result<RouteDto>> CreateAsync(CreateRouteRequest request, CancellationToken cancellationToken = default)
    {
        var route = new AlexandriaMobilityPlatform.Domain.Entities.Route
        {
            CommunityId = request.CommunityId,
            Name = request.Name,
            StartPoint = request.StartPoint,
            EndPoint = request.EndPoint,
            StartLatitude = request.StartLatitude,
            StartLongitude = request.StartLongitude,
            EndLatitude = request.EndLatitude,
            EndLongitude = request.EndLongitude,
            DistanceKm = request.DistanceKm,
            EstimatedTimeMinutes = request.EstimatedTimeMinutes,
            IsActive = true,
            CreatedAt = DateTimeOffset.UtcNow
        };

        _context.Routes.Add(route);
        await _context.SaveChangesAsync(cancellationToken);

        if (request.Stops?.Any() == true)
        {
            var stops = request.Stops.Select(s => new Stop
            {
                RouteId = route.Id,
                Name = s.Name,
                Latitude = s.Latitude,
                Longitude = s.Longitude,
                OrderNumber = s.OrderNumber,
                EstimatedArrivalMinutes = s.EstimatedArrivalMinutes
            }).ToList();

            _context.Stops.AddRange(stops);
            await _context.SaveChangesAsync(cancellationToken);
        }

        return await GetByIdAsync(route.Id, cancellationToken);
    }

    public async Task<Result<RouteDto>> UpdateAsync(long id, UpdateRouteRequest request, CancellationToken cancellationToken = default)
    {
        var route = await _context.Routes.Include(r => r.Stops).FirstOrDefaultAsync(r => r.Id == id, cancellationToken);
        if (route == null) return Result<RouteDto>.NotFound("Route not found");

        route.Name = request.Name;
        route.StartPoint = request.StartPoint;
        route.EndPoint = request.EndPoint;
        route.StartLatitude = request.StartLatitude;
        route.StartLongitude = request.StartLongitude;
        route.EndLatitude = request.EndLatitude;
        route.EndLongitude = request.EndLongitude;
        route.DistanceKm = request.DistanceKm;
        route.EstimatedTimeMinutes = request.EstimatedTimeMinutes;
        route.IsActive = request.IsActive;
        route.UpdatedAt = DateTimeOffset.UtcNow;

        _context.Stops.RemoveRange(route.Stops);
        if (request.Stops?.Any() == true)
        {
            var stops = request.Stops.Select(s => new Stop
            {
                RouteId = route.Id,
                Name = s.Name,
                Latitude = s.Latitude,
                Longitude = s.Longitude,
                OrderNumber = s.OrderNumber,
                EstimatedArrivalMinutes = s.EstimatedArrivalMinutes
            }).ToList();
            _context.Stops.AddRange(stops);
        }

        await _context.SaveChangesAsync(cancellationToken);
        return await GetByIdAsync(id, cancellationToken);
    }

    public async Task<Result> DeleteAsync(long id, CancellationToken cancellationToken = default)
    {
        var route = await _context.Routes.FindAsync(new object[] { id }, cancellationToken);
        if (route == null) return Result.Failure("Route not found");
        route.IsDeleted = true;
        route.DeletedAt = DateTimeOffset.UtcNow;
        await _context.SaveChangesAsync(cancellationToken);
        return Result.Success("Route deleted");
    }
}
