library;

import 'dart:convert';

import 'package:hive/hive.dart';

import 'package:wallet_app/features/wallet/data/models/wallet_model.dart';

class WalletLocalDataSource {
  static const String _boxName = 'wallets_cache';

  /// Opens (or reuses) the Hive box for wallet caching.
  Future<Box<String>> _openBox() async {
    if (Hive.isBoxOpen(_boxName)) {
      return Hive.box<String>(_boxName);
    }
    return Hive.openBox<String>(_boxName);
  }

  /// Caches a single wallet by its [wallet.id].
  Future<void> cacheWallet(WalletModel wallet) async {
    final box = await _openBox();
    await box.put(wallet.id, jsonEncode(wallet.toJson()));
  }

  /// Caches a list of wallets (overwrites the full cached list).
  Future<void> cacheWallets(List<WalletModel> wallets) async {
    final box = await _openBox();
    // Store as a special key for the "all wallets" list
    final jsonList = wallets.map((w) => w.toJson()).toList();
    await box.put('__all_wallets__', jsonEncode(jsonList));
    // Also cache each wallet individually for detail lookups
    for (final wallet in wallets) {
      await box.put(wallet.id, jsonEncode(wallet.toJson()));
    }
  }

  /// Retrieves a cached wallet by [id], or null if not cached.
  Future<WalletModel?> getCachedWallet(String id) async {
    final box = await _openBox();
    final raw = box.get(id);
    if (raw == null) return null;
    return WalletModel.fromJson(
      jsonDecode(raw) as Map<String, dynamic>,
    );
  }

  /// Retrieves the cached list of all wallets, or null if not cached.
  Future<List<WalletModel>?> getCachedWallets() async {
    final box = await _openBox();
    final raw = box.get('__all_wallets__');
    if (raw == null) return null;
    final jsonList = jsonDecode(raw) as List<dynamic>;
    return jsonList
        .map((e) => WalletModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Clears the entire wallet cache (used after mutations).
  Future<void> clearCache() async {
    final box = await _openBox();
    await box.clear();
  }
}
