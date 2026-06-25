using System.ComponentModel.DataAnnotations.Schema;
using AlexandriaMobilityPlatform.Domain.Common;

namespace AlexandriaMobilityPlatform.Domain.Entities;

[Table("CommunityAdmins")]
public class CommunityAdmin : BaseEntity
{
    public long UserId { get; set; }

    public long CommunityId { get; set; }

    public DateTimeOffset AddedAt { get; set; } = DateTimeOffset.UtcNow;

    [ForeignKey(nameof(UserId))]
    public ApplicationUser User { get; set; } = null!;

    [ForeignKey(nameof(CommunityId))]
    public Community Community { get; set; } = null!;
}
