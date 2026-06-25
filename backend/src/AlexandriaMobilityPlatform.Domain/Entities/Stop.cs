using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using AlexandriaMobilityPlatform.Domain.Common;

namespace AlexandriaMobilityPlatform.Domain.Entities;

[Table("Stops")]
public class Stop : BaseEntity
{
    public long RouteId { get; set; }

    [Required]
    [MaxLength(200)]
    public string Name { get; set; } = string.Empty;

    [Column(TypeName = "decimal(9,6)")]
    public decimal Latitude { get; set; }

    [Column(TypeName = "decimal(9,6)")]
    public decimal Longitude { get; set; }

    public int OrderNumber { get; set; }

    public int EstimatedArrivalMinutes { get; set; }

    [ForeignKey(nameof(RouteId))]
    public Route Route { get; set; } = null!;
}
