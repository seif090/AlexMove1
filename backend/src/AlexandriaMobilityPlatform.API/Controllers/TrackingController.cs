using AlexandriaMobilityPlatform.Application.DTOs.Tracking;
using AlexandriaMobilityPlatform.Application.Interfaces.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace AlexandriaMobilityPlatform.API.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class TrackingController : ControllerBase
{
    private readonly ITrackingService _trackingService;
    public TrackingController(ITrackingService trackingService) => _trackingService = trackingService;

    [HttpPost("location")]
    [Authorize(Roles = "Driver")]
    public async Task<IActionResult> UpdateLocation([FromBody] DriverLocationUpdateDto request, CancellationToken ct)
    {
        var result = await _trackingService.UpdateDriverLocationAsync(request, ct);
        return result.IsSuccess ? Ok(result) : BadRequest(result);
    }

    [HttpGet("driver/{driverId:long}")]
    public async Task<IActionResult> GetDriverLocation(long driverId, CancellationToken ct)
    {
        var result = await _trackingService.GetDriverLocationAsync(driverId, ct);
        return result.IsSuccess ? Ok(result) : NotFound(result);
    }

    [HttpPost("trip-status")]
    [Authorize(Roles = "Driver")]
    public async Task<IActionResult> UpdateTripStatus([FromBody] TripStatusUpdateDto request, CancellationToken ct)
    {
        var result = await _trackingService.UpdateTripStatusAsync(request, ct);
        return result.IsSuccess ? Ok(result) : BadRequest(result);
    }
}
