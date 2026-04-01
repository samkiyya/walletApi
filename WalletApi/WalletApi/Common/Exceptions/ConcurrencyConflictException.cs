namespace WalletApi.Common.Exceptions;

public sealed class ConcurrencyConflictException : DomainException
{
    public ConcurrencyConflictException()
        : base("The resource was modified by another request. Please retry the operation.") { }

    public ConcurrencyConflictException(string message) : base(message) { }
}
