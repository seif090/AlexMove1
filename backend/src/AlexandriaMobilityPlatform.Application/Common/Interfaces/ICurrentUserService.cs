namespace AlexandriaMobilityPlatform.Application.Common.Interfaces;

public interface ICurrentUserService
{
    long? UserId { get; }
    string? Email { get; }
    string? UserRole { get; }
    bool IsAuthenticated { get; }
}
