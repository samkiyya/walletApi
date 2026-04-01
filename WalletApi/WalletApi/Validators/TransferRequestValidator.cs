using FluentValidation;
using WalletApi.DTOs;

namespace WalletApi.Validators;

public sealed class TransferRequestValidator : AbstractValidator<TransferRequest>
{
    private const decimal MaxTransactionAmount = 1_000_000m;

    public TransferRequestValidator()
    {
        RuleFor(x => x.FromWalletId)
            .NotEmpty()
                .WithMessage("Source wallet ID is required.");

        RuleFor(x => x.ToWalletId)
            .NotEmpty()
                .WithMessage("Destination wallet ID is required.")
            .NotEqual(x => x.FromWalletId)
                .WithMessage("Cannot transfer to the same wallet.");

        RuleFor(x => x.Amount)
            .GreaterThan(0)
                .WithMessage("Amount must be greater than zero.")
            .LessThanOrEqualTo(MaxTransactionAmount)
                .WithMessage($"Amount cannot exceed {MaxTransactionAmount:N2}.")
            .Must(HaveMaxTwoDecimalPlaces)
                .WithMessage("Amount cannot have more than 2 decimal places.");

        RuleFor(x => x.IdempotencyKey)
            .NotEmpty()
                .WithMessage("IdempotencyKey is required for financial operations.")
            .MaximumLength(100);
    }

    private static bool HaveMaxTwoDecimalPlaces(decimal amount)
        => decimal.Round(amount, 2) == amount;
}
