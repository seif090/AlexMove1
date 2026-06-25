using AlexandriaMobilityPlatform.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace AlexandriaMobilityPlatform.Infrastructure.Data.Configurations;

public class AuditLogConfiguration : IEntityTypeConfiguration<AuditLog>
{
    public void Configure(EntityTypeBuilder<AuditLog> builder)
    {
        builder.ToTable("AuditLogs");
        builder.HasKey(al => al.Id);
        builder.Property(al => al.EntityType).IsRequired().HasMaxLength(100);
        builder.Property(al => al.Action).IsRequired().HasMaxLength(50);
        builder.Property(al => al.OldValuesJson).HasMaxLength(int.MaxValue);
        builder.Property(al => al.NewValuesJson).HasMaxLength(int.MaxValue);
        builder.Property(al => al.IpAddress).HasMaxLength(50);
        builder.Property(al => al.UserAgent).HasMaxLength(500);
    }
}
