/// {@template wallet_state}
/// States emitted by [WalletBloc] in response to [WalletEvent]s.
///
/// Each state represents a distinct UI condition:
/// - [WalletInitial]: App just started, no data yet
/// - [WalletLoading]: Fetching data from network/cache
/// - [WalletsLoaded]: Wallet list successfully loaded
/// - [WalletDetailLoaded]: Single wallet detail loaded
/// - [WalletCreated]: New wallet successfully created
/// - [WalletError]: An operation failed
/// {@endtemplate}
library;

import 'package:equatable/equatable.dart';

import 'package:wallet_app/features/wallet/domain/entities/wallet.dart';

sealed class WalletState extends Equatable {
  const WalletState();

  @override
  List<Object?> get props => [];
}

/// Initial state — no operations performed yet.
final class WalletInitial extends WalletState {
  const WalletInitial();
}

/// Loading indicator state.
final class WalletLoading extends WalletState {
  const WalletLoading();
}

/// Wallet list successfully loaded.
final class WalletsLoaded extends WalletState {
  final List<Wallet> wallets;
  final int totalCount;
  final int page;
  final int pageSize;
  final bool hasNextPage;

  const WalletsLoaded({
    required this.wallets,
    required this.totalCount,
    required this.page,
    required this.pageSize,
    required this.hasNextPage,
  });

  @override
  List<Object?> get props => [wallets, totalCount, page, pageSize, hasNextPage];
}

/// Single wallet detail loaded (with fresh balance).
final class WalletDetailLoaded extends WalletState {
  final Wallet wallet;

  const WalletDetailLoaded(this.wallet);

  @override
  List<Object?> get props => [wallet];
}

/// A new wallet was successfully created.
final class WalletCreated extends WalletState {
  final Wallet wallet;

  const WalletCreated(this.wallet);

  @override
  List<Object?> get props => [wallet];
}

/// An error occurred during a wallet operation.
final class WalletError extends WalletState {
  final String message;

  const WalletError(this.message);

  @override
  List<Object?> get props => [message];
}
