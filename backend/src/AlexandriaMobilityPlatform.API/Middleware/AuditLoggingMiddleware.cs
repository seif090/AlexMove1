using AlexandriaMobilityPlatform.Application.Common.Interfaces;
using AlexandriaMobilityPlatform.Domain.Entities;
using System.Text.Json;

namespace AlexandriaMobilityPlatform.API.Middleware;

public class AuditLoggingMiddleware
{
    private readonly RequestDelegate _next;

    public AuditLoggingMiddleware(RequestDelegate next) => _next = next;

    public async Task InvokeAsync(HttpContext context)
    {
        var requestBody = string.Empty;
        if (context.Request.Method is "POST" or "PUT" or "DELETE" && context.Request.ContentLength > 0)
        {
            context.Request.EnableBuffering();
            using var reader = new StreamReader(context.Request.Body, leaveOpen: true);
            requestBody = await reader.ReadToEndAsync();
            context.Request.Body.Position = 0;
        }

        await _next(context);

        if (context.Request.Method is "POST" or "PUT" or "DELETE" && context.Response.StatusCode < 400)
        {
            try
            {
                var scopeFactory = context.RequestServices.GetRequiredService<IServiceScopeFactory>();
                using var scope = scopeFactory.CreateScope();
                var currentUser = scope.ServiceProvider.GetService<ICurrentUserService>();
                var dbContext = scope.ServiceProvider.GetService<IApplicationDbContext>();

                if (currentUser?.IsAuthenticated == true && dbContext != null)
                {
                    var auditLog = new AuditLog
                    {
                        UserId = currentUser.UserId,
                        EntityType = ExtractEntityType(context.Request.Path.Value),
                        EntityId = ExtractEntityId(context.Request.Path.Value),
                        Action = context.Request.Method,
                        OldValuesJson = "",
                        NewValuesJson = requestBody.Length > 4000 ? requestBody[..4000] : requestBody,
                        IpAddress = context.Connection.RemoteIpAddress?.ToString(),
                        UserAgent = context.Request.Headers.UserAgent.ToString(),
                        OccurredAt = DateTimeOffset.UtcNow
                    };

                    dbContext.AuditLogs.Add(auditLog);
                    await dbContext.SaveChangesAsync();
                }
            }
            catch (Exception ex)
            {
                var logger = context.RequestServices.GetService<ILogger<AuditLoggingMiddleware>>();
                logger?.LogWarning(ex, "Failed to write audit log for {Method} {Path}", context.Request.Method, context.Request.Path);
            }
        }
    }

    private static string ExtractEntityType(string? path)
    {
        if (string.IsNullOrEmpty(path)) return "Unknown";
        var segments = path.Split('/', StringSplitOptions.RemoveEmptyEntries);
        return segments.Length >= 2 ? segments[1] : "Unknown";
    }

    private static long ExtractEntityId(string? path)
    {
        if (string.IsNullOrEmpty(path)) return 0;
        var segments = path.Split('/', StringSplitOptions.RemoveEmptyEntries);
        if (segments.Length >= 3 && long.TryParse(segments[^1], out var id))
            return id;
        return 0;
    }
}
