namespace AlexandriaMobilityPlatform.Application.DTOs.User;

public record UserDto(
    long Id,
    string FullName,
    string Email,
    string PhoneNumber,
    string Role,
    string? ProfileImageUrl,
    string PreferredLanguage,
    bool IsActive,
    DateTime CreatedAt);

public record UpdateProfileRequest(
    string FullName,
    string PhoneNumber,
    string? ProfileImageUrl,
    string PreferredLanguage);

public record ChangePasswordRequest(
    string CurrentPassword,
    string NewPassword);

public record AdminUserDto(
    long Id,
    string FullName,
    string Email,
    string PhoneNumber,
    string Role,
    bool IsActive,
    DateTime CreatedAt,
    int CommunityCount);
