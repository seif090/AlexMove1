using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using AlexandriaMobilityPlatform.Domain.Common;
using AlexandriaMobilityPlatform.Domain.Enums;

namespace AlexandriaMobilityPlatform.Domain.Entities;

[Table("Payments")]
public class Payment : BaseEntity
{
    public long UserId { get; set; }

    public long? BookingId { get; set; }

    public long? SubscriptionId { get; set; }

    [Column(TypeName = "decimal(10,2)")]
    public decimal Amount { get; set; }

    [Required]
    [MaxLength(10)]
    public string Currency { get; set; } = "EGP";

    public PaymentMethodEnum PaymentMethod { get; set; }

    public PaymentStatusEnum Status { get; set; } = PaymentStatusEnum.Pending;

    [MaxLength(500)]
    public string? ProviderReference { get; set; }

    public DateTimeOffset? PaidAt { get; set; }

    [ForeignKey(nameof(UserId))]
    public ApplicationUser User { get; set; } = null!;
}
