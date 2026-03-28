using FluentValidation;
using Microsoft.AspNetCore.Mvc;
using WalletApi.Application.Commands;
using WalletApi.Application.Queries;
using WalletApi.Common;
using WalletApi.DTOs;

namespace WalletApi.Controllers;

/// <summary>
/// Wallet operations API — v1.
/// Route structure designed for versioning readiness (api/v1/wallets).
/// </summary>
[ApiController]
[Route("api/v1/wallets")]
[Produces("application/json")]
public sealed class WalletsController : ControllerBase
{
    // Command handlers (write side)
    private readonly CreateWalletHandler _createWallet;
    private readonly DepositHandler _deposit;
    private readonly WithdrawHandler _withdraw;
    private readonly TransferHandler _transfer;

    // Query handlers (read side)
    private readonly GetWalletHandler _getWallet;
    private readonly GetTransactionsHandler _getTransactions;

    // Validators
    private readonly IValidator<DepositRequest> _depositValidator;
    private readonly IValidator<WithdrawRequest> _withdrawValidator;
    private readonly IValidator<TransferRequest> _transferValidator;

    public WalletsController(
        CreateWalletHandler createWallet,
        DepositHandler deposit,
        WithdrawHandler withdraw,
        TransferHandler transfer,
        GetWalletHandler getWallet,
        GetTransactionsHandler getTransactions,
        IValidator<DepositRequest> depositValidator,
        IValidator<WithdrawRequest> withdrawValidator,
        IValidator<TransferRequest> transferValidator)
    {
        _createWallet = createWallet;
        _deposit = deposit;
        _withdraw = withdraw;
        _transfer = transfer;
        _getWallet = getWallet;
        _getTransactions = getTransactions;
        _depositValidator = depositValidator;
        _withdrawValidator = withdrawValidator;
        _transferValidator = transferValidator;
    }

    private string? TraceId => HttpContext.Items["CorrelationId"]?.ToString();

    // ── Commands ──────────────────────────────────────────────────────

    [HttpPost]
    [ProducesResponseType(typeof(ApiEnvelope<WalletResponse>), StatusCodes.Status201Created)]
    public async Task<IActionResult> Create(
        [FromBody] CreateWalletRequest request,
        CancellationToken ct)
    {
        var result = await _createWallet.HandleAsync(
            new CreateWalletCommand(request.OwnerName), ct);

        return StatusCode(StatusCodes.Status201Created,
            ApiEnvelope<WalletResponse>.Ok(result, TraceId));
    }

    [HttpPost("{id:guid}/deposit")]
    [ProducesResponseType(typeof(ApiEnvelope<TransactionResponse>), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(ApiEnvelope<object>), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(ApiEnvelope<object>), StatusCodes.Status404NotFound)]
    [ProducesResponseType(typeof(ApiEnvelope<object>), StatusCodes.Status409Conflict)]
    public async Task<IActionResult> Deposit(
        Guid id,
        [FromBody] DepositRequest request,
        CancellationToken ct)
    {
        var validation = await _depositValidator.ValidateAsync(request, ct);
        if (!validation.IsValid)
            return BadRequest(ApiEnvelope<object>.Fail(
                validation.Errors.Select(e => e.ErrorMessage).ToList(), TraceId));

        var result = await _deposit.HandleAsync(
            new DepositCommand(id, request.Amount, request.IdempotencyKey), ct);

        return Ok(ApiEnvelope<TransactionResponse>.Ok(result, TraceId));
    }

    [HttpPost("{id:guid}/withdraw")]
    [ProducesResponseType(typeof(ApiEnvelope<TransactionResponse>), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(ApiEnvelope<object>), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(ApiEnvelope<object>), StatusCodes.Status404NotFound)]
    [ProducesResponseType(typeof(ApiEnvelope<object>), StatusCodes.Status422UnprocessableEntity)]
    public async Task<IActionResult> Withdraw(
        Guid id,
        [FromBody] WithdrawRequest request,
        CancellationToken ct)
    {
        var validation = await _withdrawValidator.ValidateAsync(request, ct);
        if (!validation.IsValid)
            return BadRequest(ApiEnvelope<object>.Fail(
                validation.Errors.Select(e => e.ErrorMessage).ToList(), TraceId));

        var result = await _withdraw.HandleAsync(
            new WithdrawCommand(id, request.Amount, request.IdempotencyKey), ct);

        return Ok(ApiEnvelope<TransactionResponse>.Ok(result, TraceId));
    }

    [HttpPost("transfers")]
    [ProducesResponseType(typeof(ApiEnvelope<TransferResponse>), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(ApiEnvelope<object>), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(ApiEnvelope<object>), StatusCodes.Status404NotFound)]
    [ProducesResponseType(typeof(ApiEnvelope<object>), StatusCodes.Status422UnprocessableEntity)]
    public async Task<IActionResult> Transfer(
        [FromBody] TransferRequest request,
        CancellationToken ct)
    {
        var validation = await _transferValidator.ValidateAsync(request, ct);
        if (!validation.IsValid)
            return BadRequest(ApiEnvelope<object>.Fail(
                validation.Errors.Select(e => e.ErrorMessage).ToList(), TraceId));

        var result = await _transfer.HandleAsync(
            new TransferCommand(request.FromWalletId, request.ToWalletId,
                request.Amount, request.IdempotencyKey), ct);

        return Ok(ApiEnvelope<TransferResponse>.Ok(result, TraceId));
    }

    // ── Queries ───────────────────────────────────────────────────────

    [HttpGet("{id:guid}")]
    [ProducesResponseType(typeof(ApiEnvelope<WalletResponse>), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(ApiEnvelope<object>), StatusCodes.Status404NotFound)]
    public async Task<IActionResult> Get(Guid id, CancellationToken ct)
    {
        var result = await _getWallet.HandleAsync(new GetWalletQuery(id), ct);
        return Ok(ApiEnvelope<WalletResponse>.Ok(result, TraceId));
    }

    [HttpGet("{id:guid}/transactions")]
    [ProducesResponseType(typeof(ApiEnvelope<PagedResponse<TransactionResponse>>), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(ApiEnvelope<object>), StatusCodes.Status404NotFound)]
    public async Task<IActionResult> GetTransactions(
        Guid id,
        [FromQuery] int page = 1,
        [FromQuery] int pageSize = 20,
        CancellationToken ct = default)
    {
        // Guard: clamp pagination params to reasonable bounds
        page = Math.Max(1, page);
        pageSize = Math.Clamp(pageSize, 1, 100);

        var result = await _getTransactions.HandleAsync(
            new GetTransactionsQuery(id, page, pageSize), ct);

        return Ok(ApiEnvelope<PagedResponse<TransactionResponse>>.Ok(result, TraceId));
    }
}
