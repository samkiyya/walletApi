library;

import 'package:wallet_app/features/transaction/domain/entities/transaction.dart';
import 'package:wallet_app/features/transaction/domain/entities/transaction_type.dart';

class TransactionModel extends Transaction {
  const TransactionModel({
    required super.id,
    required super.walletId,
    required super.type,
    required super.amount,
    required super.balanceAfter,
    super.description,
    super.idempotencyKey,
    super.referenceTransactionId,
    required super.createdAtUtc,
  });

  /// Deserializes a JSON map into a [TransactionModel].
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      walletId: json['walletId'] as String,
      type: TransactionType.fromString(json['type'] as String),
      amount: (json['amount'] as num).toDouble(),
      balanceAfter: (json['balanceAfter'] as num).toDouble(),
      description: json['description'] as String?,
      idempotencyKey: json['idempotencyKey'] as String?,
      referenceTransactionId: json['referenceTransactionId'] as String?,
      createdAtUtc: DateTime.parse(json['createdAtUtc'] as String),
    );
  }

  /// Serializes to a JSON map (for Hive cache storage).
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'walletId': walletId,
      'type': type.value,
      'amount': amount,
      'balanceAfter': balanceAfter,
      'description': description,
      'idempotencyKey': idempotencyKey,
      'referenceTransactionId': referenceTransactionId,
      'createdAtUtc': createdAtUtc.toIso8601String(),
    };
  }
}

class TransferResponseModel {
  final TransactionModel debit;
  final TransactionModel credit;

  const TransferResponseModel({
    required this.debit,
    required this.credit,
  });

  factory TransferResponseModel.fromJson(Map<String, dynamic> json) {
    return TransferResponseModel(
      debit: TransactionModel.fromJson(json['debit'] as Map<String, dynamic>),
      credit:
          TransactionModel.fromJson(json['credit'] as Map<String, dynamic>),
    );
  }
}
