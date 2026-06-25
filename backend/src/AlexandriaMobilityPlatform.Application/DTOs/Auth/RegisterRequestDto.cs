namespace AlexandriaMobilityPlatform.Application.DTOs.Auth;

public record RegisterRequestDto(
    string FullName,
    string Email,
    string PhoneNumber,
    string Password,
    string? PreferredLanguage = "en");
