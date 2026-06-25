using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using AlexandriaMobilityPlatform.Domain.Common;
using AlexandriaMobilityPlatform.Domain.Enums;

namespace AlexandriaMobilityPlatform.Domain.Entities;

[Table("Vehicles")]
public class Vehicle : BaseEntity
{
    public long DriverId { get; set; }

    public long? CommunityId { get; set; }

    [Required]
    [MaxLength(20)]
    public string PlateNumber { get; set; } = string.Empty;

    [Required]
    [MaxLength(100)]
    public string Model { get; set; } = string.Empty;

    [Required]
    [MaxLength(50)]
    public string Color { get; set; } = string.Empty;

    public int Capacity { get; set; }

    public int Year { get; set; }

    public VehicleStatusEnum Status { get; set; } = VehicleStatusEnum.Active;

    public bool IsActive { get; set; } = true;

    [ForeignKey(nameof(DriverId))]
    public ApplicationUser Driver { get; set; } = null!;

    [ForeignKey(nameof(CommunityId))]
    public Community? Community { get; set; }
}
