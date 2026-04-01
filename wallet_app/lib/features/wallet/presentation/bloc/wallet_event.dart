library;

import 'package:equatable/equatable.dart';

sealed class WalletEvent extends Equatable {
  const WalletEvent();

  @override
  List<Object?> get props => [];
}

/// Loads the paginated list of all wallets.
final class LoadWallets extends WalletEvent {
  final int page;
  final int pageSize;

  const LoadWallets({this.page = 1, this.pageSize = 20});

  @override
  List<Object?> get props => [page, pageSize];
}

/// Loads a single wallet by its ID.
final class LoadWalletDetail extends WalletEvent {
  final String walletId;

  const LoadWalletDetail(this.walletId);

  @override
  List<Object?> get props => [walletId];
}

/// Creates a new wallet with an optional owner name.
final class CreateWalletRequested extends WalletEvent {
  final String? ownerName;

  const CreateWalletRequested({this.ownerName});

  @override
  List<Object?> get props => [ownerName];
}

/// Refreshes wallet data (pull-to-refresh).
final class RefreshWallets extends WalletEvent {
  const RefreshWallets();
}
