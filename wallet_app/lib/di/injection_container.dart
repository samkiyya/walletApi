library;

/// Root dependency injection container.
///
/// {@macro di_root}
///
/// {@macro di_architecture_flow}
///
/// {@macro di_registration_types}
///
/// {@macro di_modules}
///
/// {@macro di_notes}
///
/// ## Role
/// This is the **composition root** of the application where:
/// - Core services are registered
/// - Feature modules are initialized
/// - Dependency graph is assembled before app startup
///
/// No business logic should exist in this file.

import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

import 'package:wallet_app/core/network/api_client.dart';

// Modules
import 'package:wallet_app/di/wallet_module.dart';
import 'package:wallet_app/di/transaction_module.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // ── Core ───────────────────────────────────────
  sl.registerLazySingleton<Dio>(() => createDioClient());

  // ── Feature Modules ────────────────────────────
  initWalletModule(sl);
  initTransactionModule(sl);
}
