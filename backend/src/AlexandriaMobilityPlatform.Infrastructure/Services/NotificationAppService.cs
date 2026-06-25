using AlexandriaMobilityPlatform.Application.Common.Interfaces;
using AlexandriaMobilityPlatform.Application.Common.Models;
using AlexandriaMobilityPlatform.Application.DTOs.Notification;
using AlexandriaMobilityPlatform.Application.Interfaces.Services;
using Microsoft.EntityFrameworkCore;

namespace AlexandriaMobilityPlatform.Infrastructure.Services;

public class NotificationAppService : INotificationAppService
{
    private readonly IApplicationDbContext _context;
    private readonly ICurrentUserService _currentUser;
    public NotificationAppService(IApplicationDbContext context, ICurrentUserService currentUser) { _context = context; _currentUser = currentUser; }

    public async Task<Result<PaginatedList<NotificationDto>>> GetMyNotificationsAsync(int pageNumber, int pageSize, CancellationToken cancellationToken = default)
    {
        var userId = _currentUser.UserId!.Value;
        var query = _context.Notifications.Where(n => n.UserId == userId).OrderByDescending(n => n.CreatedAt);
        var count = await query.CountAsync(cancellationToken);
        var items = await query.Skip((pageNumber - 1) * pageSize).Take(pageSize)
            .Select(n => new NotificationDto(n.Id, n.Title, n.Message, n.Type.ToString(), n.IsRead, n.CreatedAt.DateTime))
            .ToListAsync(cancellationToken);
        return Result<PaginatedList<NotificationDto>>.Success(new PaginatedList<NotificationDto>(items, count, pageNumber, pageSize));
    }

    public async Task<Result<NotificationSummaryDto>> GetSummaryAsync(CancellationToken cancellationToken = default)
    {
        var userId = _currentUser.UserId!.Value;
        var unread = await _context.Notifications.CountAsync(n => n.UserId == userId && !n.IsRead, cancellationToken);
        return Result<NotificationSummaryDto>.Success(new NotificationSummaryDto(unread));
    }

    public async Task<Result> MarkAsReadAsync(long notificationId, CancellationToken cancellationToken = default)
    {
        var notification = await _context.Notifications.FindAsync(new object[] { notificationId }, cancellationToken);
        if (notification == null) return Result.Failure("Notification not found");
        notification.IsRead = true;
        await _context.SaveChangesAsync(cancellationToken);
        return Result.Success("Marked as read");
    }

    public async Task<Result> MarkAllAsReadAsync(CancellationToken cancellationToken = default)
    {
        var userId = _currentUser.UserId!.Value;
        var notifications = await _context.Notifications.Where(n => n.UserId == userId && !n.IsRead).ToListAsync(cancellationToken);
        foreach (var n in notifications) n.IsRead = true;
        await _context.SaveChangesAsync(cancellationToken);
        return Result.Success("All notifications marked as read");
    }
}
