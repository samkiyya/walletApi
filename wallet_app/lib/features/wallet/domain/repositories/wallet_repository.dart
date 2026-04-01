library;

import 'package:wallet_app/core/error/failures.dart';
import 'package:wallet_app/features/wallet/domain/entities/wallet.dart';

/// Paginated result container matching `PagedResponse<T>` from the backend.
class PagedResult<T> {
  final List<T> items;
  final int totalCount;
  final int page;
  final int pageSize;
  bool get hasNextPage => page * pageSize < totalCount;
  bool get hasPreviousPage => page > 1;

  const PagedResult({
    required this.items,
    required this.totalCount,
    required this.page,
    required this.pageSize,
  });
}

/// Abstract wallet repository — implemented by [WalletRepositoryImpl].
abstract class WalletRepository {
  /// Creates a new wallet with an optional [ownerName].
  Future<(Failure?, Wallet?)> createWallet({String? ownerName});

  /// Fetches a single wallet by [id].
  Future<(Failure?, Wallet?)> getWallet(String id);

  /// Fetches a paginated list of all wallets.
  Future<(Failure?, PagedResult<Wallet>?)> getWallets({
    int page = 1,
    int pageSize = 20,
  });
}
