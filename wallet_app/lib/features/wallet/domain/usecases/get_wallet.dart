library;

import 'package:wallet_app/core/error/failures.dart';
import 'package:wallet_app/features/wallet/domain/entities/wallet.dart';
import 'package:wallet_app/features/wallet/domain/repositories/wallet_repository.dart';

class GetWalletUseCase {
  final WalletRepository _repository;

  const GetWalletUseCase(this._repository);

  /// Fetches the wallet identified by [id].
  Future<(Failure?, Wallet?)> call(String id) {
    return _repository.getWallet(id);
  }
}
