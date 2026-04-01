library;

import 'package:wallet_app/features/wallet/domain/entities/wallet.dart';

class WalletModel extends Wallet {
  const WalletModel({
    required super.id,
    super.ownerName,
    required super.balance,
    required super.createdAtUtc,
  });

  /// Deserializes a JSON map into a [WalletModel].
  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      id: json['id'] as String,
      ownerName: json['ownerName'] as String?,
      balance: (json['balance'] as num).toDouble(),
      createdAtUtc: DateTime.parse(json['createdAtUtc'] as String),
    );
  }

  /// Serializes to a JSON map (for Hive cache storage).
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ownerName': ownerName,
      'balance': balance,
      'createdAtUtc': createdAtUtc.toIso8601String(),
    };
  }

  /// Creates a [WalletModel] from a domain [Wallet] entity.
  factory WalletModel.fromEntity(Wallet wallet) {
    return WalletModel(
      id: wallet.id,
      ownerName: wallet.ownerName,
      balance: wallet.balance,
      createdAtUtc: wallet.createdAtUtc,
    );
  }
}
