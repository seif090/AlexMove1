using AlexandriaMobilityPlatform.Application.Common.Interfaces;
using AlexandriaMobilityPlatform.Domain.Entities;

namespace AlexandriaMobilityPlatform.API.Middleware;

public class AuditLoggingMiddleware
{
    private readonly RequestDelegate _next;
    public AuditLoggingMiddleware(RequestDelegate next) => _next = next;

    public async Task InvokeAsync(HttpContext context)
    {
        await _next(context);
        if (context.Request.Method is "POST" or "PUT" or "DELETE" && context.Response.StatusCode < 400)
        {
            var currentUser = context.RequestServices.GetService<ICurrentUserService>();
            if (currentUser?.IsAuthenticated == true)
            {
                var auditLog = new AuditLog
                {
                    UserId = currentUser.UserId,
                    EntityType = context.Request.Path.Value?.Split('/').LastOrDefault() ?? "Unknown",
                    Action = context.Request.Method,
                    IpAddress = context.Connection.RemoteIpAddress?.ToString(),
                    UserAgent = context.Request.Headers.UserAgent.ToString(),
                    OccurredAt = DateTimeOffset.UtcNow
                };
            }
        }
    }
}
