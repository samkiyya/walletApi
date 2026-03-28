using Serilog.Context;

namespace WalletApi.Common.Middleware;

/// <summary>
/// Extracts or generates a correlation ID for every request.
/// Pushed into Serilog LogContext and response headers for end-to-end tracing.
/// </summary>
public sealed class CorrelationIdMiddleware
{
    private const string HeaderName = "X-Correlation-Id";
    private readonly RequestDelegate _next;

    public CorrelationIdMiddleware(RequestDelegate next) => _next = next;

    public async Task InvokeAsync(HttpContext context)
    {
        var correlationId = context.Request.Headers[HeaderName].FirstOrDefault()
                            ?? Guid.NewGuid().ToString("N");

        context.Items["CorrelationId"] = correlationId;
        context.Response.OnStarting(() =>
        {
            context.Response.Headers[HeaderName] = correlationId;
            return Task.CompletedTask;
        });

        using (LogContext.PushProperty("CorrelationId", correlationId))
        {
            await _next(context);
        }
    }
}
