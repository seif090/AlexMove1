using AlexandriaMobilityPlatform.Application.Common.Interfaces;
using AlexandriaMobilityPlatform.Application.Common.Models;
using AlexandriaMobilityPlatform.Application.DTOs.User;
using AlexandriaMobilityPlatform.Application.Interfaces.Services;
using AlexandriaMobilityPlatform.Domain.Entities;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;

namespace AlexandriaMobilityPlatform.Infrastructure.Services;

public class UserService : IUserService
{
    private readonly UserManager<ApplicationUser> _userManager;
    private readonly ICurrentUserService _currentUser;
    private readonly IApplicationDbContext _context;

    public UserService(UserManager<ApplicationUser> userManager, ICurrentUserService currentUser, IApplicationDbContext context)
    {
        _userManager = userManager;
        _currentUser = currentUser;
        _context = context;
    }

    public async Task<Result<UserDto>> GetProfileAsync(CancellationToken cancellationToken = default)
    {
        var user = await _userManager.FindByIdAsync(_currentUser.UserId!.ToString());
        if (user == null) return Result<UserDto>.NotFound("User not found");
        var roles = await _userManager.GetRolesAsync(user);
        return Result<UserDto>.Success(new UserDto(user.Id, user.FullName, user.Email!, user.PhoneNumber!, roles.FirstOrDefault() ?? "Passenger", user.ProfileImageUrl, user.PreferredLanguage ?? "en", user.IsActive, user.CreatedAt.DateTime));
    }

    public async Task<Result<UserDto>> UpdateProfileAsync(UpdateProfileRequest request, CancellationToken cancellationToken = default)
    {
        var user = await _userManager.FindByIdAsync(_currentUser.UserId!.ToString());
        if (user == null) return Result<UserDto>.NotFound("User not found");
        user.FullName = request.FullName;
        user.PhoneNumber = request.PhoneNumber;
        user.ProfileImageUrl = request.ProfileImageUrl;
        user.PreferredLanguage = request.PreferredLanguage;
        user.UpdatedAt = DateTimeOffset.UtcNow;
        await _userManager.UpdateAsync(user);
        var roles = await _userManager.GetRolesAsync(user);
        return Result<UserDto>.Success(new UserDto(user.Id, user.FullName, user.Email!, user.PhoneNumber!, roles.FirstOrDefault() ?? "Passenger", user.ProfileImageUrl, user.PreferredLanguage ?? "en", user.IsActive, user.CreatedAt.DateTime));
    }

    public async Task<Result> ChangePasswordAsync(ChangePasswordRequest request, CancellationToken cancellationToken = default)
    {
        var user = await _userManager.FindByIdAsync(_currentUser.UserId!.ToString());
        if (user == null) return Result.Failure("User not found");
        var result = await _userManager.ChangePasswordAsync(user, request.CurrentPassword, request.NewPassword);
        return result.Succeeded ? Result.Success("Password changed") : Result.Failure(result.Errors.Select(e => e.Description).ToList());
    }

    public async Task<Result<PaginatedList<AdminUserDto>>> GetAllUsersAsync(int pageNumber, int pageSize, string? role = null, CancellationToken cancellationToken = default)
    {
        var query = _userManager.Users.AsQueryable();
        if (!string.IsNullOrEmpty(role))
        {
            var roleUsers = await _userManager.GetUsersInRoleAsync(role);
            var roleIds = roleUsers.Select(u => u.Id).ToList();
            query = query.Where(u => roleIds.Contains(u.Id));
        }
        var count = await query.CountAsync(cancellationToken);
        var items = await query.OrderByDescending(u => u.CreatedAt).Skip((pageNumber - 1) * pageSize).Take(pageSize).ToListAsync(cancellationToken);
        var dtos = new List<AdminUserDto>();
        foreach (var user in items)
        {
            var roles = await _userManager.GetRolesAsync(user);
            var communityCount = await _context.CommunityMembers.CountAsync(cm => cm.UserId == user.Id, cancellationToken);
            dtos.Add(new AdminUserDto(user.Id, user.FullName, user.Email!, user.PhoneNumber!, roles.FirstOrDefault() ?? "", user.IsActive, user.CreatedAt.DateTime, communityCount));
        }
        return Result<PaginatedList<AdminUserDto>>.Success(new PaginatedList<AdminUserDto>(dtos, count, pageNumber, pageSize));
    }

    public async Task<Result> ToggleUserStatusAsync(long userId, CancellationToken cancellationToken = default)
    {
        var user = await _userManager.FindByIdAsync(userId.ToString());
        if (user == null) return Result.Failure("User not found");
        user.IsActive = !user.IsActive;
        await _userManager.UpdateAsync(user);
        return Result.Success(user.IsActive ? "User activated" : "User deactivated");
    }

    public async Task<Result> AssignRoleAsync(long userId, string role, CancellationToken cancellationToken = default)
    {
        var user = await _userManager.FindByIdAsync(userId.ToString());
        if (user == null) return Result.Failure("User not found");
        var currentRoles = await _userManager.GetRolesAsync(user);
        await _userManager.RemoveFromRolesAsync(user, currentRoles);
        var result = await _userManager.AddToRoleAsync(user, role);
        return result.Succeeded ? Result.Success($"Role assigned: {role}") : Result.Failure(result.Errors.Select(e => e.Description).ToList());
    }
}
