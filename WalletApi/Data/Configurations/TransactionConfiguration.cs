using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using WalletApi.Models;

namespace WalletApi.Data.Configurations;

public sealed class TransactionConfiguration : IEntityTypeConfiguration<Transaction>
{
    public void Configure(EntityTypeBuilder<Transaction> builder)
    {
        builder.HasKey(t => t.Id);

        builder.Property(t => t.Type)
            .HasConversion<string>() // Store enum as string for readability in DB
            .HasMaxLength(20);

        builder.Property(t => t.Amount)
            .HasPrecision(18, 2);

        builder.Property(t => t.BalanceAfter)
            .HasPrecision(18, 2);

        builder.Property(t => t.Description)
            .HasMaxLength(500);

        builder.Property(t => t.IdempotencyKey)
            .HasMaxLength(100);

        builder.Property(t => t.CreatedAtUtc)
            .HasDefaultValueSql("now() at time zone 'utc'");

        // Filtered unique index: only enforces uniqueness on non-null keys.
        // Standard PostgreSQL unique indexes do NOT constrain NULLs — this makes the intent explicit.
        builder.HasIndex(t => t.IdempotencyKey)
            .IsUnique()
            .HasFilter("\"IdempotencyKey\" IS NOT NULL");

        // Composite index for efficient transaction history queries (GetTransactions by wallet + date)
        builder.HasIndex(t => new { t.WalletId, t.CreatedAtUtc })
            .IsDescending(false, true);

        // Index for transfer pair lookups
        builder.HasIndex(t => t.ReferenceTransactionId)
            .HasFilter("\"ReferenceTransactionId\" IS NOT NULL");
    }
}
