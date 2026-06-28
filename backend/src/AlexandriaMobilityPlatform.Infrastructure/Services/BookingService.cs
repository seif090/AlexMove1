using AlexandriaMobilityPlatform.Application.Common.Interfaces;
using AlexandriaMobilityPlatform.Application.Common.Models;
using AlexandriaMobilityPlatform.Application.DTOs.Booking;
using AlexandriaMobilityPlatform.Application.Interfaces.Services;
using AlexandriaMobilityPlatform.Domain.Entities;
using AlexandriaMobilityPlatform.Domain.Enums;
using Microsoft.EntityFrameworkCore;

namespace AlexandriaMobilityPlatform.Infrastructure.Services;

public class BookingService : IBookingService
{
    private readonly IApplicationDbContext _context;
    private readonly ICurrentUserService _currentUser;
    private readonly INotificationService _notificationService;

    public BookingService(IApplicationDbContext context, ICurrentUserService currentUser, INotificationService notificationService)
    {
        _context = context;
        _currentUser = currentUser;
        _notificationService = notificationService;
    }

    public async Task<Result<BookingDto>> GetByIdAsync(long id, CancellationToken cancellationToken = default)
    {
        var booking = await _context.Bookings
            .Include(b => b.User)
            .Include(b => b.Group)
            .FirstOrDefaultAsync(b => b.Id == id, cancellationToken);

        if (booking == null) return Result<BookingDto>.NotFound("Booking not found");

        return Result<BookingDto>.Success(new BookingDto(
            booking.Id, booking.UserId, booking.User?.FullName ?? "",
            booking.GroupId, booking.Group?.Name ?? "",
            booking.BookingDate, booking.Status.ToString(),
            booking.PaymentStatus.ToString(), booking.CreatedAt.DateTime));
    }

    public async Task<Result<PaginatedList<BookingDto>>> GetMyBookingsAsync(int pageNumber, int pageSize, CancellationToken cancellationToken = default)
    {
        var userId = _currentUser.UserId!.Value;
        var query = _context.Bookings
            .Include(b => b.User)
            .Include(b => b.Group)
            .Where(b => b.UserId == userId)
            .OrderByDescending(b => b.CreatedAt);

        var count = await query.CountAsync(cancellationToken);
        var items = await query.Skip((pageNumber - 1) * pageSize).Take(pageSize)
            .Select(b => new BookingDto(b.Id, b.UserId, b.User!.FullName, b.GroupId, b.Group!.Name, b.BookingDate, b.Status.ToString(), b.PaymentStatus.ToString(), b.CreatedAt.DateTime))
            .ToListAsync(cancellationToken);

        return Result<PaginatedList<BookingDto>>.Success(new PaginatedList<BookingDto>(items, count, pageNumber, pageSize));
    }

    public async Task<Result<BookingDto>> CreateAsync(CreateBookingRequest request, CancellationToken cancellationToken = default)
    {
        var userId = _currentUser.UserId!.Value;
        var group = await _context.Groups.FindAsync(new object[] { request.GroupId }, cancellationToken);
        if (group == null) return Result<BookingDto>.NotFound("Group not found");
        if (group.AvailableSeats <= 0) return Result<BookingDto>.Failure("No available seats");
        if (group.Status != GroupStatusEnum.Active) return Result<BookingDto>.Failure("Group is not active");

        var alreadyBooked = await _context.Bookings.AnyAsync(b => b.UserId == userId && b.GroupId == request.GroupId && b.BookingDate == request.BookingDate && b.Status == BookingStatusEnum.Confirmed, cancellationToken);
        if (alreadyBooked) return Result<BookingDto>.Failure("Already booked for this date");

        var booking = new Booking
        {
            UserId = userId,
            GroupId = request.GroupId,
            BookingDate = request.BookingDate,
            PickupStopId = request.PickupStopId,
            Status = BookingStatusEnum.Confirmed,
            PaymentStatus = group.Price > 0 ? PaymentStatusEnum.Pending : PaymentStatusEnum.Success,
            CreatedAt = DateTimeOffset.UtcNow
        };

        group.AvailableSeats--;
        _context.Bookings.Add(booking);
        await _context.SaveChangesAsync(cancellationToken);

        await _notificationService.SendNotificationAsync(userId, "Booking Confirmed", $"Your booking for {group.Name} on {request.BookingDate:yyyy-MM-dd} is confirmed.", NotificationTypeEnum.Booking, cancellationToken);

        return await GetByIdAsync(booking.Id, cancellationToken);
    }

    public async Task<Result> CancelAsync(CancelBookingRequest request, CancellationToken cancellationToken = default)
    {
        var booking = await _context.Bookings.Include(b => b.Group).FirstOrDefaultAsync(b => b.Id == request.BookingId, cancellationToken);
        if (booking == null) return Result.Failure("Booking not found");
        if (booking.Status != BookingStatusEnum.Confirmed) return Result.Failure("Booking cannot be cancelled");

        var userId = _currentUser.UserId!.Value;
        if (booking.UserId != userId && _currentUser.UserRole != "SuperAdmin" && _currentUser.UserRole != "CommunityAdmin")
            return Result.Failure("Unauthorized");

        booking.Status = BookingStatusEnum.Cancelled;
        booking.Group!.AvailableSeats++;
        await _context.SaveChangesAsync(cancellationToken);

        await _notificationService.SendNotificationAsync(userId, "Booking Cancelled", $"Your booking for {booking.Group.Name} has been cancelled.", NotificationTypeEnum.Booking, cancellationToken);

        return Result.Success("Booking cancelled");
    }

    public async Task<Result<BookingSummaryDto>> GetSummaryAsync(CancellationToken cancellationToken = default)
    {
        var userId = _currentUser.UserId!.Value;
        var today = DateTime.Today;
        var weekStart = today.AddDays(-(int)today.DayOfWeek);

        var totalBookings = await _context.Bookings.CountAsync(b => b.UserId == userId, cancellationToken);
        var todayBookings = await _context.Bookings.CountAsync(b => b.UserId == userId && b.BookingDate == today, cancellationToken);
        var weekBookings = await _context.Bookings.CountAsync(b => b.UserId == userId && b.BookingDate >= weekStart, cancellationToken);
        var activeBookings = await _context.Bookings.CountAsync(b => b.UserId == userId && b.Status == BookingStatusEnum.Confirmed, cancellationToken);

        var summary = new BookingSummaryDto(totalBookings, todayBookings, weekBookings, activeBookings);

        return Result<BookingSummaryDto>.Success(summary);
    }

    public async Task<Result<List<BookingDto>>> GetGroupBookingsAsync(long groupId, DateTime date, CancellationToken cancellationToken = default)
    {
        var bookings = await _context.Bookings
            .Include(b => b.User)
            .Include(b => b.Group)
            .Where(b => b.GroupId == groupId && b.BookingDate == date)
            .Select(b => new BookingDto(b.Id, b.UserId, b.User!.FullName, b.GroupId, b.Group!.Name, b.BookingDate, b.Status.ToString(), b.PaymentStatus.ToString(), b.CreatedAt.DateTime))
            .ToListAsync(cancellationToken);

        return Result<List<BookingDto>>.Success(bookings);
    }
}
