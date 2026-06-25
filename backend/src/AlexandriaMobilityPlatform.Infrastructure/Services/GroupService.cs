using AlexandriaMobilityPlatform.Application.Common.Interfaces;
using AlexandriaMobilityPlatform.Application.Common.Models;
using AlexandriaMobilityPlatform.Application.DTOs.Group;
using AlexandriaMobilityPlatform.Application.Interfaces.Services;
using AlexandriaMobilityPlatform.Domain.Enums;
using Microsoft.EntityFrameworkCore;

namespace AlexandriaMobilityPlatform.Infrastructure.Services;

public class GroupService : IGroupService
{
    private readonly IApplicationDbContext _context;
    private readonly ICurrentUserService _currentUser;
    private readonly ICacheService _cache;

    public GroupService(IApplicationDbContext context, ICurrentUserService currentUser, ICacheService cache)
    {
        _context = context;
        _currentUser = currentUser;
        _cache = cache;
    }

    public async Task<Result<GroupDto>> GetByIdAsync(long id, CancellationToken cancellationToken = default)
    {
        var cacheKey = $"group_{id}";
        var cached = await _cache.GetAsync<GroupDto>(cacheKey, cancellationToken);
        if (cached != null) return Result<GroupDto>.Success(cached);

        var group = await _context.Groups
            .Include(g => g.Community)
            .Include(g => g.Route)
            .Include(g => g.Driver)
            .Include(g => g.Vehicle)
            .Include(g => g.Bookings)
            .FirstOrDefaultAsync(g => g.Id == id, cancellationToken);

        if (group == null) return Result<GroupDto>.NotFound("Group not found");

        var userId = _currentUser.UserId;
        var isSubscribed = userId.HasValue && await _context.Bookings.AnyAsync(b => b.GroupId == id && b.UserId == userId && b.Status == BookingStatusEnum.Confirmed, cancellationToken);

        var dto = MapToDto(group, isSubscribed);
        await _cache.SetAsync(cacheKey, dto, TimeSpan.FromMinutes(2), cancellationToken);
        return Result<GroupDto>.Success(dto);
    }

    public async Task<Result<PaginatedList<GroupDto>>> GetByCommunityAsync(long communityId, int pageNumber, int pageSize, CancellationToken cancellationToken = default)
    {
        var query = _context.Groups
            .Include(g => g.Community)
            .Include(g => g.Route)
            .Include(g => g.Driver)
            .Include(g => g.Vehicle)
            .Include(g => g.Bookings)
            .Where(g => g.CommunityId == communityId && g.Status == GroupStatusEnum.Active);

        var count = await query.CountAsync(cancellationToken);
        var items = await query
            .OrderBy(g => g.DepartureTime)
            .Skip((pageNumber - 1) * pageSize)
            .Take(pageSize)
            .ToListAsync(cancellationToken);

        var dtos = items.Select(g => MapToDto(g, false)).ToList();
        return Result<PaginatedList<GroupDto>>.Success(new PaginatedList<GroupDto>(dtos, count, pageNumber, pageSize));
    }

    public async Task<Result<PaginatedList<GroupDto>>> SearchAsync(GroupSearchRequest request, CancellationToken cancellationToken = default)
    {
        var query = _context.Groups
            .Include(g => g.Community)
            .Include(g => g.Route)
            .Include(g => g.Driver)
            .Include(g => g.Vehicle)
            .Include(g => g.Bookings)
            .Where(g => g.CommunityId == request.CommunityId && g.Status == GroupStatusEnum.Active);

        if (!string.IsNullOrEmpty(request.Query))
        {
            var q = request.Query.ToLower();
            query = query.Where(g => g.Name.ToLower().Contains(q) || g.Route!.Name.ToLower().Contains(q) || g.Driver!.FullName.ToLower().Contains(q));
        }

        var count = await query.CountAsync(cancellationToken);
        var items = await query
            .OrderBy(g => g.DepartureTime)
            .Skip((request.PageNumber - 1) * request.PageSize)
            .Take(request.PageSize)
            .ToListAsync(cancellationToken);

        var dtos = items.Select(g => MapToDto(g, false)).ToList();
        return Result<PaginatedList<GroupDto>>.Success(new PaginatedList<GroupDto>(dtos, count, request.PageNumber, request.PageSize));
    }

    public async Task<Result<GroupDto>> CreateAsync(CreateGroupRequest request, CancellationToken cancellationToken = default)
    {
        var group = new Domain.Entities.Group
        {
            CommunityId = request.CommunityId,
            RouteId = request.RouteId,
            DriverId = request.DriverId,
            VehicleId = request.VehicleId,
            Name = request.Name,
            Capacity = request.Capacity,
            AvailableSeats = request.Capacity,
            DepartureTime = request.DepartureTime,
            ReturnTime = request.ReturnTime,
            WorkingDays = request.WorkingDays,
            Price = request.Price,
            Status = GroupStatusEnum.Active,
            CreatedAt = DateTimeOffset.UtcNow
        };

        _context.Groups.Add(group);
        await _context.SaveChangesAsync(cancellationToken);
        return await GetByIdAsync(group.Id, cancellationToken);
    }

    public async Task<Result<GroupDto>> UpdateAsync(long id, UpdateGroupRequest request, CancellationToken cancellationToken = default)
    {
        var group = await _context.Groups.FindAsync(new object[] { id }, cancellationToken);
        if (group == null) return Result<GroupDto>.NotFound("Group not found");

        group.DriverId = request.DriverId;
        group.VehicleId = request.VehicleId;
        group.Name = request.Name;
        group.Capacity = request.Capacity;
        group.DepartureTime = request.DepartureTime;
        group.ReturnTime = request.ReturnTime;
        group.WorkingDays = request.WorkingDays;
        group.Status = Enum.Parse<GroupStatusEnum>(request.Status);
        group.Price = request.Price;
        group.UpdatedAt = DateTimeOffset.UtcNow;

        await _context.SaveChangesAsync(cancellationToken);
        await _cache.RemoveAsync($"group_{id}", cancellationToken);
        return await GetByIdAsync(id, cancellationToken);
    }

    public async Task<Result> DeleteAsync(long id, CancellationToken cancellationToken = default)
    {
        var group = await _context.Groups.FindAsync(new object[] { id }, cancellationToken);
        if (group == null) return Result.Failure("Group not found");
        group.IsDeleted = true;
        group.DeletedAt = DateTimeOffset.UtcNow;
        await _context.SaveChangesAsync(cancellationToken);
        await _cache.RemoveAsync($"group_{id}", cancellationToken);
        return Result.Success("Group deleted");
    }

    public async Task<Result<List<GroupRecommendationDto>>> GetRecommendationsAsync(long communityId, decimal latitude, decimal longitude, TimeSpan preferredTime, CancellationToken cancellationToken = default)
    {
        var groups = await _context.Groups
            .Include(g => g.Route)
            .Include(g => g.Driver)
            .Where(g => g.CommunityId == communityId && g.Status == GroupStatusEnum.Active && g.AvailableSeats > 0)
            .ToListAsync(cancellationToken);

        var recommendations = groups
            .Select(g =>
            {
                var timeDiff = Math.Abs((g.DepartureTime - preferredTime).TotalMinutes);
                var timeScore = Math.Max(0.0, 100.0 - timeDiff);
                var seatScore = (double)g.AvailableSeats / g.Capacity * 100.0;
                var score = (timeScore * 0.6 + seatScore * 0.4);
                return new GroupRecommendationDto(g.Id, g.Name, g.Route?.Name ?? "", g.Driver?.FullName ?? "", g.DepartureTime, g.AvailableSeats, (decimal)Math.Round(score, 1));
            })
            .OrderByDescending(r => r.Score)
            .Take(5)
            .ToList();

        return Result<List<GroupRecommendationDto>>.Success(recommendations);
    }

    public async Task<Result<List<GroupDto>>> GetMyGroupsAsync(CancellationToken cancellationToken = default)
    {
        var userId = _currentUser.UserId!.Value;
        var groups = await _context.Bookings
            .Where(b => b.UserId == userId && b.Status == BookingStatusEnum.Confirmed)
            .Select(b => b.Group)
            .Distinct()
            .Include(g => g!.Community)
            .Include(g => g!.Route)
            .Include(g => g!.Driver)
            .Include(g => g!.Vehicle)
            .Include(g => g!.Bookings)
            .ToListAsync(cancellationToken);

        return Result<List<GroupDto>>.Success(groups.Select(g => MapToDto(g!, true)).ToList());
    }

    private static GroupDto MapToDto(Domain.Entities.Group group, bool isSubscribed)
    {
        return new GroupDto(
            group.Id, group.CommunityId, group.Community?.Name ?? "",
            group.RouteId, group.Route?.Name ?? "",
            group.DriverId, group.Driver?.FullName ?? "",
            group.VehicleId, group.Vehicle?.PlateNumber ?? "",
            group.Name, group.Capacity, group.AvailableSeats,
            group.DepartureTime, group.ReturnTime,
            group.WorkingDays, group.Status.ToString(),
            group.Price, isSubscribed);
    }
}
