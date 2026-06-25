using AlexandriaMobilityPlatform.Application.Common.Interfaces;
using AlexandriaMobilityPlatform.Application.Common.Models;
using AlexandriaMobilityPlatform.Application.DTOs.Vehicle;
using AlexandriaMobilityPlatform.Application.Interfaces.Services;
using AlexandriaMobilityPlatform.Domain.Entities;
using Microsoft.EntityFrameworkCore;

namespace AlexandriaMobilityPlatform.Infrastructure.Services;

public class VehicleService : IVehicleService
{
    private readonly IApplicationDbContext _context;
    public VehicleService(IApplicationDbContext context) => _context = context;

    public async Task<Result<VehicleDto>> GetByIdAsync(long id, CancellationToken cancellationToken = default)
    {
        var vehicle = await _context.Vehicles.Include(v => v.Driver).FirstOrDefaultAsync(v => v.Id == id, cancellationToken);
        if (vehicle == null) return Result<VehicleDto>.NotFound("Vehicle not found");
        return Result<VehicleDto>.Success(new VehicleDto(vehicle.Id, vehicle.DriverId, vehicle.Driver?.FullName ?? "", vehicle.PlateNumber, vehicle.Model, vehicle.Color ?? "", vehicle.Capacity, vehicle.Year, vehicle.IsActive));
    }

    public async Task<Result<PaginatedList<VehicleDto>>> GetByCommunityAsync(long communityId, int pageNumber, int pageSize, CancellationToken cancellationToken = default)
    {
        var query = _context.Vehicles.Include(v => v.Driver).Where(v => v.CommunityId == communityId);
        var count = await query.CountAsync(cancellationToken);
        var items = await query.Skip((pageNumber - 1) * pageSize).Take(pageSize)
            .Select(v => new VehicleDto(v.Id, v.DriverId, v.Driver!.FullName, v.PlateNumber, v.Model, v.Color ?? "", v.Capacity, v.Year, v.IsActive))
            .ToListAsync(cancellationToken);
        return Result<PaginatedList<VehicleDto>>.Success(new PaginatedList<VehicleDto>(items, count, pageNumber, pageSize));
    }

    public async Task<Result<VehicleDto>> CreateAsync(CreateVehicleRequest request, CancellationToken cancellationToken = default)
    {
        var vehicle = new Vehicle
        {
            DriverId = request.DriverId,
            PlateNumber = request.PlateNumber,
            Model = request.Model,
            Color = request.Color,
            Capacity = request.Capacity,
            Year = request.Year,
            IsActive = true,
            CreatedAt = DateTimeOffset.UtcNow
        };
        _context.Vehicles.Add(vehicle);
        await _context.SaveChangesAsync(cancellationToken);
        return await GetByIdAsync(vehicle.Id, cancellationToken);
    }

    public async Task<Result<VehicleDto>> UpdateAsync(long id, UpdateVehicleRequest request, CancellationToken cancellationToken = default)
    {
        var vehicle = await _context.Vehicles.FindAsync(new object[] { id }, cancellationToken);
        if (vehicle == null) return Result<VehicleDto>.NotFound("Vehicle not found");
        vehicle.PlateNumber = request.PlateNumber;
        vehicle.Model = request.Model;
        vehicle.Color = request.Color;
        vehicle.Capacity = request.Capacity;
        vehicle.Year = request.Year;
        vehicle.IsActive = request.IsActive;
        vehicle.UpdatedAt = DateTimeOffset.UtcNow;
        await _context.SaveChangesAsync(cancellationToken);
        return await GetByIdAsync(id, cancellationToken);
    }

    public async Task<Result> DeleteAsync(long id, CancellationToken cancellationToken = default)
    {
        var vehicle = await _context.Vehicles.FindAsync(new object[] { id }, cancellationToken);
        if (vehicle == null) return Result.Failure("Vehicle not found");
        vehicle.IsDeleted = true;
        vehicle.DeletedAt = DateTimeOffset.UtcNow;
        await _context.SaveChangesAsync(cancellationToken);
        return Result.Success("Vehicle deleted");
    }
}
