using AlexandriaMobilityPlatform.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace AlexandriaMobilityPlatform.Infrastructure.Data.Configurations;

public class BookingConfiguration : IEntityTypeConfiguration<Booking>
{
    public void Configure(EntityTypeBuilder<Booking> builder)
    {
        builder.ToTable("Bookings");
        builder.HasKey(b => b.Id);
        builder.HasOne(b => b.User).WithMany().HasForeignKey(b => b.UserId).OnDelete(DeleteBehavior.Cascade);
        builder.HasOne(b => b.Group).WithMany(g => g.Bookings).HasForeignKey(b => b.GroupId).OnDelete(DeleteBehavior.Cascade);
        builder.HasIndex(b => new { b.UserId, b.BookingDate });
        builder.HasIndex(b => new { b.GroupId, b.BookingDate });
        builder.HasQueryFilter(b => !b.IsDeleted);
    }
}
