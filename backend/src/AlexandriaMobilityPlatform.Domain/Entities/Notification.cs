using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using AlexandriaMobilityPlatform.Domain.Common;
using AlexandriaMobilityPlatform.Domain.Enums;

namespace AlexandriaMobilityPlatform.Domain.Entities;

[Table("Notifications")]
public class Notification : BaseEntity
{
    public long UserId { get; set; }

    [Required]
    [MaxLength(200)]
    public string Title { get; set; } = string.Empty;

    [Required]
    [MaxLength(2000)]
    public string Message { get; set; } = string.Empty;

    public NotificationTypeEnum Type { get; set; }

    public bool IsRead { get; set; }

    [ForeignKey(nameof(UserId))]
    public ApplicationUser User { get; set; } = null!;
}
