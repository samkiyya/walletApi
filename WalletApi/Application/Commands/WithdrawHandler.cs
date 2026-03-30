using Microsoft.EntityFrameworkCore;
using Npgsql;
using WalletApi.Application.Abstractions;
using WalletApi.Common.Exceptions;
using WalletApi.Data;
using WalletApi.DTOs;
using WalletApi.Models;

namespace WalletApi.Application.Commands;

public sealed record WithdrawCommand(Guid WalletId, decimal Amount, string IdempotencyKey);

public sealed class WithdrawHandler : ICommandHandler<WithdrawCommand, TransactionResponse>
{
    private readonly AppDbContext _db;
    private readonly ILogger<WithdrawHandler> _logger;

    public WithdrawHandler(AppDbContext db, ILogger<WithdrawHandler> logger)
    {
        _db = db;
        _logger = logger;
    }

    public async Task<TransactionResponse> HandleAsync(WithdrawCommand command, CancellationToken ct = default)
    {
        // Idempotency: if already processed, return existing result OR throw if payload differs
        var existing = await _db.Transactions
            .AsNoTracking()
            .FirstOrDefaultAsync(t => t.IdempotencyKey == command.IdempotencyKey, ct);

        if (existing is not null)
        {
            if (existing.WalletId != command.WalletId || existing.Amount != command.Amount)
                throw new IdempotencyMismatchException(command.IdempotencyKey);

            _logger.LogInformation("Withdraw idempotency hit | Key: {IdempotencyKey}, TxId: {TransactionId}",
                command.IdempotencyKey, existing.Id);
            return existing.ToResponse();
        }

        var wallet = await _db.Wallets.FindAsync([command.WalletId], ct)
            ?? throw new NotFoundException("Wallet", command.WalletId);

        // Domain invariant: Debit() throws InsufficientFundsException if balance < amount
        wallet.Debit(command.Amount);

        var transaction = Transaction.Create(
            walletId: wallet.Id,
            type: TransactionType.Withdrawal,
            amount: command.Amount,
            balanceAfter: wallet.Balance,
            description: "Withdrawal",
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
            var raced = await _db.Transactions
                .AsNoTracking()
                .FirstAsync(t => t.IdempotencyKey == command.IdempotencyKey, ct);
            return raced.ToResponse();
        }

        _logger.LogInformation(
            "Withdrawal completed | WalletId: {WalletId}, Amount: {Amount}, Balance: {Balance}, TxId: {TransactionId}",
            command.WalletId, command.Amount, wallet.Balance, transaction.Id);

        return transaction.ToResponse();
    }

    private static bool IsUniqueViolation(DbUpdateException ex)
        => ex.InnerException is PostgresException { SqlState: PostgresErrorCodes.UniqueViolation };
}
