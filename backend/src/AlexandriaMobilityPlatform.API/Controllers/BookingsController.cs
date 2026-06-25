using AlexandriaMobilityPlatform.Application.DTOs.Booking;
using AlexandriaMobilityPlatform.Application.Interfaces.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace AlexandriaMobilityPlatform.API.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class BookingsController : ControllerBase
{
    private readonly IBookingService _bookingService;
    public BookingsController(IBookingService bookingService) => _bookingService = bookingService;

    [HttpGet("{id:long}")]
    public async Task<IActionResult> GetById(long id, CancellationToken ct)
    {
        var result = await _bookingService.GetByIdAsync(id, ct);
        return result.IsSuccess ? Ok(result) : NotFound(result);
    }

    [HttpGet("my")]
    public async Task<IActionResult> GetMyBookings([FromQuery] int pageNumber = 1, [FromQuery] int pageSize = 10, CancellationToken ct = default)
    {
        var result = await _bookingService.GetMyBookingsAsync(pageNumber, pageSize, ct);
        return result.IsSuccess ? Ok(result) : BadRequest(result);
    }

    [HttpPost]
    public async Task<IActionResult> Create([FromBody] CreateBookingRequest request, CancellationToken ct)
    {
        var result = await _bookingService.CreateAsync(request, ct);
        return result.IsSuccess ? CreatedAtAction(nameof(GetById), new { id = result.Data!.Id }, result) : BadRequest(result);
    }

    [HttpPost("cancel")]
    public async Task<IActionResult> Cancel([FromBody] CancelBookingRequest request, CancellationToken ct)
    {
        var result = await _bookingService.CancelAsync(request, ct);
        return result.IsSuccess ? Ok(result) : BadRequest(result);
    }

    [HttpGet("summary")]
    public async Task<IActionResult> GetSummary(CancellationToken ct)
    {
        var result = await _bookingService.GetSummaryAsync(ct);
        return result.IsSuccess ? Ok(result) : BadRequest(result);
    }

    [HttpGet("group/{groupId:long}")]
    [Authorize(Roles = "SuperAdmin,CommunityAdmin,Driver")]
    public async Task<IActionResult> GetGroupBookings(long groupId, [FromQuery] DateTime date, CancellationToken ct)
    {
        var result = await _bookingService.GetGroupBookingsAsync(groupId, date, ct);
        return result.IsSuccess ? Ok(result) : BadRequest(result);
    }
}
