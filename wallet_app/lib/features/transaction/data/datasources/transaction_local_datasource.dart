library;

import 'dart:convert';

import 'package:hive/hive.dart';

import 'package:wallet_app/features/transaction/data/models/transaction_model.dart';

class TransactionLocalDataSource {
  static const String _boxName = 'transactions_cache';

  Future<Box<String>> _openBox() async {
    if (Hive.isBoxOpen(_boxName)) {
      return Hive.box<String>(_boxName);
    }
    return Hive.openBox<String>(_boxName);
  }

  /// Caches transaction list for a specific wallet.
  Future<void> cacheTransactions(
    String walletId,
    List<TransactionModel> transactions,
  ) async {
    final box = await _openBox();
    final jsonList = transactions.map((t) => t.toJson()).toList();
    await box.put(walletId, jsonEncode(jsonList));
  }

  /// Retrieves cached transactions for a wallet, or null if not cached.
  Future<List<TransactionModel>?> getCachedTransactions(String walletId) async {
    final box = await _openBox();
    final raw = box.get(walletId);
    if (raw == null) return null;
    final jsonList = jsonDecode(raw) as List<dynamic>;
    return jsonList
        .map((e) => TransactionModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Clears cached transactions for a specific wallet (after mutations).
  Future<void> clearWalletCache(String walletId) async {
    final box = await _openBox();
    await box.delete(walletId);
  }

  /// Clears the entire transaction cache.
  Future<void> clearCache() async {
    final box = await _openBox();
    await box.clear();
  }
}
