using AlexandriaMobilityPlatform.Domain.Entities;
using Microsoft.EntityFrameworkCore;

namespace AlexandriaMobilityPlatform.Application.Common.Interfaces;

public interface IApplicationDbContext
{
    DbSet<ApplicationUser> Users { get; }
    DbSet<Community> Communities { get; }
    DbSet<CommunityMember> CommunityMembers { get; }
    DbSet<CommunityAdmin> CommunityAdmins { get; }
    DbSet<Route> Routes { get; }
    DbSet<Stop> Stops { get; }
    DbSet<Group> Groups { get; }
    DbSet<Vehicle> Vehicles { get; }
    DbSet<Booking> Bookings { get; }
    DbSet<Trip> Trips { get; }
    DbSet<DriverLocation> DriverLocations { get; }
    DbSet<Payment> Payments { get; }
    DbSet<Notification> Notifications { get; }
    DbSet<RefreshToken> RefreshTokens { get; }
    DbSet<AuditLog> AuditLogs { get; }
    DbSet<GroupSubscription> GroupSubscriptions { get; }
    Task<int> SaveChangesAsync(CancellationToken cancellationToken = default);
}
