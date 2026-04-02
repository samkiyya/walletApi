library;

import 'package:get_it/get_it.dart';

import 'package:wallet_app/features/wallet/data/datasources/wallet_local_datasource.dart';
import 'package:wallet_app/features/wallet/data/datasources/wallet_remote_datasource.dart';
import 'package:wallet_app/features/wallet/data/repositories/wallet_repository_impl.dart';
import 'package:wallet_app/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:wallet_app/features/wallet/domain/usecases/create_wallet.dart';
import 'package:wallet_app/features/wallet/domain/usecases/get_wallet.dart';
import 'package:wallet_app/features/wallet/domain/usecases/get_wallets.dart';
import 'package:wallet_app/features/wallet/presentation/bloc/wallet_bloc.dart';

void initWalletModule(GetIt sl) {
  // ── Data Sources ───────────────────────────────
  sl.registerLazySingleton(() => WalletRemoteDataSource(sl()));
  sl.registerLazySingleton(() => WalletLocalDataSource());

  // ── Repository ────────────────────────────────
  sl.registerLazySingleton<WalletRepository>(
    () => WalletRepositoryImpl(remote: sl(), local: sl()),
  );

  // ── Use Cases ─────────────────────────────────
  sl.registerLazySingleton(() => CreateWalletUseCase(sl()));
  sl.registerLazySingleton(() => GetWalletUseCase(sl()));
  sl.registerLazySingleton(() => GetWalletsUseCase(sl()));

  // ── BLoC ──────────────────────────────────────
  sl.registerFactory(
    () => WalletBloc(getWallets: sl(), getWallet: sl(), createWallet: sl()),
  );
}
