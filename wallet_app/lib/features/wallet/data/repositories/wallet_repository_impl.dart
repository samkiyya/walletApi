library;

import 'package:dio/dio.dart';

import 'package:wallet_app/core/error/api_exception.dart';
import 'package:wallet_app/core/error/failures.dart';
import 'package:wallet_app/features/wallet/domain/entities/wallet.dart';
import 'package:wallet_app/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:wallet_app/features/wallet/data/datasources/wallet_local_datasource.dart';
import 'package:wallet_app/features/wallet/data/datasources/wallet_remote_datasource.dart';
import 'package:wallet_app/features/wallet/data/models/wallet_model.dart';

class WalletRepositoryImpl implements WalletRepository {
  final WalletRemoteDataSource _remote;
  final WalletLocalDataSource _local;

  const WalletRepositoryImpl({
    required WalletRemoteDataSource remote,
    required WalletLocalDataSource local,
  }) : _remote = remote,
       _local = local;

  @override
  Future<(Failure?, Wallet?)> createWallet({String? ownerName}) async {
    try {
      final wallet = await _remote.createWallet(ownerName: ownerName);
      // Cache the new wallet for offline access
      await _local.cacheWallet(wallet);
      // Invalidate the "all wallets" list cache since we added a new one
      await _local.clearCache();
      return (null, wallet);
    } on DioException catch (e) {
      return (_mapDioException(e), null);
    } on ApiException catch (e) {
      return (_mapApiException(e), null);
    } catch (e) {
      return (ServerFailure(message: e.toString()), null);
    }
  }

  @override
  Future<(Failure?, Wallet?)> getWallet(String id) async {
    try {
      final wallet = await _remote.getWallet(id);
      await _local.cacheWallet(wallet);
      return (null, wallet);
    } on DioException catch (e) {
      // ── Offline fallback ──────────────────────────────────────────
      if (_isNetworkError(e)) {
        final cached = await _local.getCachedWallet(id);
        if (cached != null) return (null, cached);
      }
      return (_mapDioException(e), null);
    } on ApiException catch (e) {
      return (_mapApiException(e), null);
    } catch (e) {
      return (ServerFailure(message: e.toString()), null);
    }
  }

  @override
  Future<(Failure?, PagedResult<Wallet>?)> getWallets({
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final paged = await _remote.getWallets(page: page, pageSize: pageSize);
      // Cache all fetched wallets
      await _local.cacheWallets(
        paged.items.map((w) => WalletModel.fromEntity(w)).toList(),
      );
      return (
        null,
        PagedResult<Wallet>(
          items: paged.items,
          totalCount: paged.totalCount,
          page: paged.page,
          pageSize: paged.pageSize,
        ),
      );
    } on DioException catch (e) {
      // ── Offline fallback ──────────────────────────────────────────
      if (_isNetworkError(e)) {
        final cached = await _local.getCachedWallets();
        if (cached != null && cached.isNotEmpty) {
          return (
            null,
            PagedResult<Wallet>(
              items: cached,
              totalCount: cached.length,
              page: 1,
              pageSize: cached.length,
            ),
          );
        }
      }
      return (_mapDioException(e), null);
    } on ApiException catch (e) {
      return (_mapApiException(e), null);
    } catch (e) {
      return (ServerFailure(message: e.toString()), null);
    }
  }

  // ── Exception Mapping ───────────────
  Failure _mapDioException(DioException e) {
    if (_isNetworkError(e)) {
      return const NetworkFailure();
    }

    final response = e.response;
    if (response != null) {
      final data = response.data;
      final errors = <String>[];
      String? traceId;

      if (data is Map<String, dynamic>) {
        if (data['errors'] is List) {
          errors.addAll((data['errors'] as List).map((e) => e.toString()));
        }
        traceId = data['traceId'] as String?;
      }

      final message = errors.isNotEmpty ? errors.first : e.message ?? '';

      return switch (response.statusCode) {
        404 => NotFoundFailure(
          message: message,
          errors: errors,
          traceId: traceId,
        ),
        400 => ValidationFailure(
          message: message,
          errors: errors,
          traceId: traceId,
        ),
        409 => ConflictFailure(
          message: message,
          errors: errors,
          traceId: traceId,
        ),
        422 => InsufficientFundsFailure(
          message: message,
          errors: errors,
          traceId: traceId,
        ),
        _ => ServerFailure(message: message, errors: errors, traceId: traceId),
      };
    }

    return ServerFailure(message: e.message ?? 'Unknown error');
  }

  /// Maps [ApiException] (from envelope parsing) to typed [Failure].
  Failure _mapApiException(ApiException e) {
    return switch (e.statusCode) {
      404 => NotFoundFailure(
        message: e.message,
        errors: e.errors,
        traceId: e.traceId,
      ),
      400 => ValidationFailure(
        message: e.message,
        errors: e.errors,
        traceId: e.traceId,
      ),
      409 => ConflictFailure(
        message: e.message,
        errors: e.errors,
        traceId: e.traceId,
      ),
      422 => InsufficientFundsFailure(
        message: e.message,
        errors: e.errors,
        traceId: e.traceId,
      ),
      _ => ServerFailure(
        message: e.message,
        errors: e.errors,
        traceId: e.traceId,
      ),
    };
  }

  bool _isNetworkError(DioException e) {
    return e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout;
  }
}
