using WalletApi.Application.Abstractions;
using WalletApi.Data;
using WalletApi.DTOs;
using WalletApi.Models;

namespace WalletApi.Application.Commands;

public sealed record CreateWalletCommand(string? OwnerName);

public sealed class CreateWalletHandler : ICommandHandler<CreateWalletCommand, WalletResponse>
{
    private readonly AppDbContext _db;
    private readonly ILogger<CreateWalletHandler> _logger;

    public CreateWalletHandler(AppDbContext db, ILogger<CreateWalletHandler> logger)
    {
        _db = db;
        _logger = logger;
    }

    public async Task<WalletResponse> HandleAsync(CreateWalletCommand command, CancellationToken ct = default)
    {
        var wallet = Wallet.Create(command.OwnerName);

        _db.Wallets.Add(wallet);
        await _db.SaveChangesAsync(ct);

        _logger.LogInformation("Wallet created | WalletId: {WalletId}, Owner: {OwnerName}",
            wallet.Id, command.OwnerName ?? "(none)");

        return wallet.ToResponse();
    }
}
