using AlexandriaMobilityPlatform.Application.DTOs.Group;
using AlexandriaMobilityPlatform.Application.Interfaces.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace AlexandriaMobilityPlatform.API.Controllers;

[ApiController]
[Route("api/[controller]")]
public class GroupsController : ControllerBase
{
    private readonly IGroupService _groupService;
    public GroupsController(IGroupService groupService) => _groupService = groupService;

    [HttpGet("{id:long}")]
    public async Task<IActionResult> GetById(long id, CancellationToken ct)
    {
        var result = await _groupService.GetByIdAsync(id, ct);
        return result.IsSuccess ? Ok(result) : NotFound(result);
    }

    [HttpGet("community/{communityId:long}")]
    public async Task<IActionResult> GetByCommunity(long communityId, [FromQuery] int pageNumber = 1, [FromQuery] int pageSize = 10, CancellationToken ct = default)
    {
        var result = await _groupService.GetByCommunityAsync(communityId, pageNumber, pageSize, ct);
        return result.IsSuccess ? Ok(result) : BadRequest(result);
    }

    [HttpGet("search")]
    public async Task<IActionResult> Search([FromQuery] GroupSearchRequest request, CancellationToken ct)
    {
        var result = await _groupService.SearchAsync(request, ct);
        return result.IsSuccess ? Ok(result) : BadRequest(result);
    }

    [HttpPost]
    [Authorize(Roles = "SuperAdmin,CommunityAdmin")]
    public async Task<IActionResult> Create([FromBody] CreateGroupRequest request, CancellationToken ct)
    {
        var result = await _groupService.CreateAsync(request, ct);
        return result.IsSuccess ? CreatedAtAction(nameof(GetById), new { id = result.Data!.Id }, result) : BadRequest(result);
    }

    [HttpPut("{id:long}")]
    [Authorize(Roles = "SuperAdmin,CommunityAdmin")]
    public async Task<IActionResult> Update(long id, [FromBody] UpdateGroupRequest request, CancellationToken ct)
    {
        var result = await _groupService.UpdateAsync(id, request, ct);
        return result.IsSuccess ? Ok(result) : BadRequest(result);
    }

    [HttpGet("recommendations")]
    [Authorize]
    public async Task<IActionResult> GetRecommendations([FromQuery] long communityId, [FromQuery] decimal latitude, [FromQuery] decimal longitude, [FromQuery] string preferredTime, CancellationToken ct)
    {
        if (TimeSpan.TryParse(preferredTime, out var time))
        {
            var result = await _groupService.GetRecommendationsAsync(communityId, latitude, longitude, time, ct);
            return result.IsSuccess ? Ok(result) : BadRequest(result);
        }
        return BadRequest("Invalid time format");
    }

    [HttpGet("my")]
    [Authorize]
    public async Task<IActionResult> GetMyGroups(CancellationToken ct)
    {
        var result = await _groupService.GetMyGroupsAsync(ct);
        return result.IsSuccess ? Ok(result) : BadRequest(result);
    }
}
