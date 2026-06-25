using AlexandriaMobilityPlatform.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace AlexandriaMobilityPlatform.Infrastructure.Data.Configurations;

public class CommunityMemberConfiguration : IEntityTypeConfiguration<CommunityMember>
{
    public void Configure(EntityTypeBuilder<CommunityMember> builder)
    {
        builder.ToTable("CommunityMembers");
        builder.HasKey(cm => cm.Id);
        builder.HasOne(cm => cm.User).WithMany().HasForeignKey(cm => cm.UserId).OnDelete(DeleteBehavior.Cascade);
        builder.HasOne(cm => cm.Community).WithMany(c => c.CommunityMembers).HasForeignKey(cm => cm.CommunityId).OnDelete(DeleteBehavior.Cascade);
        builder.HasIndex(cm => new { cm.UserId, cm.CommunityId }).IsUnique();
    }
}
