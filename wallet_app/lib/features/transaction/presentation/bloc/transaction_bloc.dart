/// {@template transaction_bloc}
/// BLoC for all financial transaction operations.
///
/// Events → Handlers:
/// - [LoadTransactions]  → paginated transaction history
/// - [SubmitDeposit]     → deposits funds with idempotency key
/// - [SubmitWithdraw]    → withdraws funds with idempotency key
/// - [SubmitTransfer]    → transfers between wallets with idempotency key
///
/// All operations are logged via [AppLogger] with the 'TransactionBloc' tag.
/// Financial amounts are always formatted to 2 decimal places in log messages.
/// {@endtemplate}
library;

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:wallet_app/core/utils/app_logger.dart';
import 'package:wallet_app/core/utils/idempotency.dart';
import 'package:wallet_app/features/transaction/domain/usecases/transaction_usecases.dart';
import 'package:wallet_app/features/transaction/presentation/bloc/transaction_event.dart';
import 'package:wallet_app/features/transaction/presentation/bloc/transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final DepositUseCase _deposit;
  final WithdrawUseCase _withdraw;
  final TransferUseCase _transfer;
  final GetTransactionsUseCase _getTransactions;

  static const _tag = 'TransactionBloc';

  TransactionBloc({
    required DepositUseCase deposit,
    required WithdrawUseCase withdraw,
    required TransferUseCase transfer,
    required GetTransactionsUseCase getTransactions,
  }) : _deposit = deposit,
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
    AppLogger.info(
      'Loading transactions for wallet=${event.walletId} page=${event.page}',
      tag: _tag,
    );
    emit(const TransactionLoading());

    final (failure, result) = await _getTransactions(
      walletId: event.walletId,
      page: event.page,
      pageSize: event.pageSize,
    );

    if (failure != null) {
      AppLogger.error(
        'Failed to load transactions for wallet=${event.walletId}',
        tag: _tag,
        error: failure.message,
      );
      emit(TransactionError(failure.message));
      return;
    }

    AppLogger.info(
      'Loaded ${result!.items.length} transactions '
      '(total=${result.totalCount}, hasNext=${result.hasNextPage})',
      tag: _tag,
    );
    emit(
      TransactionsLoaded(
        transactions: result.items,
        totalCount: result.totalCount,
        page: result.page,
        pageSize: result.pageSize,
        hasNextPage: result.hasNextPage,
      ),
    );
  }

  Future<void> _onSubmitDeposit(
    SubmitDeposit event,
    Emitter<TransactionState> emit,
  ) async {
    final amount = event.amount.toStringAsFixed(2);
    AppLogger.info(
      'Submitting deposit: wallet=${event.walletId} amount=ETB $amount',
      tag: _tag,
    );
    emit(const TransactionLoading());

    final (failure, _) = await _deposit(
      walletId: event.walletId,
      amount: event.amount,
      idempotencyKey: IdempotencyKeyGenerator.deposit(),
    );

    if (failure != null) {
      AppLogger.error(
        'Deposit failed: wallet=${event.walletId} amount=ETB $amount',
        tag: _tag,
        error: failure.message,
      );
      emit(TransactionError(failure.message));
      return;
    }

    AppLogger.info(
      'Deposit successful: wallet=${event.walletId} amount=ETB $amount',
      tag: _tag,
    );
    emit(TransactionSuccess('Successfully deposited \$$amount'));
  }

  Future<void> _onSubmitWithdraw(
    SubmitWithdraw event,
    Emitter<TransactionState> emit,
  ) async {
    final amount = event.amount.toStringAsFixed(2);
    AppLogger.info(
      'Submitting withdrawal: wallet=${event.walletId} amount=ETB $amount',
      tag: _tag,
    );
    emit(const TransactionLoading());

    final (failure, _) = await _withdraw(
      walletId: event.walletId,
      amount: event.amount,
      idempotencyKey: IdempotencyKeyGenerator.withdraw(),
    );

    if (failure != null) {
      AppLogger.error(
        'Withdrawal failed: wallet=${event.walletId} amount=ETB $amount',
        tag: _tag,
        error: failure.message,
      );
      emit(TransactionError(failure.message));
      return;
    }

    AppLogger.info(
      'Withdrawal successful: wallet=${event.walletId} amount=ETB $amount',
      tag: _tag,
    );
    emit(TransactionSuccess('Successfully withdrew \$$amount'));
  }

  Future<void> _onSubmitTransfer(
    SubmitTransfer event,
    Emitter<TransactionState> emit,
  ) async {
    final amount = event.amount.toStringAsFixed(2);
    AppLogger.info(
      'Submitting transfer: from=${event.fromWalletId} → to=${event.toWalletId} '
      'amount=ETB $amount',
      tag: _tag,
    );
    emit(const TransactionLoading());

    final (failure, _) = await _transfer(
      fromWalletId: event.fromWalletId,
      toWalletId: event.toWalletId,
      amount: event.amount,
      idempotencyKey: IdempotencyKeyGenerator.transfer(),
    );

    if (failure != null) {
      AppLogger.error(
        'Transfer failed: from=${event.fromWalletId} → to=${event.toWalletId}',
        tag: _tag,
        error: failure.message,
      );
      emit(TransactionError(failure.message));
      return;
    }

    AppLogger.info(
      'Transfer successful: from=${event.fromWalletId} → to=${event.toWalletId} '
      'amount=ETB $amount',
      tag: _tag,
    );
    emit(TransactionSuccess('Successfully transferred \$$amount'));
  }
}
