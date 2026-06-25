using AlexandriaMobilityPlatform.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace AlexandriaMobilityPlatform.Infrastructure.Data.Configurations;

public class RouteConfiguration : IEntityTypeConfiguration<Route>
{
    public void Configure(EntityTypeBuilder<Route> builder)
    {
        builder.ToTable("Routes");
        builder.HasKey(r => r.Id);
        builder.Property(r => r.Name).IsRequired().HasMaxLength(200);
        builder.Property(r => r.StartPoint).IsRequired().HasMaxLength(300);
        builder.Property(r => r.EndPoint).IsRequired().HasMaxLength(300);
        builder.Property(r => r.StartLatitude).HasColumnType("decimal(9,6)");
        builder.Property(r => r.StartLongitude).HasColumnType("decimal(9,6)");
        builder.Property(r => r.EndLatitude).HasColumnType("decimal(9,6)");
        builder.Property(r => r.EndLongitude).HasColumnType("decimal(9,6)");
        builder.Property(r => r.DistanceKm).HasColumnType("decimal(8,3)");
        builder.HasOne(r => r.Community).WithMany(c => c.Routes).HasForeignKey(r => r.CommunityId).OnDelete(DeleteBehavior.Cascade);
        builder.HasQueryFilter(r => !r.IsDeleted);
    }
}
