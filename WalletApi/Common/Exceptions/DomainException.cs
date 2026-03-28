using System.Reflection.Emit;

namespace WalletApi.Common.Exceptions;

// Base exception for all domain-level errors.
// Mapped to 400-class HTTP responses by the exception middleware
public class DomainException : Exception
{
    public DomainException(string message) : base(message) { }
    public DomainException(string message, Exception innerException) : base(message, innerException) { }
}
