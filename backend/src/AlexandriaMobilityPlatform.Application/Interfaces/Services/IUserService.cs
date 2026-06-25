using AlexandriaMobilityPlatform.Application.DTOs.User;
using AlexandriaMobilityPlatform.Application.Common.Models;

namespace AlexandriaMobilityPlatform.Application.Interfaces.Services;

public interface IUserService
{
    Task<Result<UserDto>> GetProfileAsync(CancellationToken cancellationToken = default);
    Task<Result<UserDto>> UpdateProfileAsync(UpdateProfileRequest request, CancellationToken cancellationToken = default);
    Task<Result> ChangePasswordAsync(ChangePasswordRequest request, CancellationToken cancellationToken = default);
    Task<Result<PaginatedList<AdminUserDto>>> GetAllUsersAsync(int pageNumber, int pageSize, string? role = null, CancellationToken cancellationToken = default);
    Task<Result> ToggleUserStatusAsync(long userId, CancellationToken cancellationToken = default);
    Task<Result> AssignRoleAsync(long userId, string role, CancellationToken cancellationToken = default);
}
