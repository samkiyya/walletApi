using WalletApi.Common.Exceptions;

namespace WalletApi.Models;

public class Wallet
{
    public Guid Id { get; private set; }
    public string? OwnerName { get; private set; }
    public decimal Balance { get; private set; }
    public DateTime CreatedAtUtc { get; private set; }

    // PostgreSQL xmin system column — used as optimistic concurrency token.
    // Automatically updated by PostgreSQL on every row modification.
    public uint Version { get; private set; }

    // Navigation
    public ICollection<Transaction> Transactions { get; private set; } = [];

    private Wallet() { } // Required by EF Core

    public static Wallet Create(string? ownerName = null)
    {
        return new Wallet
        {
            Id = Guid.NewGuid(),
            OwnerName = ownerName,
            Balance = 0m,
            CreatedAtUtc = DateTime.UtcNow
        };
    }

    // Increases the wallet balance. Amount must be positive.
    public void Credit(decimal amount)
    {
        ArgumentOutOfRangeException.ThrowIfNegativeOrZero(amount);
        Balance += amount;
    }

    // Decreases the wallet balance. Throws if insufficient funds.
    public void Debit(decimal amount)
    {
        ArgumentOutOfRangeException.ThrowIfNegativeOrZero(amount);

        if (Balance < amount)
            throw new InsufficientFundsException(Id, Balance, amount);

        Balance -= amount;
    }
}