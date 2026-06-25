using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using AlexandriaMobilityPlatform.Domain.Common;
using AlexandriaMobilityPlatform.Domain.Enums;

namespace AlexandriaMobilityPlatform.Domain.Entities;

[Table("Trips")]
public class Trip : BaseEntity
{
    public long GroupId { get; set; }

    public DateTime TripDate { get; set; }

    public TripStatusEnum Status { get; set; } = TripStatusEnum.Scheduled;

    public DateTimeOffset? StartedAt { get; set; }

    public DateTimeOffset? CompletedAt { get; set; }

    [MaxLength(1000)]
    public string? DriverNotes { get; set; }

    [ForeignKey(nameof(GroupId))]
    public Group Group { get; set; } = null!;

    public ICollection<DriverLocation> DriverLocations { get; set; } = new List<DriverLocation>();
}
