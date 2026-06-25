using System.ComponentModel.DataAnnotations.Schema;
using AlexandriaMobilityPlatform.Domain.Common;
using AlexandriaMobilityPlatform.Domain.Enums;

namespace AlexandriaMobilityPlatform.Domain.Entities;

[Table("CommunityMembers")]
public class CommunityMember : BaseEntity
{
    public long UserId { get; set; }

    public long CommunityId { get; set; }

    public MemberStatusEnum Status { get; set; } = MemberStatusEnum.Pending;

    public DateTimeOffset JoinedAt { get; set; } = DateTimeOffset.UtcNow;

    [ForeignKey(nameof(UserId))]
    public ApplicationUser User { get; set; } = null!;

    [ForeignKey(nameof(CommunityId))]
    public Community Community { get; set; } = null!;
}
