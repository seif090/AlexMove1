namespace AlexandriaMobilityPlatform.Application.DTOs.Notification;

public record NotificationDto(
    long Id,
    string Title,
    string Message,
    string Type,
    bool IsRead,
    DateTime CreatedAt);

public record NotificationSummaryDto(
    int TotalUnread);
