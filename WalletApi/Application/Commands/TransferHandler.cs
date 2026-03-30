using Microsoft.EntityFrameworkCore;
using Npgsql;
using WalletApi.Application.Abstractions;
using WalletApi.Common.Exceptions;
using WalletApi.Data;
using WalletApi.DTOs;
using WalletApi.Models;

namespace WalletApi.Application.Commands;

public sealed record TransferCommand(Guid FromWalletId, Guid ToWalletId, decimal Amount, string IdempotencyKey);

public sealed class TransferHandler : ICommandHandler<TransferCommand, TransferResponse>
{
    private readonly AppDbContext _db;
    private readonly ILogger<TransferHandler> _logger;

    public TransferHandler(AppDbContext db, ILogger<TransferHandler> logger)
    {
        _db = db;
        _logger = logger;
    }

    public async Task<TransferResponse> HandleAsync(TransferCommand command, CancellationToken ct = default)
    {
        // Idempotency check: transfers produce two transactions sharing the same ReferenceTransactionId.
        // The debit side carries the original idempotency key; credit side uses a derived key.
        var existingDebit = await _db.Transactions
            .AsNoTracking()
            .FirstOrDefaultAsync(t => t.IdempotencyKey == command.IdempotencyKey, ct);

        if (existingDebit is not null)
        {
            var existingCredit = await _db.Transactions
                .AsNoTracking()
                .FirstOrDefaultAsync(t =>
                    t.ReferenceTransactionId == existingDebit.ReferenceTransactionId
                    && t.Id != existingDebit.Id, ct);

            if (existingCredit is not null)
            {
                if (existingDebit.WalletId != command.FromWalletId ||
                    existingCredit.WalletId != command.ToWalletId ||
                    existingDebit.Amount != command.Amount)
                {
                    throw new IdempotencyMismatchException(command.IdempotencyKey);
                }

                _logger.LogInformation("Transfer idempotency hit | Key: {IdempotencyKey}", command.IdempotencyKey);
                return new TransferResponse(existingDebit.ToResponse(), existingCredit.ToResponse());
            }
        }

        // Consistent lock ordering by wallet ID to prevent deadlocks.
        // Always acquire the lower-ID wallet first.
        var orderedIds = new[] { command.FromWalletId, command.ToWalletId }
            .OrderBy(id => id)
            .ToArray();

        var strategy = _db.Database.CreateExecutionStrategy();
        return await strategy.ExecuteAsync(async () =>
        {
            await using var tx = await _db.Database.BeginTransactionAsync(ct);

            var wallets = await _db.Wallets
                .Where(w => orderedIds.Contains(w.Id))
                .OrderBy(w => w.Id)
                .ToListAsync(ct);

            var sender = wallets.FirstOrDefault(w => w.Id == command.FromWalletId)
                ?? throw new NotFoundException("Wallet", command.FromWalletId);

            var receiver = wallets.FirstOrDefault(w => w.Id == command.ToWalletId)
                ?? throw new NotFoundException("Wallet", command.ToWalletId);

            // Domain invariants enforced by entity methods
            sender.Debit(command.Amount);
            receiver.Credit(command.Amount);

            var referenceId = Guid.NewGuid();

            var debitTx = Transaction.Create(
                walletId: sender.Id,
                type: TransactionType.TransferOut,
                amount: command.Amount,
                balanceAfter: sender.Balance,
                description: $"Transfer to wallet {receiver.Id}",
                idempotencyKey: command.IdempotencyKey,
                referenceTransactionId: referenceId);

            var creditTx = Transaction.Create(
                walletId: receiver.Id,
                type: TransactionType.TransferIn,
                amount: command.Amount,
                balanceAfter: receiver.Balance,
                description: $"Transfer from wallet {sender.Id}",
                idempotencyKey: $"{command.IdempotencyKey}:cr",
                referenceTransactionId: referenceId);

            _db.Transactions.AddRange(debitTx, creditTx);

            try
            {
                await _db.SaveChangesAsync(ct);
                await tx.CommitAsync(ct);
            }
            catch (DbUpdateConcurrencyException)
            {
                throw new ConcurrencyConflictException();
            }
            catch (DbUpdateException ex) when (IsUniqueViolation(ex))
            {
                // Race condition on idempotency key — re-fetch the already-committed transfer
                var racedDebit = await _db.Transactions
                    .AsNoTracking()
                    .FirstAsync(t => t.IdempotencyKey == command.IdempotencyKey, ct);

                var racedCredit = await _db.Transactions
                    .AsNoTracking()
                    .FirstAsync(t =>
                        t.ReferenceTransactionId == racedDebit.ReferenceTransactionId
                        && t.Id != racedDebit.Id, ct);

                return new TransferResponse(racedDebit.ToResponse(), racedCredit.ToResponse());
            }

            _logger.LogInformation(
                "Transfer completed | From: {FromWalletId}, To: {ToWalletId}, Amount: {Amount}, RefId: {ReferenceId}",
                command.FromWalletId, command.ToWalletId, command.Amount, referenceId);

            return new TransferResponse(debitTx.ToResponse(), creditTx.ToResponse());
        });
    }

    private static bool IsUniqueViolation(DbUpdateException ex)
        => ex.InnerException is PostgresException { SqlState: PostgresErrorCodes.UniqueViolation };
}
