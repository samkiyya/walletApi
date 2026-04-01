namespace WalletApi.Application.Abstractions;

//CQRS command handler contract
public interface ICommandHandler<in TCommand, TResult>
{
    Task<TResult> HandleAsync(TCommand command, CancellationToken cancellationToken = default);
}
