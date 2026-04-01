namespace WalletApi.Common.Exceptions;

public sealed class InsufficientFundsException : DomainException
{
    public Guid WalletId { get; }
    public decimal CurrentBalance { get; }
    public decimal RequestedAmount { get; }

    public InsufficientFundsException(Guid walletId, decimal currentBalance, decimal requestedAmount)
        : base($"Insufficient funds in wallet '{walletId}'. Available: {currentBalance:F2}, Requested: {requestedAmount:F2}")
    {
        WalletId = walletId;
        CurrentBalance = currentBalance;
        RequestedAmount = requestedAmount;
    }
}
