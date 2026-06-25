using AlexandriaMobilityPlatform.Application.Common.Interfaces;
using AlexandriaMobilityPlatform.Application.Common.Models;
using AlexandriaMobilityPlatform.Application.DTOs.Community;
using AlexandriaMobilityPlatform.Application.Interfaces.Repositories;
using AlexandriaMobilityPlatform.Application.Interfaces.Services;
using AlexandriaMobilityPlatform.Domain.Entities;
using AlexandriaMobilityPlatform.Domain.Enums;
using Microsoft.EntityFrameworkCore;

namespace AlexandriaMobilityPlatform.Infrastructure.Services;

public class CommunityService : ICommunityService
{
    private readonly IGenericRepository<Community> _communityRepo;
    private readonly IGenericRepository<CommunityMember> _memberRepo;
    private readonly IApplicationDbContext _context;
    private readonly ICurrentUserService _currentUser;

    public CommunityService(
        IGenericRepository<Community> communityRepo,
        IGenericRepository<CommunityMember> memberRepo,
        IApplicationDbContext context,
        ICurrentUserService currentUser)
    {
        _communityRepo = communityRepo;
        _memberRepo = memberRepo;
        _context = context;
        _currentUser = currentUser;
    }

    public async Task<Result<CommunityDto>> GetByIdAsync(long id, CancellationToken cancellationToken = default)
    {
        var community = await _context.Communities
            .Include(c => c.Admin)
            .Include(c => c.CommunityMembers)
            .FirstOrDefaultAsync(c => c.Id == id, cancellationToken);

        if (community == null)
            return Result<CommunityDto>.NotFound("Community not found");

        var dto = new CommunityDto(
            community.Id, community.Name, community.Type.ToString(),
            community.City, community.Area, community.Address,
            community.Admin?.FullName ?? "Unknown",
            community.CommunityMembers?.Count ?? 0,
            community.IsActive,
            community.CreatedAt.DateTime);

        return Result<CommunityDto>.Success(dto);
    }

    public async Task<Result<PaginatedList<CommunityDto>>> GetAllAsync(int pageNumber, int pageSize, string? city = null, CancellationToken cancellationToken = default)
    {
        var query = _context.Communities
            .Include(c => c.Admin)
            .Include(c => c.CommunityMembers)
            .Where(c => c.IsActive);

        if (!string.IsNullOrEmpty(city))
            query = query.Where(c => c.City == city);

        var count = await query.CountAsync(cancellationToken);
        var items = await query
            .OrderByDescending(c => c.CreatedAt)
            .Skip((pageNumber - 1) * pageSize)
            .Take(pageSize)
            .Select(c => new CommunityDto(
                c.Id, c.Name, c.Type.ToString(),
                c.City, c.Area, c.Address,
                c.Admin!.FullName,
                c.CommunityMembers.Count,
                c.IsActive,
                c.CreatedAt.DateTime))
            .ToListAsync(cancellationToken);

        return Result<PaginatedList<CommunityDto>>.Success(new PaginatedList<CommunityDto>(items, count, pageNumber, pageSize));
    }

    public async Task<Result<CommunityDto>> CreateAsync(CreateCommunityRequest request, CancellationToken cancellationToken = default)
    {
        var community = new Community
        {
            Name = request.Name,
            Type = Enum.Parse<CommunityTypeEnum>(request.Type),
            City = request.City,
            Area = request.Area,
            Address = request.Address,
            AdminId = _currentUser.UserId!.Value,
            IsActive = true,
            CreatedAt = DateTimeOffset.UtcNow
        };

        _context.Communities.Add(community);
        await _context.SaveChangesAsync(cancellationToken);

        return await GetByIdAsync(community.Id, cancellationToken);
    }

    public async Task<Result<CommunityDto>> UpdateAsync(long id, UpdateCommunityRequest request, CancellationToken cancellationToken = default)
    {
        var community = await _context.Communities.FindAsync(new object[] { id }, cancellationToken);
        if (community == null) return Result<CommunityDto>.NotFound("Community not found");

        community.Name = request.Name;
        community.Type = Enum.Parse<CommunityTypeEnum>(request.Type);
        community.City = request.City;
        community.Area = request.Area;
        community.Address = request.Address;
        community.IsActive = request.IsActive;
        community.UpdatedAt = DateTimeOffset.UtcNow;

        await _context.SaveChangesAsync(cancellationToken);
        return await GetByIdAsync(id, cancellationToken);
    }

    public async Task<Result> DeleteAsync(long id, CancellationToken cancellationToken = default)
    {
        var community = await _context.Communities.FindAsync(new object[] { id }, cancellationToken);
        if (community == null) return Result.Failure("Community not found");
        community.IsDeleted = true;
        community.DeletedAt = DateTimeOffset.UtcNow;
        await _context.SaveChangesAsync(cancellationToken);
        return Result.Success("Community deleted");
    }

    public async Task<Result<CommunityMemberDto>> JoinAsync(JoinCommunityRequest request, CancellationToken cancellationToken = default)
    {
        var userId = _currentUser.UserId!.Value;
        var exists = await _context.CommunityMembers.AnyAsync(cm => cm.UserId == userId && cm.CommunityId == request.CommunityId, cancellationToken);
        if (exists) return Result<CommunityMemberDto>.Failure("Already a member of this community");

        var member = new CommunityMember
        {
            UserId = userId,
            CommunityId = request.CommunityId,
            Status = MemberStatusEnum.Pending,
            JoinedAt = DateTimeOffset.UtcNow
        };

        _context.CommunityMembers.Add(member);
        await _context.SaveChangesAsync(cancellationToken);

        var user = await _context.Users.FindAsync(new object[] { userId }, cancellationToken);
        return Result<CommunityMemberDto>.Success(new CommunityMemberDto(member.Id, userId, user?.FullName ?? "", user?.Email ?? "", member.Status.ToString(), member.JoinedAt.DateTime));
    }

    public async Task<Result> ApproveMemberAsync(long memberId, CancellationToken cancellationToken = default)
    {
        var member = await _context.CommunityMembers.FindAsync(new object[] { memberId }, cancellationToken);
        if (member == null) return Result.Failure("Member not found");
        member.Status = MemberStatusEnum.Approved;
        await _context.SaveChangesAsync(cancellationToken);
        return Result.Success("Member approved");
    }

    public async Task<Result> RejectMemberAsync(long memberId, CancellationToken cancellationToken = default)
    {
        var member = await _context.CommunityMembers.FindAsync(new object[] { memberId }, cancellationToken);
        if (member == null) return Result.Failure("Member not found");
        member.Status = MemberStatusEnum.Rejected;
        await _context.SaveChangesAsync(cancellationToken);
        return Result.Success("Member rejected");
    }

    public async Task<Result<PaginatedList<CommunityMemberDto>>> GetMembersAsync(long communityId, int pageNumber, int pageSize, CancellationToken cancellationToken = default)
    {
        var query = _context.CommunityMembers
            .Include(cm => cm.User)
            .Where(cm => cm.CommunityId == communityId);

        var count = await query.CountAsync(cancellationToken);
        var items = await query
            .OrderByDescending(cm => cm.JoinedAt)
            .Skip((pageNumber - 1) * pageSize)
            .Take(pageSize)
            .Select(cm => new CommunityMemberDto(cm.Id, cm.UserId, cm.User!.FullName, cm.User.Email!, cm.Status.ToString(), cm.JoinedAt.DateTime))
            .ToListAsync(cancellationToken);

        return Result<PaginatedList<CommunityMemberDto>>.Success(new PaginatedList<CommunityMemberDto>(items, count, pageNumber, pageSize));
    }

    public async Task<Result<List<CommunityDto>>> GetUserCommunitiesAsync(CancellationToken cancellationToken = default)
    {
        var userId = _currentUser.UserId!.Value;
        var communities = await _context.CommunityMembers
            .Include(cm => cm.Community)
            .ThenInclude(c => c!.Admin)
            .Where(cm => cm.UserId == userId && cm.Status == MemberStatusEnum.Approved)
            .Select(cm => new CommunityDto(
                cm.Community!.Id, cm.Community.Name, cm.Community.Type.ToString(),
                cm.Community.City, cm.Community.Area, cm.Community.Address,
                cm.Community.Admin!.FullName, 0, cm.Community.IsActive, cm.Community.CreatedAt.DateTime))
            .ToListAsync(cancellationToken);

        return Result<List<CommunityDto>>.Success(communities);
    }
}
