using AlexandriaMobilityPlatform.Application.DTOs.Dashboard;
using AlexandriaMobilityPlatform.Application.Common.Models;

namespace AlexandriaMobilityPlatform.Application.Interfaces.Services;

public interface IDashboardService
{
    Task<Result<SuperAdminDashboardDto>> GetSuperAdminDashboardAsync(CancellationToken cancellationToken = default);
    Task<Result<CommunityAdminDashboardDto>> GetCommunityAdminDashboardAsync(long communityId, CancellationToken cancellationToken = default);
    Task<Result<DriverDashboardDto>> GetDriverDashboardAsync(CancellationToken cancellationToken = default);
}
