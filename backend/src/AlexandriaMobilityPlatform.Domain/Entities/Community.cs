using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using AlexandriaMobilityPlatform.Domain.Common;
using AlexandriaMobilityPlatform.Domain.Enums;

namespace AlexandriaMobilityPlatform.Domain.Entities;

[Table("Communities")]
public class Community : BaseEntity
{
    [Required]
    [MaxLength(200)]
    public string Name { get; set; } = string.Empty;

    public CommunityTypeEnum Type { get; set; }

    [Required]
    [MaxLength(100)]
    public string City { get; set; } = string.Empty;

    [Required]
    [MaxLength(100)]
    public string Area { get; set; } = string.Empty;

    [Required]
    [MaxLength(500)]
    public string Address { get; set; } = string.Empty;

    public long AdminId { get; set; }

    [MaxLength(500)]
    public string? LogoUrl { get; set; }

    public bool IsActive { get; set; } = true;

    [ForeignKey(nameof(AdminId))]
    public ApplicationUser Admin { get; set; } = null!;

    public ICollection<CommunityMember> CommunityMembers { get; set; } = new List<CommunityMember>();
    public ICollection<Route> Routes { get; set; } = new List<Route>();
    public ICollection<Group> Groups { get; set; } = new List<Group>();
    public ICollection<CommunityAdmin> CommunityAdmins { get; set; } = new List<CommunityAdmin>();
}
