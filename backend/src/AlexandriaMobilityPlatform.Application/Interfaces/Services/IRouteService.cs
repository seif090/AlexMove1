using AlexandriaMobilityPlatform.Application.DTOs.Route;
using AlexandriaMobilityPlatform.Application.Common.Models;

namespace AlexandriaMobilityPlatform.Application.Interfaces.Services;

public interface IRouteService
{
    Task<Result<RouteDto>> GetByIdAsync(long id, CancellationToken cancellationToken = default);
    Task<Result<PaginatedList<RouteDto>>> GetByCommunityAsync(long communityId, int pageNumber, int pageSize, CancellationToken cancellationToken = default);
    Task<Result<RouteDto>> CreateAsync(CreateRouteRequest request, CancellationToken cancellationToken = default);
    Task<Result<RouteDto>> UpdateAsync(long id, UpdateRouteRequest request, CancellationToken cancellationToken = default);
    Task<Result> DeleteAsync(long id, CancellationToken cancellationToken = default);
}
