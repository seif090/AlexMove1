using AlexandriaMobilityPlatform.Domain.Entities;
using AlexandriaMobilityPlatform.Domain.Enums;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;

namespace AlexandriaMobilityPlatform.Infrastructure.Data;

public static class SeedData
{
    public static async Task InitializeAsync(IServiceProvider serviceProvider)
    {
        using var scope = serviceProvider.CreateScope();
        var context = scope.ServiceProvider.GetRequiredService<ApplicationDbContext>();
        var userManager = scope.ServiceProvider.GetRequiredService<UserManager<ApplicationUser>>();
        var roleManager = scope.ServiceProvider.GetRequiredService<RoleManager<IdentityRole<long>>>();

        await context.Database.EnsureCreatedAsync();

        await SeedRolesAsync(roleManager);
        var superAdmin = await SeedSuperAdminAsync(userManager);
        var driver = await SeedDriverAsync(userManager);
        var community = await SeedCommunityAsync(context, superAdmin);
        await SeedRoutesAsync(context, community);
        await SeedGroupsAsync(context, community, driver);
    }

    private static async Task SeedRolesAsync(RoleManager<IdentityRole<long>> roleManager)
    {
        string[] roles = { "SuperAdmin", "CommunityAdmin", "Driver", "Passenger" };
        foreach (var role in roles)
        {
            if (!await roleManager.RoleExistsAsync(role))
            {
                await roleManager.CreateAsync(new IdentityRole<long> { Name = role, NormalizedName = role.ToUpper() });
            }
        }
    }

    private static async Task<ApplicationUser> SeedSuperAdminAsync(UserManager<ApplicationUser> userManager)
    {
        var existing = await userManager.FindByEmailAsync("admin@alexmobility.com");
        if (existing != null) return existing;

        var password = Environment.GetEnvironmentVariable("SEED_ADMIN_PASSWORD") ?? "Admin@123456";

        var user = new ApplicationUser
        {
            UserName = "admin@alexmobility.com",
            Email = "admin@alexmobility.com",
            PhoneNumber = "+201000000001",
            FullName = "Super Admin",
            PreferredLanguage = "en",
            IsActive = true,
            EmailConfirmed = true,
            PhoneNumberConfirmed = true,
            CreatedAt = DateTimeOffset.UtcNow
        };

        await userManager.CreateAsync(user, password);
        await userManager.AddToRoleAsync(user, "SuperAdmin");
        return user;
    }

    private static async Task<ApplicationUser> SeedDriverAsync(UserManager<ApplicationUser> userManager)
    {
        var existing = await userManager.FindByEmailAsync("driver@alexmobility.com");
        if (existing != null) return existing;

        var password = Environment.GetEnvironmentVariable("SEED_DRIVER_PASSWORD") ?? "Driver@123456";

        var user = new ApplicationUser
        {
            UserName = "driver@alexmobility.com",
            Email = "driver@alexmobility.com",
            PhoneNumber = "+201000000002",
            FullName = "Mohamed Driver",
            PreferredLanguage = "ar",
            IsActive = true,
            EmailConfirmed = true,
            PhoneNumberConfirmed = true,
            CreatedAt = DateTimeOffset.UtcNow
        };

        await userManager.CreateAsync(user, password);
        await userManager.AddToRoleAsync(user, "Driver");
        return user;
    }

    private static async Task<Community> SeedCommunityAsync(ApplicationDbContext context, ApplicationUser admin)
    {
        var existing = await context.Communities.FirstOrDefaultAsync(c => c.Name == "Alexandria Tech Hub");
        if (existing != null) return existing;

        var community = new Community
        {
            Name = "Alexandria Tech Hub",
            Type = CommunityTypeEnum.Company,
            City = "Alexandria",
            Area = "Smouha",
            Address = "Smouha, Alexandria, Egypt",
            AdminId = admin.Id,
            IsActive = true,
            CreatedAt = DateTimeOffset.UtcNow
        };

        context.Communities.Add(community);
        await context.SaveChangesAsync();
        return community;
    }

    private static async Task SeedRoutesAsync(ApplicationDbContext context, Community community)
    {
        if (await context.Routes.AnyAsync(r => r.CommunityId == community.Id)) return;

        var route1 = new AlexandriaMobilityPlatform.Domain.Entities.Route
        {
            CommunityId = community.Id,
            Name = "Route A - Smouha to New Borg",
            StartPoint = "Smouha Sporting Club",
            EndPoint = "New Borg El Arab",
            StartLatitude = 31.2001m,
            StartLongitude = 29.9187m,
            EndLatitude = 30.8576m,
            EndLongitude = 29.5321m,
            DistanceKm = 35.5m,
            EstimatedTimeMinutes = 45,
            IsActive = true,
            CreatedAt = DateTimeOffset.UtcNow
        };

        var route2 = new AlexandriaMobilityPlatform.Domain.Entities.Route
        {
            CommunityId = community.Id,
            Name = "Route B - Downtown to Campus",
            StartPoint = "Alexandria Downtown",
            EndPoint = "Borg El Arab Campus",
            StartLatitude = 31.2001m,
            StartLongitude = 29.8951m,
            EndLatitude = 30.8576m,
            EndLongitude = 29.5321m,
            DistanceKm = 28.3m,
            EstimatedTimeMinutes = 35,
            IsActive = true,
            CreatedAt = DateTimeOffset.UtcNow
        };

        context.Routes.AddRange(route1, route2);
        await context.SaveChangesAsync();

        var stops1 = new List<Stop>
        {
            new() { RouteId = route1.Id, Name = "Smouha Sporting Club", Latitude = 31.2001m, Longitude = 29.9187m, OrderNumber = 1, EstimatedArrivalMinutes = 0 },
            new() { RouteId = route1.Id, Name = "San Stefano", Latitude = 31.2088m, Longitude = 29.8922m, OrderNumber = 2, EstimatedArrivalMinutes = 8 },
            new() { RouteId = route1.Id, Name = "Mandara", Latitude = 31.1850m, Longitude = 29.8620m, OrderNumber = 3, EstimatedArrivalMinutes = 18 },
            new() { RouteId = route1.Id, Name = "El Mamoura", Latitude = 31.1200m, Longitude = 29.8300m, OrderNumber = 4, EstimatedArrivalMinutes = 28 },
            new() { RouteId = route1.Id, Name = "New Borg El Arab", Latitude = 30.8576m, Longitude = 29.5321m, OrderNumber = 5, EstimatedArrivalMinutes = 45 }
        };

        var stops2 = new List<Stop>
        {
            new() { RouteId = route2.Id, Name = "Alexandria Downtown", Latitude = 31.2001m, Longitude = 29.8951m, OrderNumber = 1, EstimatedArrivalMinutes = 0 },
            new() { RouteId = route2.Id, Name = "Raml Station", Latitude = 31.2011m, Longitude = 29.9012m, OrderNumber = 2, EstimatedArrivalMinutes = 5 },
            new() { RouteId = route2.Id, Name = "Sporting", Latitude = 31.2150m, Longitude = 29.9350m, OrderNumber = 3, EstimatedArrivalMinutes = 15 },
            new() { RouteId = route2.Id, Name = "Borg El Arab Campus", Latitude = 30.8576m, Longitude = 29.5321m, OrderNumber = 4, EstimatedArrivalMinutes = 35 }
        };

        context.Stops.AddRange(stops1);
        context.Stops.AddRange(stops2);
        await context.SaveChangesAsync();
    }

    private static async Task SeedGroupsAsync(ApplicationDbContext context, Community community, ApplicationUser driver)
    {
        if (await context.Groups.AnyAsync(g => g.CommunityId == community.Id)) return;

        var route1 = await context.Routes.FirstOrDefaultAsync(r => r.CommunityId == community.Id && r.Name.Contains("Route A"));
        var route2 = await context.Routes.FirstOrDefaultAsync(r => r.CommunityId == community.Id && r.Name.Contains("Route B"));

        if (route1 == null || route2 == null) return;

        var vehicle = new Vehicle
        {
            DriverId = driver.Id,
            CommunityId = community.Id,
            PlateNumber = "ABC-1234",
            Model = "Toyota Hiace",
            Color = "White",
            Capacity = 14,
            Year = 2023,
            IsActive = true,
            CreatedAt = DateTimeOffset.UtcNow
        };

        context.Vehicles.Add(vehicle);
        await context.SaveChangesAsync();

        var groups = new List<Group>
        {
            new()
            {
                CommunityId = community.Id,
                RouteId = route1.Id,
                DriverId = driver.Id,
                VehicleId = vehicle.Id,
                Name = "Morning Group A",
                Capacity = 14,
                AvailableSeats = 8,
                DepartureTime = new TimeSpan(7, 30, 0),
                ReturnTime = new TimeSpan(17, 0, 0),
                WorkingDays = 62,
                Status = GroupStatusEnum.Active,
                Price = 50m,
                CreatedAt = DateTimeOffset.UtcNow
            },
            new()
            {
                CommunityId = community.Id,
                RouteId = route2.Id,
                DriverId = driver.Id,
                VehicleId = vehicle.Id,
                Name = "Afternoon Group B",
                Capacity = 14,
                AvailableSeats = 12,
                DepartureTime = new TimeSpan(13, 0, 0),
                ReturnTime = new TimeSpan(21, 0, 0),
                WorkingDays = 62,
                Status = GroupStatusEnum.Active,
                Price = 40m,
                CreatedAt = DateTimeOffset.UtcNow
            }
        };

        context.Groups.AddRange(groups);
        await context.SaveChangesAsync();
    }
}
