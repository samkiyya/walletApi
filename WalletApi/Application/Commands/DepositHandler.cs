using Microsoft.EntityFrameworkCore;
using Npgsql;
using WalletApi.Application.Abstractions;
using WalletApi.Common.Exceptions;
using WalletApi.Data;
using WalletApi.DTOs;
using WalletApi.Models;

namespace WalletApi.Application.Commands;

public sealed record DepositCommand(Guid WalletId, decimal Amount, string IdempotencyKey);

public sealed class DepositHandler : ICommandHandler<DepositCommand, TransactionResponse>
{
    private readonly AppDbContext _db;
    private readonly ILogger<DepositHandler> _logger;

    public DepositHandler(AppDbContext db, ILogger<DepositHandler> logger)
    {
        _db = db;
        _logger = logger;
    }

    public async Task<TransactionResponse> HandleAsync(DepositCommand command, CancellationToken ct = default)
    {
        // Idempotency: if already processed, return existing result (safe retry)
        var existing = await _db.Transactions
            .AsNoTracking()
            .FirstOrDefaultAsync(t => t.IdempotencyKey == command.IdempotencyKey, ct);

        if (existing is not null)
        {
            _logger.LogInformation("Deposit idempotency hit | Key: {IdempotencyKey}, TxId: {TransactionId}",
                command.IdempotencyKey, existing.Id);
            return existing.ToResponse();
        }

        var wallet = await _db.Wallets.FindAsync([command.WalletId], ct)
            ?? throw new NotFoundException("Wallet", command.WalletId);

        wallet.Credit(command.Amount);

        var transaction = Transaction.Create(
            walletId: wallet.Id,
            type: TransactionType.Deposit,
            amount: command.Amount,
            balanceAfter: wallet.Balance,
            description: "Deposit",
            idempotencyKey: command.IdempotencyKey);

        _db.Transactions.Add(transaction);

        try
        {
            await _db.SaveChangesAsync(ct);
        }
        catch (DbUpdateConcurrencyException)
        {
            throw new ConcurrencyConflictException();
        }
        catch (DbUpdateException ex) when (IsUniqueViolation(ex))
        {
            // Race condition: another request with the same key completed between our check and save.
            // Fetch and return that result — this is correct idempotent behavior.
            var raced = await _db.Transactions
                .AsNoTracking()
                .FirstAsync(t => t.IdempotencyKey == command.IdempotencyKey, ct);
            return raced.ToResponse();
        }

        _logger.LogInformation(
            "Deposit completed | WalletId: {WalletId}, Amount: {Amount}, Balance: {Balance}, TxId: {TransactionId}",
            command.WalletId, command.Amount, wallet.Balance, transaction.Id);

        return transaction.ToResponse();
    }

    private static bool IsUniqueViolation(DbUpdateException ex)
        => ex.InnerException is PostgresException { SqlState: PostgresErrorCodes.UniqueViolation };
}
