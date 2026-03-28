using Microsoft.EntityFrameworkCore;
using WalletApi.Application.Abstractions;
using WalletApi.Common.Exceptions;
using WalletApi.Data;
using WalletApi.DTOs;

namespace WalletApi.Application.Queries;

public sealed record GetWalletQuery(Guid WalletId);

public sealed class GetWalletHandler : IQueryHandler<GetWalletQuery, WalletResponse>
{
    private readonly AppDbContext _db;

    public GetWalletHandler(AppDbContext db) => _db = db;

    public async Task<WalletResponse> HandleAsync(GetWalletQuery query, CancellationToken ct = default)
    {
        var wallet = await _db.Wallets
            .AsNoTracking() // Read-only: no change tracking overhead
            .FirstOrDefaultAsync(w => w.Id == query.WalletId, ct)
            ?? throw new NotFoundException("Wallet", query.WalletId);

        return wallet.ToResponse();
    }
}
