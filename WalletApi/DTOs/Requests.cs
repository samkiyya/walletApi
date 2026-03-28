namespace WalletApi.DTOs;

// ── Request DTOs ──────────────────────────────────────────────────────
// Using 'required' keyword prevents over-posting by rejecting unbound properties.
// WalletId is NOT in deposit/withdraw requests — it comes from the route parameter.

public sealed record CreateWalletRequest
{
    public string? OwnerName { get; init; }
}

public sealed record DepositRequest
{
    public required decimal Amount { get; init; }
    public required string IdempotencyKey { get; init; }
}

public sealed record WithdrawRequest
{
    public required decimal Amount { get; init; }
    public required string IdempotencyKey { get; init; }
}

public sealed record TransferRequest
{
    public required Guid FromWalletId { get; init; }
    public required Guid ToWalletId { get; init; }
    public required decimal Amount { get; init; }
    public required string IdempotencyKey { get; init; }
}
