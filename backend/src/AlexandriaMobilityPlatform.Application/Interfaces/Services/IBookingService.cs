using AlexandriaMobilityPlatform.Application.DTOs.Booking;
using AlexandriaMobilityPlatform.Application.Common.Models;

namespace AlexandriaMobilityPlatform.Application.Interfaces.Services;

public interface IBookingService
{
    Task<Result<BookingDto>> GetByIdAsync(long id, CancellationToken cancellationToken = default);
    Task<Result<PaginatedList<BookingDto>>> GetMyBookingsAsync(int pageNumber, int pageSize, CancellationToken cancellationToken = default);
    Task<Result<BookingDto>> CreateAsync(CreateBookingRequest request, CancellationToken cancellationToken = default);
    Task<Result> CancelAsync(CancelBookingRequest request, CancellationToken cancellationToken = default);
    Task<Result<BookingSummaryDto>> GetSummaryAsync(CancellationToken cancellationToken = default);
    Task<Result<List<BookingDto>>> GetGroupBookingsAsync(long groupId, DateTime date, CancellationToken cancellationToken = default);
}
