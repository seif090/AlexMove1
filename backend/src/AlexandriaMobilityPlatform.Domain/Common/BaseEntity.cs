using System.ComponentModel.DataAnnotations;

namespace AlexandriaMobilityPlatform.Domain.Common;

public abstract class BaseEntity
{
    [Key]
    public long Id { get; set; }

    public DateTimeOffset CreatedAt { get; set; } = DateTimeOffset.UtcNow;

    public DateTimeOffset? UpdatedAt { get; set; }

    public bool IsDeleted { get; set; }

    public DateTimeOffset? DeletedAt { get; set; }
}
