library;

import 'package:get_it/get_it.dart';

import 'package:wallet_app/features/transaction/data/datasources/transaction_local_datasource.dart';
import 'package:wallet_app/features/transaction/data/datasources/transaction_remote_datasource.dart';
import 'package:wallet_app/features/transaction/data/repositories/transaction_repository_impl.dart';
import 'package:wallet_app/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:wallet_app/features/transaction/domain/usecases/transaction_usecases.dart';
import 'package:wallet_app/features/transaction/presentation/bloc/transaction_bloc.dart';

//  cross-feature dependency
import 'package:wallet_app/features/wallet/data/datasources/wallet_local_datasource.dart';

void initTransactionModule(GetIt sl) {
  // ── Data Sources ───────────────────────────────
  sl.registerLazySingleton(() => TransactionRemoteDataSource(sl()));
  sl.registerLazySingleton(() => TransactionLocalDataSource());

  // ── Repository ────────────────────────────────
  sl.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(
      remote: sl(),
      localTx: sl(),
      localWallet: sl<WalletLocalDataSource>(), // 👈 dependency
    ),
  );

  // ── Use Cases ─────────────────────────────────
  sl.registerLazySingleton(() => DepositUseCase(sl()));
  sl.registerLazySingleton(() => WithdrawUseCase(sl()));
  sl.registerLazySingleton(() => TransferUseCase(sl()));
  sl.registerLazySingleton(() => GetTransactionsUseCase(sl()));

  // ── BLoC ──────────────────────────────────────
  sl.registerFactory(
    () => TransactionBloc(
      deposit: sl(),
      withdraw: sl(),
      transfer: sl(),
      getTransactions: sl(),
    ),
  );
}
