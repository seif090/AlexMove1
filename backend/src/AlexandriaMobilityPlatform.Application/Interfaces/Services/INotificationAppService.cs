using AlexandriaMobilityPlatform.Application.DTOs.Notification;
using AlexandriaMobilityPlatform.Application.Common.Models;

namespace AlexandriaMobilityPlatform.Application.Interfaces.Services;

public interface INotificationAppService
{
    Task<Result<PaginatedList<NotificationDto>>> GetMyNotificationsAsync(int pageNumber, int pageSize, CancellationToken cancellationToken = default);
    Task<Result<NotificationSummaryDto>> GetSummaryAsync(CancellationToken cancellationToken = default);
    Task<Result> MarkAsReadAsync(long notificationId, CancellationToken cancellationToken = default);
    Task<Result> MarkAllAsReadAsync(CancellationToken cancellationToken = default);
}
