using AlexandriaMobilityPlatform.Application.Common.Interfaces;
using AlexandriaMobilityPlatform.Application.Interfaces.Repositories;
using AlexandriaMobilityPlatform.Application.Interfaces.Services;
using AlexandriaMobilityPlatform.Domain.Entities;
using AlexandriaMobilityPlatform.Infrastructure.Caching;
using AlexandriaMobilityPlatform.Infrastructure.Data;
using AlexandriaMobilityPlatform.Infrastructure.Identity;
using AlexandriaMobilityPlatform.Infrastructure.Repositories;
using AlexandriaMobilityPlatform.Infrastructure.Services;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace AlexandriaMobilityPlatform.Infrastructure;

public static class InfrastructureServiceRegistration
{
    public static IServiceCollection AddInfrastructureServices(this IServiceCollection services, IConfiguration configuration)
    {
        services.AddDbContext<ApplicationDbContext>(options =>
            options.UseSqlServer(configuration.GetConnectionString("DefaultConnection"),
            b => b.MigrationsAssembly(typeof(ApplicationDbContext).Assembly.FullName)));

        services.AddIdentity<ApplicationUser, IdentityRole<long>>(options =>
        {
            options.Password.RequireDigit = true;
            options.Password.RequireLowercase = true;
            options.Password.RequireUppercase = true;
            options.Password.RequireNonAlphanumeric = true;
            options.Password.RequiredLength = 8;
            options.User.RequireUniqueEmail = true;
        })
        .AddEntityFrameworkStores<ApplicationDbContext>()
        .AddDefaultTokenProviders();

        services.AddScoped(typeof(IGenericRepository<>), typeof(GenericRepository<>));
        services.AddScoped<IApplicationDbContext>(provider => provider.GetRequiredService<ApplicationDbContext>());
        services.AddScoped<IDateTime, DateTimeService>();
        services.AddScoped<ICurrentUserService, CurrentUserService>();
        services.AddScoped<INotificationService, NotificationService>();
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

        services.Configure<EmailSettings>(configuration.GetSection("EmailSettings"));

        services.AddHostedService<SeedDataHostedService>();

        services.AddMemoryCache();
        services.AddSingleton<ICacheService, MemoryCacheService>();

        return services;
    }
}
