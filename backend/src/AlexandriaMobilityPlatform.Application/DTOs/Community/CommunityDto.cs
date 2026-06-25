namespace AlexandriaMobilityPlatform.Application.DTOs.Community;

public record CommunityDto(
    long Id,
    string Name,
    string Type,
    string City,
    string Area,
    string Address,
    string AdminName,
    int MemberCount,
    bool IsActive,
    DateTime CreatedAt);

public record CreateCommunityRequest(
    string Name,
    string Type,
    string City,
    string Area,
    string Address);

public record UpdateCommunityRequest(
    string Name,
    string Type,
    string City,
    string Area,
    string Address,
    bool IsActive);

public record CommunityMemberDto(
    long Id,
    long UserId,
    string FullName,
    string Email,
    string Status,
    DateTime JoinedAt);

public record JoinCommunityRequest(long CommunityId);
