using System.Text.Json.Serialization;
using FluentValidation;
using Microsoft.EntityFrameworkCore;
using Scalar.AspNetCore;
using Serilog;
using Serilog.Events;
using WalletApi.Application.Commands;
using WalletApi.Application.Queries;
using WalletApi.Common.Middleware;
using WalletApi.Data;
using WalletApi.DTOs;
using WalletApi.Validators;

// ── Serilog bootstrap ─────────────────────────────────────────────────
Log.Logger = new LoggerConfiguration()
    .MinimumLevel.Information()
    .MinimumLevel.Override("Microsoft.AspNetCore", LogEventLevel.Warning)
    .MinimumLevel.Override("Microsoft.EntityFrameworkCore", LogEventLevel.Warning)
    .Enrich.FromLogContext()
    .WriteTo.Console(
        outputTemplate: "[{Timestamp:HH:mm:ss} {Level:u3}] {Message:lj} " +
                        "{Properties:j}{NewLine}{Exception}")
    .CreateLogger();

try
{
    var builder = WebApplication.CreateBuilder(args);
    builder.Host.UseSerilog();
    // ── PORT CONFIG (🔥 REQUIRED FOR RENDER) ─────────────────────────
    var port = Environment.GetEnvironmentVariable("PORT") ?? "8080";
    builder.WebHost.UseUrls($"http://0.0.0.0:{port}");

    // ── EF Core + PostgreSQL ──────────────────────────────────────────
    builder.Services.AddDbContext<AppDbContext>(options =>
        options.UseNpgsql(
            builder.Configuration.GetConnectionString("Default"),
            npgsqlOptions =>
            {
                npgsqlOptions.EnableRetryOnFailure(
                    maxRetryCount: 3,
                    maxRetryDelay: TimeSpan.FromSeconds(10),
                    errorCodesToAdd: null);
            }));

    // ── CQRS Command Handlers ─────────────────────────────────────────
    builder.Services.AddScoped<CreateWalletHandler>();
    builder.Services.AddScoped<DepositHandler>();
    builder.Services.AddScoped<WithdrawHandler>();
    builder.Services.AddScoped<TransferHandler>();

    // ── CQRS Query Handlers ───────────────────────────────────────────
    builder.Services.AddScoped<GetWalletHandler>();
    builder.Services.AddScoped<GetWalletsHandler>();
    builder.Services.AddScoped<GetTransactionsHandler>();

    // ── FluentValidation (manual invocation — no deprecated auto-validation) ──
    builder.Services.AddScoped<IValidator<DepositRequest>, DepositRequestValidator>();
    builder.Services.AddScoped<IValidator<WithdrawRequest>, WithdrawRequestValidator>();
    builder.Services.AddScoped<IValidator<TransferRequest>, TransferRequestValidator>();

    // ── API Configuration ─────────────────────────────────────────────
    builder.Services.AddControllers()
        .AddJsonOptions(options =>
        {
            options.JsonSerializerOptions.Converters.Add(new JsonStringEnumConverter());
            options.JsonSerializerOptions.DefaultIgnoreCondition = JsonIgnoreCondition.WhenWritingNull;
        });

    builder.Services.AddOpenApi();

    var app = builder.Build();

    // ── Apply Database Migrations on Startup ──────────────────────────
    // ── DB MIGRATION (Production-safe) ──────────────────────────────
    using (var scope = app.Services.CreateScope())
    {
        var db = scope.ServiceProvider.GetRequiredService<AppDbContext>();

        if (app.Environment.IsDevelopment())
        {
            db.Database.Migrate();
        }
        else
        {
            // Production: safer retry strategy
            var retries = 5;
            while (retries-- > 0)
            {
                try
                {
                    db.Database.Migrate();
                    break;
                }
                catch
                {
                    Thread.Sleep(5000);
                }
            }
        }
    }

    // ── Middleware Pipeline ───────────────────────────────────────────
    // Order matters: CorrelationId must run before ExceptionMiddleware
    // so that error responses include the trace ID.
    app.UseMiddleware<CorrelationIdMiddleware>();
    app.UseMiddleware<ExceptionMiddleware>();

    if (app.Environment.IsDevelopment())
    {
        app.MapOpenApi();
        app.MapScalarApiReference();
    }

    // app.UseHttpsRedirection();
    app.UseAuthorization();
    app.MapControllers();

    Log.Information("WalletApi started on port {Port}", port);
    app.Run();
}
catch (Exception ex)
{
    Log.Fatal(ex, "Application terminated unexpectedly");
}
finally
{
    Log.CloseAndFlush();
}