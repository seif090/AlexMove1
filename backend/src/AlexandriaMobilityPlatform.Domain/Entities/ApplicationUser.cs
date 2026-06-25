using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.AspNetCore.Identity;

namespace AlexandriaMobilityPlatform.Domain.Entities;

[Table("Users")]
public class ApplicationUser : IdentityUser<long>
{
    [Required]
    [MaxLength(200)]
    public string FullName { get; set; } = string.Empty;

    [MaxLength(500)]
    public string? ProfileImageUrl { get; set; }

    [Required]
    [MaxLength(10)]
    public string PreferredLanguage { get; set; } = "en";

    public bool IsActive { get; set; } = true;

    public DateTimeOffset CreatedAt { get; set; } = DateTimeOffset.UtcNow;

    public DateTimeOffset? UpdatedAt { get; set; }

    public ICollection<RefreshToken> RefreshTokens { get; set; } = new List<RefreshToken>();
}
