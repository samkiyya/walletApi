/// {@template injection_container}
/// Dependency injection container using [GetIt].
///
/// Registers all dependencies following Clean Architecture's dependency rule:
/// ```
/// External (Dio) → DataSources → Repositories → Use Cases → BLoCs
/// ```
///
/// Registration types:
/// - `registerLazySingleton`: Created once, shared across the app
/// - `registerFactory`: New instance per request (BLoCs must be factories
///   because they hold mutable state and must be disposed independently)
/// {@endtemplate}
library;

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'package:wallet_app/core/network/api_client.dart';
import 'package:wallet_app/features/transaction/data/datasources/transaction_local_datasource.dart';
import 'package:wallet_app/features/transaction/data/datasources/transaction_remote_datasource.dart';
import 'package:wallet_app/features/transaction/data/repositories/transaction_repository_impl.dart';
import 'package:wallet_app/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:wallet_app/features/transaction/domain/usecases/transaction_usecases.dart';
import 'package:wallet_app/features/transaction/presentation/bloc/transaction_bloc.dart';
import 'package:wallet_app/features/wallet/data/datasources/wallet_local_datasource.dart';
import 'package:wallet_app/features/wallet/data/datasources/wallet_remote_datasource.dart';
import 'package:wallet_app/features/wallet/data/repositories/wallet_repository_impl.dart';
import 'package:wallet_app/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:wallet_app/features/wallet/domain/usecases/create_wallet.dart';
import 'package:wallet_app/features/wallet/domain/usecases/get_wallet.dart';
import 'package:wallet_app/features/wallet/domain/usecases/get_wallets.dart';
import 'package:wallet_app/features/wallet/presentation/bloc/wallet_bloc.dart';

/// Global service locator instance.
final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // ── External ──────────────────────────────────────────────────────
  sl.registerLazySingleton<Dio>(() => createDioClient());

  // ── Data Sources ──────────────────────────────────────────────────
  sl.registerLazySingleton(() => WalletRemoteDataSource(sl<Dio>()));
  sl.registerLazySingleton(() => WalletLocalDataSource());
  sl.registerLazySingleton(() => TransactionRemoteDataSource(sl<Dio>()));
  sl.registerLazySingleton(() => TransactionLocalDataSource());

  // ── Repositories ──────────────────────────────────────────────────
  sl.registerLazySingleton<WalletRepository>(
    () => WalletRepositoryImpl(
      remote: sl<WalletRemoteDataSource>(),
      local: sl<WalletLocalDataSource>(),
    ),
  );

  sl.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(
      remote: sl<TransactionRemoteDataSource>(),
      localTx: sl<TransactionLocalDataSource>(),
      localWallet: sl<WalletLocalDataSource>(),
    ),
  );

  // ── Use Cases ─────────────────────────────────────────────────────
  sl.registerLazySingleton(() => CreateWalletUseCase(sl<WalletRepository>()));
  sl.registerLazySingleton(() => GetWalletUseCase(sl<WalletRepository>()));
  sl.registerLazySingleton(() => GetWalletsUseCase(sl<WalletRepository>()));
  sl.registerLazySingleton(() => DepositUseCase(sl<TransactionRepository>()));
  sl.registerLazySingleton(() => WithdrawUseCase(sl<TransactionRepository>()));
  sl.registerLazySingleton(() => TransferUseCase(sl<TransactionRepository>()));
  sl.registerLazySingleton(
    () => GetTransactionsUseCase(sl<TransactionRepository>()),
  );

  // ── BLoCs (Factories — new instance per widget lifecycle) ─────────
  sl.registerFactory(
    () => WalletBloc(
      getWallets: sl<GetWalletsUseCase>(),
      getWallet: sl<GetWalletUseCase>(),
      createWallet: sl<CreateWalletUseCase>(),
    ),
  );

  sl.registerFactory(
    () => TransactionBloc(
      deposit: sl<DepositUseCase>(),
      withdraw: sl<WithdrawUseCase>(),
      transfer: sl<TransferUseCase>(),
      getTransactions: sl<GetTransactionsUseCase>(),
    ),
  );
}
