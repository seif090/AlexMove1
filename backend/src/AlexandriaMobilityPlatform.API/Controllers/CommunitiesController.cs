using AlexandriaMobilityPlatform.Application.DTOs.Community;
using AlexandriaMobilityPlatform.Application.Interfaces.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace AlexandriaMobilityPlatform.API.Controllers;

[ApiController]
[Route("api/[controller]")]
public class CommunitiesController : ControllerBase
{
    private readonly ICommunityService _communityService;
    public CommunitiesController(ICommunityService communityService) => _communityService = communityService;

    [HttpGet]
    public async Task<IActionResult> GetAll([FromQuery] int pageNumber = 1, [FromQuery] int pageSize = 10, [FromQuery] string? city = null, CancellationToken ct = default)
    {
        var result = await _communityService.GetAllAsync(pageNumber, pageSize, city, ct);
        return result.IsSuccess ? Ok(result) : BadRequest(result);
    }

    [HttpGet("{id:long}")]
    public async Task<IActionResult> GetById(long id, CancellationToken ct)
    {
        var result = await _communityService.GetByIdAsync(id, ct);
        return result.IsSuccess ? Ok(result) : NotFound(result);
    }

    [HttpPost]
    [Authorize(Roles = "SuperAdmin")]
    public async Task<IActionResult> Create([FromBody] CreateCommunityRequest request, CancellationToken ct)
    {
        var result = await _communityService.CreateAsync(request, ct);
        return result.IsSuccess ? CreatedAtAction(nameof(GetById), new { id = result.Data!.Id }, result) : BadRequest(result);
    }

    [HttpPut("{id:long}")]
    [Authorize(Roles = "SuperAdmin,CommunityAdmin")]
    public async Task<IActionResult> Update(long id, [FromBody] UpdateCommunityRequest request, CancellationToken ct)
    {
        var result = await _communityService.UpdateAsync(id, request, ct);
        return result.IsSuccess ? Ok(result) : BadRequest(result);
    }

    [HttpPost("join")]
    [Authorize]
    public async Task<IActionResult> Join([FromBody] JoinCommunityRequest request, CancellationToken ct)
    {
        var result = await _communityService.JoinAsync(request, ct);
        return result.IsSuccess ? Ok(result) : BadRequest(result);
    }

    [HttpPost("{id:long}/approve-member/{memberId:long}")]
    [Authorize(Roles = "SuperAdmin,CommunityAdmin")]
    public async Task<IActionResult> ApproveMember(long id, long memberId, CancellationToken ct)
    {
        var result = await _communityService.ApproveMemberAsync(memberId, ct);
        return result.IsSuccess ? Ok(result) : BadRequest(result);
    }

    [HttpGet("{id:long}/members")]
    [Authorize(Roles = "SuperAdmin,CommunityAdmin")]
    public async Task<IActionResult> GetMembers(long id, [FromQuery] int pageNumber = 1, [FromQuery] int pageSize = 10, CancellationToken ct = default)
    {
        var result = await _communityService.GetMembersAsync(id, pageNumber, pageSize, ct);
        return result.IsSuccess ? Ok(result) : BadRequest(result);
    }

    [HttpGet("my")]
    [Authorize]
    public async Task<IActionResult> GetMyCommunities(CancellationToken ct)
    {
        var result = await _communityService.GetUserCommunitiesAsync(ct);
        return result.IsSuccess ? Ok(result) : BadRequest(result);
    }
}
