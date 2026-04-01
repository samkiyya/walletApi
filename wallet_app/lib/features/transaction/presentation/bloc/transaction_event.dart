library;

import 'package:equatable/equatable.dart';

sealed class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object?> get props => [];
}

/// Loads paginated transaction history for a wallet.
final class LoadTransactions extends TransactionEvent {
  final String walletId;
  final int page;
  final int pageSize;

  const LoadTransactions({
    required this.walletId,
    this.page = 1,
    this.pageSize = 20,
  });

  @override
  List<Object?> get props => [walletId, page, pageSize];
}

/// Submits a deposit operation.
final class SubmitDeposit extends TransactionEvent {
  final String walletId;
  final double amount;

  const SubmitDeposit({required this.walletId, required this.amount});

  @override
  List<Object?> get props => [walletId, amount];
}

/// Submits a withdrawal operation.
final class SubmitWithdraw extends TransactionEvent {
  final String walletId;
  final double amount;

  const SubmitWithdraw({required this.walletId, required this.amount});

  @override
  List<Object?> get props => [walletId, amount];
}

/// Submits a transfer between two wallets.
final class SubmitTransfer extends TransactionEvent {
  final String fromWalletId;
  final String toWalletId;
  final double amount;

  const SubmitTransfer({
    required this.fromWalletId,
    required this.toWalletId,
    required this.amount,
  });

  @override
  List<Object?> get props => [fromWalletId, toWalletId, amount];
}
