
library;

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:wallet_app/core/utils/app_logger.dart';
import 'package:wallet_app/features/wallet/domain/usecases/create_wallet.dart';
import 'package:wallet_app/features/wallet/domain/usecases/get_wallet.dart';
import 'package:wallet_app/features/wallet/domain/usecases/get_wallets.dart';
import 'package:wallet_app/features/wallet/presentation/bloc/wallet_event.dart';
import 'package:wallet_app/features/wallet/presentation/bloc/wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final GetWalletsUseCase _getWallets;
  final GetWalletUseCase _getWallet;
  final CreateWalletUseCase _createWallet;

  static const _tag = 'WalletBloc';

  WalletBloc({
    required GetWalletsUseCase getWallets,
    required GetWalletUseCase getWallet,
    required CreateWalletUseCase createWallet,
  }) : _getWallets = getWallets,
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
    AppLogger.info('Loading wallets (page=${event.page})', tag: _tag);
    emit(const WalletLoading());

    final (failure, result) = await _getWallets(
      page: event.page,
      pageSize: event.pageSize,
    );

    if (failure != null) {
      AppLogger.error(
        'Failed to load wallets',
        tag: _tag,
        error: failure.message,
      );
      emit(WalletError(failure.message));
      return;
    }

    AppLogger.info(
      'Loaded ${result!.items.length} wallets (total=${result.totalCount})',
      tag: _tag,
    );
    emit(
      WalletsLoaded(
        wallets: result.items,
        totalCount: result.totalCount,
        page: result.page,
        pageSize: result.pageSize,
        hasNextPage: result.hasNextPage,
      ),
    );
  }

  Future<void> _onLoadWalletDetail(
    LoadWalletDetail event,
    Emitter<WalletState> emit,
  ) async {
    AppLogger.info('Loading wallet detail: ${event.walletId}', tag: _tag);
    emit(const WalletLoading());

    final (failure, wallet) = await _getWallet(event.walletId);

    if (failure != null) {
      AppLogger.error(
        'Failed to load wallet ${event.walletId}',
        tag: _tag,
        error: failure.message,
      );
      emit(WalletError(failure.message));
      return;
    }

    AppLogger.info('Wallet detail loaded: ${wallet!.id}', tag: _tag);
    emit(WalletDetailLoaded(wallet));
  }

  Future<void> _onCreateWallet(
    CreateWalletRequested event,
    Emitter<WalletState> emit,
  ) async {
    AppLogger.info(
      'Creating wallet for owner: "${event.ownerName}"',
      tag: _tag,
    );
    emit(const WalletLoading());

    final (failure, wallet) = await _createWallet(ownerName: event.ownerName);

    if (failure != null) {
      AppLogger.error(
        'Wallet creation failed',
        tag: _tag,
        error: failure.message,
      );
      emit(WalletError(failure.message));
      return;
    }

    AppLogger.info('Wallet created: ${wallet!.id}', tag: _tag);
    emit(WalletCreated(wallet));
  }

  Future<void> _onRefreshWallets(
    RefreshWallets event,
    Emitter<WalletState> emit,
  ) async {
    AppLogger.debug('Silent refresh of wallet list', tag: _tag);

    final (failure, result) = await _getWallets();

    if (failure != null) {
      AppLogger.warning(
        'Silent refresh failed',
        tag: _tag,
        error: failure.message,
      );
      emit(WalletError(failure.message));
      return;
    }

    AppLogger.debug(
      'Refresh complete: ${result!.items.length} wallets',
      tag: _tag,
    );
    emit(
      WalletsLoaded(
        wallets: result.items,
        totalCount: result.totalCount,
        page: result.page,
        pageSize: result.pageSize,
        hasNextPage: result.hasNextPage,
      ),
    );
  }
}
