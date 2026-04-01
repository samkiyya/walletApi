namespace WalletApi.Common;

/// <summary>
/// Standardized API response wrapper. Every response — success or failure — uses this envelope.
/// </summary>
public sealed class ApiEnvelope<T>
{
    public bool Success { get; private init; }
    public T? Data { get; private init; }
    public IReadOnlyList<string>? Errors { get; private init; }
    public string? TraceId { get; private init; }
    public DateTime Timestamp { get; private init; }

    public static ApiEnvelope<T> Ok(T data, string? traceId = null) => new()
    {
        Success = true,
        Data = data,
        TraceId = traceId,
        Timestamp = DateTime.UtcNow
    };

    public static ApiEnvelope<T> Fail(IReadOnlyList<string> errors, string? traceId = null) => new()
    {
        Success = false,
        Errors = errors,
        TraceId = traceId,
        Timestamp = DateTime.UtcNow
    };

    public static ApiEnvelope<T> Fail(string error, string? traceId = null)
        => Fail([error], traceId);
}
