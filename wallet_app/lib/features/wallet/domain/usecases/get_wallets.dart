library;

import 'package:wallet_app/core/error/failures.dart';
import 'package:wallet_app/features/wallet/domain/entities/wallet.dart';
import 'package:wallet_app/features/wallet/domain/repositories/wallet_repository.dart';

class GetWalletsUseCase {
  final WalletRepository _repository;

  const GetWalletsUseCase(this._repository);

  /// Fetches wallets with pagination.
  Future<(Failure?, PagedResult<Wallet>?)> call({
    int page = 1,
    int pageSize = 20,
  }) {
    return _repository.getWallets(page: page, pageSize: pageSize);
  }
}
