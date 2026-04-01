namespace WalletApi.Common.Exceptions;

public sealed class IdempotencyMismatchException : DomainException
{
    public string IdempotencyKey { get; }

    public IdempotencyMismatchException(string idempotencyKey)
        : base($"The idempotency key '{idempotencyKey}' was already used with a different request payload.")
    {
        IdempotencyKey = idempotencyKey;
    }
}
