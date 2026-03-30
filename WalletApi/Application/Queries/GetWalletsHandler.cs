using Microsoft.EntityFrameworkCore;
using WalletApi.Application.Abstractions;
using WalletApi.Data;
using WalletApi.DTOs;

namespace WalletApi.Application.Queries;

public sealed record GetWalletsQuery(int Page = 1, int PageSize = 20);

public sealed class GetWalletsHandler
    : IQueryHandler<GetWalletsQuery, PagedResponse<WalletResponse>>
{
    private readonly AppDbContext _db;

    public GetWalletsHandler(AppDbContext db) => _db = db;

    public async Task<PagedResponse<WalletResponse>> HandleAsync(
        GetWalletsQuery query, CancellationToken ct = default)
    {
        var totalCount = await _db.Wallets.CountAsync(ct);

        var wallets = await _db.Wallets
            .AsNoTracking()
            .OrderByDescending(w => w.CreatedAtUtc)
            .Skip((query.Page - 1) * query.PageSize)
            .Take(query.PageSize)
            .ToListAsync(ct);

        return new PagedResponse<WalletResponse>(
            Items: wallets.Select(w => w.ToResponse()).ToList(),
            TotalCount: totalCount,
            Page: query.Page,
            PageSize: query.PageSize);
    }
}
