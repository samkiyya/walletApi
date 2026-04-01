library;

import 'package:wallet_app/core/error/failures.dart';
import 'package:wallet_app/features/wallet/domain/entities/wallet.dart';
import 'package:wallet_app/features/wallet/domain/repositories/wallet_repository.dart';

class CreateWalletUseCase {
  final WalletRepository _repository;

  const CreateWalletUseCase(this._repository);

  /// Executes the wallet creation.
  Future<(Failure?, Wallet?)> call({String? ownerName}) {
    return _repository.createWallet(ownerName: ownerName);
  }
}
