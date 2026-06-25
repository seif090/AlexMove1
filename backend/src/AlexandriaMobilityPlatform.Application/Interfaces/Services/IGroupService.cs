using AlexandriaMobilityPlatform.Application.DTOs.Group;
using AlexandriaMobilityPlatform.Application.Common.Models;

namespace AlexandriaMobilityPlatform.Application.Interfaces.Services;

public interface IGroupService
{
    Task<Result<GroupDto>> GetByIdAsync(long id, CancellationToken cancellationToken = default);
    Task<Result<PaginatedList<GroupDto>>> GetByCommunityAsync(long communityId, int pageNumber, int pageSize, CancellationToken cancellationToken = default);
    Task<Result<PaginatedList<GroupDto>>> SearchAsync(GroupSearchRequest request, CancellationToken cancellationToken = default);
    Task<Result<GroupDto>> CreateAsync(CreateGroupRequest request, CancellationToken cancellationToken = default);
    Task<Result<GroupDto>> UpdateAsync(long id, UpdateGroupRequest request, CancellationToken cancellationToken = default);
    Task<Result> DeleteAsync(long id, CancellationToken cancellationToken = default);
    Task<Result<List<GroupRecommendationDto>>> GetRecommendationsAsync(long communityId, decimal latitude, decimal longitude, TimeSpan preferredTime, CancellationToken cancellationToken = default);
    Task<Result<List<GroupDto>>> GetMyGroupsAsync(CancellationToken cancellationToken = default);
}
