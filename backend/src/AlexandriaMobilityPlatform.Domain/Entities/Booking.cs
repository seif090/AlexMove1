using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using AlexandriaMobilityPlatform.Domain.Common;
using AlexandriaMobilityPlatform.Domain.Enums;

namespace AlexandriaMobilityPlatform.Domain.Entities;

[Table("Bookings")]
public class Booking : BaseEntity
{
    public long UserId { get; set; }

    public long GroupId { get; set; }

    public DateTime BookingDate { get; set; }

    public long? PickupStopId { get; set; }

    public BookingStatusEnum Status { get; set; } = BookingStatusEnum.Confirmed;

    public PaymentStatusEnum PaymentStatus { get; set; } = PaymentStatusEnum.Pending;

    [ForeignKey(nameof(UserId))]
    public ApplicationUser User { get; set; } = null!;

    [ForeignKey(nameof(GroupId))]
    public Group Group { get; set; } = null!;

    [ForeignKey(nameof(PickupStopId))]
    public Stop? PickupStop { get; set; }
}
