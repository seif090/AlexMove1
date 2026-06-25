using AlexandriaMobilityPlatform.Application.Common.Interfaces;
using AlexandriaMobilityPlatform.Application.Interfaces.Repositories;
using AlexandriaMobilityPlatform.Application.Interfaces.Services;
using AlexandriaMobilityPlatform.Infrastructure.Caching;
using AlexandriaMobilityPlatform.Infrastructure.Data;
using AlexandriaMobilityPlatform.Infrastructure.Repositories;
using AlexandriaMobilityPlatform.Infrastructure.Services;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Caching.StackExchangeRedis;

namespace AlexandriaMobilityPlatform.Infrastructure;

public static class InfrastructureServiceRegistration
{
    public static IServiceCollection AddInfrastructureServices(this IServiceCollection services, IConfiguration configuration)
    {
        services.AddDbContext<ApplicationDbContext>(options =>
            options.UseSqlServer(configuration.GetConnectionString("DefaultConnection"),
            b => b.MigrationsAssembly(typeof(ApplicationDbContext).Assembly.FullName)));

        services.AddScoped(typeof(IGenericRepository<>), typeof(GenericRepository<>));
        services.AddScoped<IApplicationDbContext>(provider => provider.GetRequiredService<ApplicationDbContext>());
        services.AddScoped<IDateTime, DateTimeService>();
        services.AddSingleton<ICacheService, RedisCacheService>();
        services.AddSingleton<INotificationService, NotificationService>();
        services.AddSingleton<IEmailService, EmailService>();

        services.AddScoped<IAuthService, AuthService>();
        services.AddScoped<ICommunityService, CommunityService>();
        services.AddScoped<IRouteService, RouteService>();
        services.AddScoped<IGroupService, GroupService>();
        services.AddScoped<IBookingService, BookingService>();
        services.AddScoped<IVehicleService, VehicleService>();
        services.AddScoped<IUserService, UserService>();
        services.AddScoped<IDashboardService, DashboardService>();
        services.AddScoped<INotificationAppService, NotificationAppService>();
        services.AddScoped<ITrackingService, TrackingService>();
        services.AddScoped<IUnitOfWork, UnitOfWork>();

        services.AddStackExchangeRedisCache(options =>
        {
            options.Configuration = configuration.GetConnectionString("Redis");
            options.InstanceName = "AlexMobility_";
        });
        return services;
    }
}
