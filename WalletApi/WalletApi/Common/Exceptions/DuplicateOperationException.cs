namespace WalletApi.Common.Exceptions;

public sealed class DuplicateOperationException : DomainException
{
    public string? IdempotencyKey { get; }

    public DuplicateOperationException(string? idempotencyKey = null)
        : base("This operation has already been processed.")
    {
        IdempotencyKey = idempotencyKey;
    }
}
