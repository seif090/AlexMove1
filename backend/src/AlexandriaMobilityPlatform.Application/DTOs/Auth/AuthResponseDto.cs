namespace AlexandriaMobilityPlatform.Application.DTOs.Auth;

public record AuthResponseDto(
    string Token,
    string RefreshToken,
    UserProfileDto UserProfile,
    DateTime Expiration);

public record UserProfileDto(
    long Id,
    string FullName,
    string Email,
    string PhoneNumber,
    string? ProfileImageUrl,
    string PreferredLanguage,
    string Role);
