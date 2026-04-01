namespace WalletApi.Models;

public class Transaction
{
    public Guid Id { get; private set; }
    public Guid WalletId { get; private set; }
    public TransactionType Type { get; private set; }
    public decimal Amount { get; private set; }
    public decimal BalanceAfter { get; private set; }
    public string? Description { get; private set; }
    public string? IdempotencyKey { get; private set; }
    public Guid? ReferenceTransactionId { get; private set; }
    public DateTime CreatedAtUtc { get; private set; }

    // Navigation
    public Wallet Wallet { get; private set; } = default!;

    private Transaction() { } // Required by EF Core

    public static Transaction Create(
        Guid walletId,
        TransactionType type,
        decimal amount,
        decimal balanceAfter,
        string? description = null,
        string? idempotencyKey = null,
        Guid? referenceTransactionId = null)
    {
        return new Transaction
        {
            Id = Guid.NewGuid(),
            WalletId = walletId,
            Type = type,
            Amount = amount,
            BalanceAfter = balanceAfter,
            Description = description,
            IdempotencyKey = idempotencyKey,
            ReferenceTransactionId = referenceTransactionId,
            CreatedAtUtc = DateTime.UtcNow
        };
    }
}