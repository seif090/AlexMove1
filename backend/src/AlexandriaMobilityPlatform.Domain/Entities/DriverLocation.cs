using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using AlexandriaMobilityPlatform.Domain.Common;

namespace AlexandriaMobilityPlatform.Domain.Entities;

[Table("DriverLocations")]
public class DriverLocation : BaseEntity
{
    public long TripId { get; set; }

    public long DriverId { get; set; }

    [Column(TypeName = "decimal(9,6)")]
    public decimal Latitude { get; set; }

    [Column(TypeName = "decimal(9,6)")]
    public decimal Longitude { get; set; }

    public DateTimeOffset RecordedAt { get; set; } = DateTimeOffset.UtcNow;

    [Column(TypeName = "decimal(8,2)")]
    public decimal? AccuracyMeters { get; set; }

    [ForeignKey(nameof(TripId))]
    public Trip Trip { get; set; } = null!;

    [ForeignKey(nameof(DriverId))]
    public ApplicationUser Driver { get; set; } = null!;
}
