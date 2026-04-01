library;

import 'package:wallet_app/core/error/failures.dart';
import 'package:wallet_app/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:wallet_app/features/transaction/domain/entities/transaction.dart';

/// Transfer result containing both the debit and credit legs.
class TransferResult {
  final Transaction debit;
  final Transaction credit;

  const TransferResult({required this.debit, required this.credit});
}

abstract class TransactionRepository {

  Future<(Failure?, Transaction?)> deposit({
    required String walletId,
    required double amount,
    required String idempotencyKey,
  });

  Future<(Failure?, Transaction?)> withdraw({
    required String walletId,
    required double amount,
    required String idempotencyKey,
  });

  Future<(Failure?, TransferResult?)> transfer({
    required String fromWalletId,
    required String toWalletId,
    required double amount,
    required String idempotencyKey,
  });

  /// Fetches paginated transaction history for [walletId].
  Future<(Failure?, PagedResult<Transaction>?)> getTransactions({
    required String walletId,
    int page = 1,
    int pageSize = 20,
  });
}
