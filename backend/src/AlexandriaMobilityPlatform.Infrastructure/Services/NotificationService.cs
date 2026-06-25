using AlexandriaMobilityPlatform.Application.Common.Interfaces;
using AlexandriaMobilityPlatform.Domain.Entities;
using AlexandriaMobilityPlatform.Domain.Enums;
using Microsoft.EntityFrameworkCore;
using System.Text.Json;

namespace AlexandriaMobilityPlatform.Infrastructure.Services;

public class NotificationService : INotificationService
{
    private readonly IApplicationDbContext _context;
    public NotificationService(IApplicationDbContext context) => _context = context;
    public async Task SendNotificationAsync(long userId, string title, string message, NotificationTypeEnum type, CancellationToken cancellationToken = default)
    {
        var notification = new Notification
        {
            UserId = userId,
            Title = title,
            Message = message,
            Type = type,
            IsRead = false,
            CreatedAt = DateTimeOffset.UtcNow
        };
        _context.Notifications.Add(notification);
        await _context.SaveChangesAsync(cancellationToken);
    }
    public async Task SendBulkNotificationAsync(IEnumerable<long> userIds, string title, string message, NotificationTypeEnum type, CancellationToken cancellationToken = default)
    {
        var notifications = userIds.Select(userId => new Notification
        {
            UserId = userId,
            Title = title,
            Message = message,
            Type = type,
            IsRead = false,
            CreatedAt = DateTimeOffset.UtcNow
        }).ToList();
        _context.Notifications.AddRange(notifications);
        await _context.SaveChangesAsync(cancellationToken);
    }
}
