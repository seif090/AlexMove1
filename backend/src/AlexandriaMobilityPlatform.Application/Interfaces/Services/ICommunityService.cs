using AlexandriaMobilityPlatform.Application.DTOs.Community;
using AlexandriaMobilityPlatform.Application.Common.Models;

namespace AlexandriaMobilityPlatform.Application.Interfaces.Services;

public interface ICommunityService
{
    Task<Result<CommunityDto>> GetByIdAsync(long id, CancellationToken cancellationToken = default);
    Task<Result<PaginatedList<CommunityDto>>> GetAllAsync(int pageNumber, int pageSize, string? city = null, CancellationToken cancellationToken = default);
    Task<Result<CommunityDto>> CreateAsync(CreateCommunityRequest request, CancellationToken cancellationToken = default);
    Task<Result<CommunityDto>> UpdateAsync(long id, UpdateCommunityRequest request, CancellationToken cancellationToken = default);
    Task<Result> DeleteAsync(long id, CancellationToken cancellationToken = default);
    Task<Result<CommunityMemberDto>> JoinAsync(JoinCommunityRequest request, CancellationToken cancellationToken = default);
    Task<Result> ApproveMemberAsync(long memberId, CancellationToken cancellationToken = default);
    Task<Result> RejectMemberAsync(long memberId, CancellationToken cancellationToken = default);
    Task<Result<PaginatedList<CommunityMemberDto>>> GetMembersAsync(long communityId, int pageNumber, int pageSize, CancellationToken cancellationToken = default);
    Task<Result<List<CommunityDto>>> GetUserCommunitiesAsync(CancellationToken cancellationToken = default);
}
