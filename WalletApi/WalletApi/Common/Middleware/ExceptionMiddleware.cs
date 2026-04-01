using Microsoft.EntityFrameworkCore;
using WalletApi.Common.Exceptions;

namespace WalletApi.Common.Middleware;

/// <summary>
/// Global exception handler that maps domain exceptions to structured HTTP responses.
/// Never leaks internal exception details in non-development environments.
/// </summary>
public sealed class ExceptionMiddleware
{
    private readonly RequestDelegate _next;
    private readonly ILogger<ExceptionMiddleware> _logger;
    private readonly IHostEnvironment _environment;

    public ExceptionMiddleware(
        RequestDelegate next,
        ILogger<ExceptionMiddleware> logger,
        IHostEnvironment environment)
    {
        _next = next;
        _logger = logger;
        _environment = environment;
    }

    public async Task InvokeAsync(HttpContext context)
    {
        try
        {
            await _next(context);
        }
        catch (Exception ex)
        {
            await HandleExceptionAsync(context, ex);
        }
    }

    private async Task HandleExceptionAsync(HttpContext context, Exception exception)
    {
        var traceId = context.Items["CorrelationId"]?.ToString() ?? context.TraceIdentifier;

        var (statusCode, message) = exception switch
        {
            NotFoundException ex =>
                (StatusCodes.Status404NotFound, ex.Message),

            InsufficientFundsException ex =>
                (StatusCodes.Status422UnprocessableEntity, ex.Message),

            ConcurrencyConflictException =>
                (StatusCodes.Status409Conflict,
                 "The resource was modified by another request. Please retry."),

            DuplicateOperationException =>
                (StatusCodes.Status409Conflict,
                 "This operation has already been processed."),

            DomainException ex =>
                (StatusCodes.Status400BadRequest, ex.Message),

            DbUpdateConcurrencyException =>
                (StatusCodes.Status409Conflict,
                 "Concurrent modification detected. Please retry."),

            _ => (StatusCodes.Status500InternalServerError,
                  _environment.IsDevelopment()
                      ? exception.Message
                      : "An unexpected error occurred.")
        };

        // 5xx = Error (unexpected), 4xx = Warning (expected domain violations)
        if (statusCode >= 500)
            _logger.LogError(exception, "Unhandled exception | TraceId: {TraceId}", traceId);
        else
            _logger.LogWarning("Domain error: {ErrorType} — {Message} | TraceId: {TraceId}",
                exception.GetType().Name, exception.Message, traceId);

        context.Response.StatusCode = statusCode;
        context.Response.ContentType = "application/json";

        var envelope = ApiEnvelope<object>.Fail(message, traceId);

        await context.Response.WriteAsJsonAsync(envelope, context.RequestAborted);
    }
}