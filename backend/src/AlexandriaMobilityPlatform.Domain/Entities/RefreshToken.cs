using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using AlexandriaMobilityPlatform.Domain.Common;

namespace AlexandriaMobilityPlatform.Domain.Entities;

[Table("RefreshTokens")]
public class RefreshToken : BaseEntity
{
    public long UserId { get; set; }

    [Required]
    [MaxLength(500)]
    public string Token { get; set; } = string.Empty;

    public DateTimeOffset ExpiresAt { get; set; }

    public DateTimeOffset? RevokedAt { get; set; }

    [MaxLength(500)]
    public string? ReplacedByToken { get; set; }

    [ForeignKey(nameof(UserId))]
    public ApplicationUser User { get; set; } = null!;
}
