using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using AlexandriaMobilityPlatform.Domain.Common;

namespace AlexandriaMobilityPlatform.Domain.Entities;

[Table("Routes")]
public class Route : BaseEntity
{
    public long CommunityId { get; set; }

    [Required]
    [MaxLength(200)]
    public string Name { get; set; } = string.Empty;

    [Required]
    [MaxLength(500)]
    public string StartPoint { get; set; } = string.Empty;

    [Required]
    [MaxLength(500)]
    public string EndPoint { get; set; } = string.Empty;

    [Column(TypeName = "decimal(9,6)")]
    public decimal StartLatitude { get; set; }

    [Column(TypeName = "decimal(9,6)")]
    public decimal StartLongitude { get; set; }

    [Column(TypeName = "decimal(9,6)")]
    public decimal EndLatitude { get; set; }

    [Column(TypeName = "decimal(9,6)")]
    public decimal EndLongitude { get; set; }

    [Column(TypeName = "decimal(8,3)")]
    public decimal DistanceKm { get; set; }

    public int EstimatedTimeMinutes { get; set; }

    public bool IsActive { get; set; } = true;

    [ForeignKey(nameof(CommunityId))]
    public Community Community { get; set; } = null!;

    public ICollection<Stop> Stops { get; set; } = new List<Stop>();
    public ICollection<Group> Groups { get; set; } = new List<Group>();
}
