using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using AlexandriaMobilityPlatform.Domain.Common;

namespace AlexandriaMobilityPlatform.Domain.Entities;

[Table("GroupSubscriptions")]
public class GroupSubscription : BaseEntity
{
    public long UserId { get; set; }

    public long GroupId { get; set; }

    public DateTime StartDate { get; set; }

    public DateTime EndDate { get; set; }

    public int Status { get; set; }

    [ForeignKey(nameof(UserId))]
    public ApplicationUser User { get; set; } = null!;

    [ForeignKey(nameof(GroupId))]
    public Group Group { get; set; } = null!;
}
