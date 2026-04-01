library;

import 'package:equatable/equatable.dart';

class Wallet extends Equatable {
  /// Unique wallet identifier (UUID from backend).
  final String id;

  /// Optional display name of the wallet owner.
  final String? ownerName;

  /// Current wallet balance in the base currency.
  final double balance;

  /// UTC timestamp when the wallet was created.
  final DateTime createdAtUtc;

  const Wallet({
    required this.id,
    this.ownerName,
    required this.balance,
    required this.createdAtUtc,
  });

  @override
  List<Object?> get props => [id, ownerName, balance, createdAtUtc];
}
