library;

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:wallet_app/features/wallet/domain/usecases/create_wallet.dart';
import 'package:wallet_app/features/wallet/domain/usecases/get_wallet.dart';
import 'package:wallet_app/features/wallet/domain/usecases/get_wallets.dart';
import 'package:wallet_app/features/wallet/presentation/bloc/wallet_event.dart';
import 'package:wallet_app/features/wallet/presentation/bloc/wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final GetWalletsUseCase _getWallets;
  final GetWalletUseCase _getWallet;
  final CreateWalletUseCase _createWallet;

  WalletBloc({
    required GetWalletsUseCase getWallets,
    required GetWalletUseCase getWallet,
    required CreateWalletUseCase createWallet,
  })  : _getWallets = getWallets,
        _getWallet = getWallet,
        _createWallet = createWallet,
        super(const WalletInitial()) {
    on<LoadWallets>(_onLoadWallets);
    on<LoadWalletDetail>(_onLoadWalletDetail);
    on<CreateWalletRequested>(_onCreateWallet);
    on<RefreshWallets>(_onRefreshWallets);
  }

  Future<void> _onLoadWallets(
    LoadWallets event,
    Emitter<WalletState> emit,
  ) async {
    emit(const WalletLoading());

    final (failure, result) = await _getWallets(
      page: event.page,
      pageSize: event.pageSize,
    );

    if (failure != null) {
      emit(WalletError(failure.message));
      return;
    }

    emit(WalletsLoaded(
      wallets: result!.items,
      totalCount: result.totalCount,
      page: result.page,
      pageSize: result.pageSize,
      hasNextPage: result.hasNextPage,
    ));
  }

  Future<void> _onLoadWalletDetail(
    LoadWalletDetail event,
    Emitter<WalletState> emit,
  ) async {
    emit(const WalletLoading());

    final (failure, wallet) = await _getWallet(event.walletId);

    if (failure != null) {
      emit(WalletError(failure.message));
      return;
    }

    emit(WalletDetailLoaded(wallet!));
  }

  Future<void> _onCreateWallet(
    CreateWalletRequested event,
    Emitter<WalletState> emit,
  ) async {
    emit(const WalletLoading());

    final (failure, wallet) = await _createWallet(ownerName: event.ownerName);

    if (failure != null) {
      emit(WalletError(failure.message));
      return;
    }

    emit(WalletCreated(wallet!));
  }

  Future<void> _onRefreshWallets(
    RefreshWallets event,
    Emitter<WalletState> emit,
  ) async {
    final (failure, result) = await _getWallets();

    if (failure != null) {
      emit(WalletError(failure.message));
      return;
    }

    emit(WalletsLoaded(
      wallets: result!.items,
      totalCount: result.totalCount,
      page: result.page,
      pageSize: result.pageSize,
      hasNextPage: result.hasNextPage,
    ));
  }
}
