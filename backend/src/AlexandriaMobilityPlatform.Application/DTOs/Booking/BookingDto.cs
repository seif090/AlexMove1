namespace AlexandriaMobilityPlatform.Application.DTOs.Booking;

public record BookingDto(
    long Id,
    long UserId,
    string UserName,
    long GroupId,
    string GroupName,
    DateTime BookingDate,
    string Status,
    string PaymentStatus,
    DateTime CreatedAt);

public record CreateBookingRequest(
    long GroupId,
    DateTime BookingDate,
    long? PickupStopId);

public record CancelBookingRequest(
    long BookingId,
    string? Reason);

public record BookingSummaryDto(
    int TotalBookings,
    int TodayBookings,
    int ThisWeekBookings,
    int ActiveBookings);
