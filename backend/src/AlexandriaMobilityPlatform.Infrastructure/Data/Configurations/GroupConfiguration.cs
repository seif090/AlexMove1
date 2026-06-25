using AlexandriaMobilityPlatform.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace AlexandriaMobilityPlatform.Infrastructure.Data.Configurations;

public class GroupConfiguration : IEntityTypeConfiguration<Group>
{
    public void Configure(EntityTypeBuilder<Group> builder)
    {
        builder.ToTable("Groups");
        builder.HasKey(g => g.Id);
        builder.Property(g => g.Name).IsRequired().HasMaxLength(200);
        builder.Property(g => g.Price).HasColumnType("decimal(10,2)");
        builder.HasOne(g => g.Community).WithMany(c => c.Groups).HasForeignKey(g => g.CommunityId).OnDelete(DeleteBehavior.Cascade);
        builder.HasOne(g => g.Route).WithMany(r => r.Groups).HasForeignKey(g => g.RouteId).OnDelete(DeleteBehavior.Restrict);
        builder.HasOne(g => g.Driver).WithMany().HasForeignKey(g => g.DriverId).OnDelete(DeleteBehavior.Restrict);
        builder.HasOne(g => g.Vehicle).WithMany().HasForeignKey(g => g.VehicleId).OnDelete(DeleteBehavior.Restrict);
        builder.HasIndex(g => new { g.CommunityId, g.Status });
        builder.HasQueryFilter(g => !g.IsDeleted);
    }
}
