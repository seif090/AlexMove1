using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using AlexandriaMobilityPlatform.Domain.Common;
using AlexandriaMobilityPlatform.Domain.Enums;

namespace AlexandriaMobilityPlatform.Domain.Entities;

[Table("Groups")]
public class Group : BaseEntity
{
    public long CommunityId { get; set; }

    public long RouteId { get; set; }

    public long DriverId { get; set; }

    public long VehicleId { get; set; }

    [Required]
    [MaxLength(200)]
    public string Name { get; set; } = string.Empty;

    public int Capacity { get; set; }

    public int AvailableSeats { get; set; }

    public TimeSpan DepartureTime { get; set; }

    public TimeSpan? ReturnTime { get; set; }

    public int WorkingDays { get; set; }

    public GroupStatusEnum Status { get; set; } = GroupStatusEnum.Active;

    public int SubscriptionType { get; set; }

    [Column(TypeName = "decimal(10,2)")]
    public decimal Price { get; set; }

    [ForeignKey(nameof(CommunityId))]
    public Community Community { get; set; } = null!;

    [ForeignKey(nameof(RouteId))]
    public Route Route { get; set; } = null!;

    [ForeignKey(nameof(DriverId))]
    public ApplicationUser Driver { get; set; } = null!;

    [ForeignKey(nameof(VehicleId))]
    public Vehicle Vehicle { get; set; } = null!;

    public ICollection<Booking> Bookings { get; set; } = new List<Booking>();
}
