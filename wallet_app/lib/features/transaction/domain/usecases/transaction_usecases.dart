library;

import 'package:wallet_app/core/error/failures.dart';
import 'package:wallet_app/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:wallet_app/features/transaction/domain/entities/transaction.dart';
import 'package:wallet_app/features/transaction/domain/repositories/transaction_repository.dart';

// ── Deposit ──────
class DepositUseCase {
  final TransactionRepository _repository;
  const DepositUseCase(this._repository);

  Future<(Failure?, Transaction?)> call({
    required String walletId,
    required double amount,
    required String idempotencyKey,
  }) {
    return _repository.deposit(
      walletId: walletId,
      amount: amount,
      idempotencyKey: idempotencyKey,
    );
  }
}

// ── Withdraw ──────
class WithdrawUseCase {
  final TransactionRepository _repository;
  const WithdrawUseCase(this._repository);

  Future<(Failure?, Transaction?)> call({
    required String walletId,
    required double amount,
    required String idempotencyKey,
  }) {
    return _repository.withdraw(
      walletId: walletId,
      amount: amount,
      idempotencyKey: idempotencyKey,
    );
  }
}

// ── Transfer ────────

class TransferUseCase {
  final TransactionRepository _repository;
  const TransferUseCase(this._repository);

  Future<(Failure?, TransferResult?)> call({
    required String fromWalletId,
    required String toWalletId,
    required double amount,
    required String idempotencyKey,
  }) {
    return _repository.transfer(
      fromWalletId: fromWalletId,
      toWalletId: toWalletId,
      amount: amount,
      idempotencyKey: idempotencyKey,
    );
  }
}

// ── Get Transactions ──────
class GetTransactionsUseCase {
  final TransactionRepository _repository;
  const GetTransactionsUseCase(this._repository);

  Future<(Failure?, PagedResult<Transaction>?)> call({
    required String walletId,
    int page = 1,
    int pageSize = 20,
  }) {
    return _repository.getTransactions(
      walletId: walletId,
      page: page,
      pageSize: pageSize,
    );
  }
}
