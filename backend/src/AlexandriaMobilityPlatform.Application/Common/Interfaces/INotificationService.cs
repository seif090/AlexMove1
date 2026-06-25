using AlexandriaMobilityPlatform.Domain.Entities;
using AlexandriaMobilityPlatform.Domain.Enums;

namespace AlexandriaMobilityPlatform.Application.Common.Interfaces;

public interface INotificationService
{
    Task SendNotificationAsync(long userId, string title, string message, NotificationTypeEnum type, CancellationToken cancellationToken = default);
    Task SendBulkNotificationAsync(IEnumerable<long> userIds, string title, string message, NotificationTypeEnum type, CancellationToken cancellationToken = default);
}
