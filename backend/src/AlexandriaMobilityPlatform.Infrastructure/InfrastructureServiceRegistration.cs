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

        services.AddHostedService<SeedDataHostedService>();

        var redisConnection = configuration.GetConnectionString("Redis");
        if (!string.IsNullOrEmpty(redisConnection))
        {
            try
            {
                services.AddStackExchangeRedisCache(options =>
                {
                    options.Configuration = redisConnection;
                    options.InstanceName = "AlexMobility_";
                });
                services.AddSingleton<ICacheService, RedisCacheService>();
            }
            catch
            {
                services.AddMemoryCache();
                services.AddSingleton<ICacheService, MemoryCacheService>();
            }
        }
        else
        {
            services.AddMemoryCache();
            services.AddSingleton<ICacheService, MemoryCacheService>();
        }
        return services;
    }
}
