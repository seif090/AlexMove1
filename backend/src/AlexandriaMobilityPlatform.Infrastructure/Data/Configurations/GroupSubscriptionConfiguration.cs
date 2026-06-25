using AlexandriaMobilityPlatform.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace AlexandriaMobilityPlatform.Infrastructure.Data.Configurations;

public class GroupSubscriptionConfiguration : IEntityTypeConfiguration<GroupSubscription>
{
    public void Configure(EntityTypeBuilder<GroupSubscription> builder)
    {
        builder.ToTable("GroupSubscriptions");
        builder.HasKey(gs => gs.Id);
        builder.HasOne(gs => gs.User).WithMany().HasForeignKey(gs => gs.UserId).OnDelete(DeleteBehavior.Cascade);
        builder.HasOne(gs => gs.Group).WithMany().HasForeignKey(gs => gs.GroupId).OnDelete(DeleteBehavior.Cascade);
    }
}
