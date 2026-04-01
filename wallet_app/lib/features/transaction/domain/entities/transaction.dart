library;

import 'package:equatable/equatable.dart';

import 'package:wallet_app/features/transaction/domain/entities/transaction_type.dart';

class Transaction extends Equatable {
  final String id;
  final String walletId;
  final TransactionType type;
  final double amount;
  final double balanceAfter;
  final String? description;
  final String? idempotencyKey;
  final String? referenceTransactionId;
  final DateTime createdAtUtc;

  const Transaction({
    required this.id,
    required this.walletId,
    required this.type,
    required this.amount,
    required this.balanceAfter,
    this.description,
    this.idempotencyKey,
    this.referenceTransactionId,
    required this.createdAtUtc,
  });

  /// Whether this transaction increases the wallet balance.
  bool get isCredit =>
      type == TransactionType.deposit || type == TransactionType.transferIn;

  /// Whether this transaction decreases the wallet balance.
  bool get isDebit =>
      type == TransactionType.withdrawal || type == TransactionType.transferOut;

  @override
  List<Object?> get props => [
        id,
        walletId,
        type,
        amount,
        balanceAfter,
        description,
        idempotencyKey,
        referenceTransactionId,
        createdAtUtc,
      ];
}
