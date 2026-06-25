using AlexandriaMobilityPlatform.Application.DTOs.Vehicle;
using AlexandriaMobilityPlatform.Application.Common.Models;

namespace AlexandriaMobilityPlatform.Application.Interfaces.Services;

public interface IVehicleService
{
    Task<Result<VehicleDto>> GetByIdAsync(long id, CancellationToken cancellationToken = default);
    Task<Result<PaginatedList<VehicleDto>>> GetByCommunityAsync(long communityId, int pageNumber, int pageSize, CancellationToken cancellationToken = default);
    Task<Result<VehicleDto>> CreateAsync(CreateVehicleRequest request, CancellationToken cancellationToken = default);
    Task<Result<VehicleDto>> UpdateAsync(long id, UpdateVehicleRequest request, CancellationToken cancellationToken = default);
    Task<Result> DeleteAsync(long id, CancellationToken cancellationToken = default);
}
