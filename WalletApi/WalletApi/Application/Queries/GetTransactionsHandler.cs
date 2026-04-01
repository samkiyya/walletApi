using Microsoft.EntityFrameworkCore;
using WalletApi.Application.Abstractions;
using WalletApi.Common.Exceptions;
using WalletApi.Data;
using WalletApi.DTOs;

namespace WalletApi.Application.Queries;

public sealed record GetTransactionsQuery(Guid WalletId, int Page = 1, int PageSize = 20);

public sealed class GetTransactionsHandler
    : IQueryHandler<GetTransactionsQuery, PagedResponse<TransactionResponse>>
{
    private readonly AppDbContext _db;

    public GetTransactionsHandler(AppDbContext db) => _db = db;

    public async Task<PagedResponse<TransactionResponse>> HandleAsync(
        GetTransactionsQuery query, CancellationToken ct = default)
    {
        var walletExists = await _db.Wallets
            .AsNoTracking()
            .AnyAsync(w => w.Id == query.WalletId, ct);

        if (!walletExists)
            throw new NotFoundException("Wallet", query.WalletId);

        // Single-query count + items would require raw SQL; two queries is the standard EF Core approach.
        // The composite index on (WalletId, CreatedAtUtc DESC) ensures both queries are index-backed.
        var totalCount = await _db.Transactions
            .Where(t => t.WalletId == query.WalletId)
            .CountAsync(ct);

        var transactions = await _db.Transactions
            .AsNoTracking()
            .Where(t => t.WalletId == query.WalletId)
            .OrderByDescending(t => t.CreatedAtUtc)
            .Skip((query.Page - 1) * query.PageSize)
            .Take(query.PageSize)
            .ToListAsync(ct);

        return new PagedResponse<TransactionResponse>(
            Items: transactions.Select(t => t.ToResponse()).ToList(),
            TotalCount: totalCount,
            Page: query.Page,
            PageSize: query.PageSize);
    }
}
