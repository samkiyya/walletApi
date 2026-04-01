using WalletApi.Models;

namespace WalletApi.DTOs;

// ── Response DTOs ─────────────────────────────────────────────────────

public sealed record WalletResponse(
    Guid Id,
    string? OwnerName,
    decimal Balance,
    DateTime CreatedAtUtc);

public sealed record TransactionResponse(
    Guid Id,
    Guid WalletId,
    string Type,
    decimal Amount,
    decimal BalanceAfter,
    string? Description,
    string? IdempotencyKey,
    Guid? ReferenceTransactionId,
    DateTime CreatedAtUtc);

public sealed record TransferResponse(
    TransactionResponse Debit,
    TransactionResponse Credit);

public sealed record PagedResponse<T>(
    IReadOnlyList<T> Items,
    int TotalCount,
    int Page,
    int PageSize)
{
    public bool HasNextPage => Page * PageSize < TotalCount;
    public bool HasPreviousPage => Page > 1;
}

// ── Mapping Extensions ───────────────────────────────────────────────
// Manual mapping: explicit, zero-overhead, no reflection. Replaces AutoMapper.

public static class ResponseMappings
{
    public static WalletResponse ToResponse(this Wallet wallet) =>
        new(wallet.Id, wallet.OwnerName, wallet.Balance, wallet.CreatedAtUtc);

    public static TransactionResponse ToResponse(this Transaction tx) =>
        new(tx.Id, tx.WalletId, tx.Type.ToString(), tx.Amount, tx.BalanceAfter,
            tx.Description, tx.IdempotencyKey, tx.ReferenceTransactionId, tx.CreatedAtUtc);
}
