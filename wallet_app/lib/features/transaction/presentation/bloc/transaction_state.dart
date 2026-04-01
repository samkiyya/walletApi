library;

import 'package:equatable/equatable.dart';

import 'package:wallet_app/features/transaction/domain/entities/transaction.dart';

sealed class TransactionState extends Equatable {
  const TransactionState();

  @override
  List<Object?> get props => [];
}

final class TransactionInitial extends TransactionState {
  const TransactionInitial();
}

final class TransactionLoading extends TransactionState {
  const TransactionLoading();
}

/// Transaction list successfully loaded.
final class TransactionsLoaded extends TransactionState {
  final List<Transaction> transactions;
  final int totalCount;
  final int page;
  final int pageSize;
  final bool hasNextPage;

  const TransactionsLoaded({
    required this.transactions,
    required this.totalCount,
    required this.page,
    required this.pageSize,
    required this.hasNextPage,
  });

  @override
  List<Object?> get props => [
    transactions,
    totalCount,
    page,
    pageSize,
    hasNextPage,
  ];
}

/// A financial operation (deposit/withdraw/transfer) completed successfully.
final class TransactionSuccess extends TransactionState {
  final String message;

  const TransactionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

/// A financial operation failed.
final class TransactionError extends TransactionState {
  final String message;

  const TransactionError(this.message);

  @override
  List<Object?> get props => [message];
}
