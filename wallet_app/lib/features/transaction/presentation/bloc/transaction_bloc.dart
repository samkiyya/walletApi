library;

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:wallet_app/core/utils/idempotency.dart';
import 'package:wallet_app/features/transaction/domain/usecases/transaction_usecases.dart';
import 'package:wallet_app/features/transaction/presentation/bloc/transaction_event.dart';
import 'package:wallet_app/features/transaction/presentation/bloc/transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final DepositUseCase _deposit;
  final WithdrawUseCase _withdraw;
  final TransferUseCase _transfer;
  final GetTransactionsUseCase _getTransactions;

  TransactionBloc({
    required DepositUseCase deposit,
    required WithdrawUseCase withdraw,
    required TransferUseCase transfer,
    required GetTransactionsUseCase getTransactions,
  })  : _deposit = deposit,
        _withdraw = withdraw,
        _transfer = transfer,
        _getTransactions = getTransactions,
        super(const TransactionInitial()) {
    on<LoadTransactions>(_onLoadTransactions);
    on<SubmitDeposit>(_onSubmitDeposit);
    on<SubmitWithdraw>(_onSubmitWithdraw);
    on<SubmitTransfer>(_onSubmitTransfer);
  }

  Future<void> _onLoadTransactions(
    LoadTransactions event,
    Emitter<TransactionState> emit,
  ) async {
    emit(const TransactionLoading());

    final (failure, result) = await _getTransactions(
      walletId: event.walletId,
      page: event.page,
      pageSize: event.pageSize,
    );

    if (failure != null) {
      emit(TransactionError(failure.message));
      return;
    }

    emit(TransactionsLoaded(
      transactions: result!.items,
      totalCount: result.totalCount,
      page: result.page,
      pageSize: result.pageSize,
      hasNextPage: result.hasNextPage,
    ));
  }

  Future<void> _onSubmitDeposit(
    SubmitDeposit event,
    Emitter<TransactionState> emit,
  ) async {
    emit(const TransactionLoading());

    final (failure, _) = await _deposit(
      walletId: event.walletId,
      amount: event.amount,
      idempotencyKey: IdempotencyKeyGenerator.deposit(),
    );

    if (failure != null) {
      emit(TransactionError(failure.message));
      return;
    }

    emit(TransactionSuccess(
      'Successfully deposited \$${event.amount.toStringAsFixed(2)}',
    ));
  }

  Future<void> _onSubmitWithdraw(
    SubmitWithdraw event,
    Emitter<TransactionState> emit,
  ) async {
    emit(const TransactionLoading());

    final (failure, _) = await _withdraw(
      walletId: event.walletId,
      amount: event.amount,
      idempotencyKey: IdempotencyKeyGenerator.withdraw(),
    );

    if (failure != null) {
      emit(TransactionError(failure.message));
      return;
    }

    emit(TransactionSuccess(
      'Successfully withdrew \$${event.amount.toStringAsFixed(2)}',
    ));
  }

  Future<void> _onSubmitTransfer(
    SubmitTransfer event,
    Emitter<TransactionState> emit,
  ) async {
    emit(const TransactionLoading());

    final (failure, _) = await _transfer(
      fromWalletId: event.fromWalletId,
      toWalletId: event.toWalletId,
      amount: event.amount,
      idempotencyKey: IdempotencyKeyGenerator.transfer(),
    );

    if (failure != null) {
      emit(TransactionError(failure.message));
      return;
    }

    emit(TransactionSuccess(
      'Successfully transferred \$${event.amount.toStringAsFixed(2)}',
    ));
  }
}
