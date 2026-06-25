using AlexandriaMobilityPlatform.Application.Interfaces.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace AlexandriaMobilityPlatform.API.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class DashboardController : ControllerBase
{
    private readonly IDashboardService _dashboardService;
    public DashboardController(IDashboardService dashboardService) => _dashboardService = dashboardService;

    [HttpGet("super-admin")]
    [Authorize(Roles = "SuperAdmin")]
    public async Task<IActionResult> GetSuperAdminDashboard(CancellationToken ct)
    {
        var result = await _dashboardService.GetSuperAdminDashboardAsync(ct);
        return result.IsSuccess ? Ok(result) : BadRequest(result);
    }

    [HttpGet("community-admin/{communityId:long}")]
    [Authorize(Roles = "SuperAdmin,CommunityAdmin")]
    public async Task<IActionResult> GetCommunityAdminDashboard(long communityId, CancellationToken ct)
    {
        var result = await _dashboardService.GetCommunityAdminDashboardAsync(communityId, ct);
        return result.IsSuccess ? Ok(result) : BadRequest(result);
    }

    [HttpGet("driver")]
    [Authorize(Roles = "Driver")]
    public async Task<IActionResult> GetDriverDashboard(CancellationToken ct)
    {
        var result = await _dashboardService.GetDriverDashboardAsync(ct);
        return result.IsSuccess ? Ok(result) : BadRequest(result);
    }
}
