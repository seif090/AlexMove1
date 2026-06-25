using AlexandriaMobilityPlatform.Application.Common.Interfaces;
using AlexandriaMobilityPlatform.Application.Common.Models;
using AlexandriaMobilityPlatform.Application.DTOs.Dashboard;
using AlexandriaMobilityPlatform.Application.Interfaces.Services;
using AlexandriaMobilityPlatform.Domain.Enums;
using Microsoft.EntityFrameworkCore;

namespace AlexandriaMobilityPlatform.Infrastructure.Services;

public class DashboardService : IDashboardService
{
    private readonly IApplicationDbContext _context;
    private readonly ICurrentUserService _currentUser;
    public DashboardService(IApplicationDbContext context, ICurrentUserService currentUser) { _context = context; _currentUser = currentUser; }

    public async Task<Result<SuperAdminDashboardDto>> GetSuperAdminDashboardAsync(CancellationToken cancellationToken = default)
    {
        var today = DateTime.Today;
        var totalRevenue = await _context.Payments.Where(p => p.Status == PaymentStatusEnum.Success).SumAsync(p => p.Amount, cancellationToken);
        var dailyStats = Enumerable.Range(-6, 7).Select(offset => today.AddDays(offset)).Select(date => new DailyStatDto(date, _context.Bookings.Count(b => b.BookingDate == date), _context.Payments.Where(p => p.PaidAt.HasValue && p.PaidAt.Value.Date == date && p.Status == PaymentStatusEnum.Success).Sum(p => p.Amount))).ToList();

        var popularRoutes = await _context.Bookings.Include(b => b.Group).ThenInclude(g => g!.Route).GroupBy(b => b.Group!.Route!.Name).Select(g => new PopularRouteDto(g.Key, g.Count())).OrderByDescending(r => r.BookingCount).Take(5).ToListAsync(cancellationToken);

        var dto = new SuperAdminDashboardDto(
            await _context.Users.CountAsync(cancellationToken),
            await _context.Users.CountAsync(u => u.NormalizedUserName == "DRIVER", cancellationToken),
            await _context.Communities.CountAsync(c => !c.IsDeleted, cancellationToken),
            await _context.Groups.CountAsync(g => !g.IsDeleted, cancellationToken),
            await _context.Bookings.CountAsync(cancellationToken),
            await _context.Bookings.CountAsync(b => b.Status == BookingStatusEnum.Confirmed && b.BookingDate == today, cancellationToken),
            totalRevenue, new List<RecentActivityDto>(), popularRoutes, dailyStats);

        return Result<SuperAdminDashboardDto>.Success(dto);
    }

    public async Task<Result<CommunityAdminDashboardDto>> GetCommunityAdminDashboardAsync(long communityId, CancellationToken cancellationToken = default)
    {
        var community = await _context.Communities.FindAsync(new object[] { communityId }, cancellationToken);
        var today = DateTime.Today;

        var dto = new CommunityAdminDashboardDto(
            communityId, community?.Name ?? "",
            await _context.CommunityMembers.CountAsync(cm => cm.CommunityId == communityId && cm.Status == MemberStatusEnum.Approved, cancellationToken),
            await _context.Routes.CountAsync(r => r.CommunityId == communityId && !r.IsDeleted, cancellationToken),
            await _context.Groups.CountAsync(g => g.CommunityId == communityId && !g.IsDeleted, cancellationToken),
            await _context.Groups.CountAsync(g => g.CommunityId == communityId && g.Status == GroupStatusEnum.Active, cancellationToken),
            await _context.Bookings.Include(b => b.Group).CountAsync(b => b.Group!.CommunityId == communityId && b.BookingDate == today, cancellationToken),
            new List<RouteStatDto>());

        return Result<CommunityAdminDashboardDto>.Success(dto);
    }

    public async Task<Result<DriverDashboardDto>> GetDriverDashboardAsync(CancellationToken cancellationToken = default)
    {
        var userId = _currentUser.UserId!.Value;
        var today = DateTime.Today;

        var dto = new DriverDashboardDto(
            await _context.Trips.CountAsync(t => t.Group!.DriverId == userId, cancellationToken),
            await _context.Trips.CountAsync(t => t.Group!.DriverId == userId && t.TripDate == today, cancellationToken),
            await _context.Trips.CountAsync(t => t.Group!.DriverId == userId && t.Status == TripStatusEnum.Completed, cancellationToken),
            await _context.Bookings.CountAsync(b => b.Group!.DriverId == userId && b.Status == BookingStatusEnum.Confirmed, cancellationToken),
            new List<UpcomingTripDto>());

        return Result<DriverDashboardDto>.Success(dto);
    }
}
