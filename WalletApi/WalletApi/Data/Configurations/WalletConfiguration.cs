using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using WalletApi.Models;

namespace WalletApi.Data.Configurations;

public sealed class WalletConfiguration : IEntityTypeConfiguration<Wallet>
{
    public void Configure(EntityTypeBuilder<Wallet> builder)
    {
        builder.HasKey(w => w.Id);

        // PostgreSQL-native optimistic concurrency via the xmin system column.
        // EF Core will include a WHERE xmin = @originalXmin on every UPDATE,
        // triggering DbUpdateConcurrencyException if another transaction modified the row.
        builder.Property(w => w.Version)
            .IsRowVersion();

        builder.Property(w => w.Balance)
            .HasPrecision(18, 2);

        builder.Property(w => w.OwnerName)
            .HasMaxLength(200);

        builder.Property(w => w.CreatedAtUtc)
            .HasDefaultValueSql("now() at time zone 'utc'");

        builder.HasMany(w => w.Transactions)
            .WithOne(t => t.Wallet)
            .HasForeignKey(t => t.WalletId)
            .OnDelete(DeleteBehavior.Cascade);
    }
}
