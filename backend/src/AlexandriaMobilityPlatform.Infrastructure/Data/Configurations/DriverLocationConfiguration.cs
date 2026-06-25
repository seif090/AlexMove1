using AlexandriaMobilityPlatform.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace AlexandriaMobilityPlatform.Infrastructure.Data.Configurations;

public class DriverLocationConfiguration : IEntityTypeConfiguration<DriverLocation>
{
    public void Configure(EntityTypeBuilder<DriverLocation> builder)
    {
        builder.ToTable("DriverLocations");
        builder.HasKey(dl => dl.Id);
        builder.Property(dl => dl.Latitude).HasColumnType("decimal(9,6)");
        builder.Property(dl => dl.Longitude).HasColumnType("decimal(9,6)");
        builder.Property(dl => dl.AccuracyMeters).HasColumnType("decimal(6,2)");
        builder.HasOne(dl => dl.Trip).WithMany(t => t.DriverLocations).HasForeignKey(dl => dl.TripId).OnDelete(DeleteBehavior.Cascade);
        builder.HasIndex(dl => new { dl.TripId, dl.RecordedAt });
    }
}
