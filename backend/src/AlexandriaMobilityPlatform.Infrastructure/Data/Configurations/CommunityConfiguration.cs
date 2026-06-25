using AlexandriaMobilityPlatform.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace AlexandriaMobilityPlatform.Infrastructure.Data.Configurations;

public class CommunityConfiguration : IEntityTypeConfiguration<Community>
{
    public void Configure(EntityTypeBuilder<Community> builder)
    {
        builder.ToTable("Communities");
        builder.HasKey(c => c.Id);
        builder.Property(c => c.Name).IsRequired().HasMaxLength(200);
        builder.Property(c => c.City).IsRequired().HasMaxLength(100);
        builder.Property(c => c.Area).IsRequired().HasMaxLength(100);
        builder.Property(c => c.Address).IsRequired().HasMaxLength(500);
        builder.Property(c => c.LogoUrl).HasMaxLength(500);
        builder.HasOne(c => c.Admin).WithMany().HasForeignKey(c => c.AdminId).OnDelete(DeleteBehavior.Restrict);
        builder.HasQueryFilter(c => !c.IsDeleted);
    }
}
