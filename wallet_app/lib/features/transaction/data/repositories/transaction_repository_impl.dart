library;

import 'package:dio/dio.dart';

import 'package:wallet_app/core/error/api_exception.dart';
import 'package:wallet_app/core/error/failures.dart';
import 'package:wallet_app/features/wallet/data/datasources/wallet_local_datasource.dart';
import 'package:wallet_app/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:wallet_app/features/transaction/domain/entities/transaction.dart';
import 'package:wallet_app/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:wallet_app/features/transaction/data/datasources/transaction_local_datasource.dart';
import 'package:wallet_app/features/transaction/data/datasources/transaction_remote_datasource.dart';
import 'package:wallet_app/features/transaction/data/models/transaction_model.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDataSource _remote;
  final TransactionLocalDataSource _localTx;
  final WalletLocalDataSource _localWallet;

  const TransactionRepositoryImpl({
    required TransactionRemoteDataSource remote,
    required TransactionLocalDataSource localTx,
    required WalletLocalDataSource localWallet,
  })  : _remote = remote,
        _localTx = localTx,
        _localWallet = localWallet;

  @override
  Future<(Failure?, Transaction?)> deposit({
    required String walletId,
    required double amount,
    required String idempotencyKey,
  }) async {
    try {
      final result = await _remote.deposit(
        walletId: walletId,
        amount: amount,
        idempotencyKey: idempotencyKey,
      );
      // Invalidate caches — balance has changed
      await _invalidateCaches(walletId);
      return (null, result);
    } on DioException catch (e) {
      return (_mapDioException(e), null);
    } on ApiException catch (e) {
      return (_mapApiException(e), null);
    } catch (e) {
      return (ServerFailure(message: e.toString()), null);
    }
  }

  @override
  Future<(Failure?, Transaction?)> withdraw({
    required String walletId,
    required double amount,
    required String idempotencyKey,
  }) async {
    try {
      final result = await _remote.withdraw(
        walletId: walletId,
        amount: amount,
        idempotencyKey: idempotencyKey,
      );
      await _invalidateCaches(walletId);
      return (null, result);
    } on DioException catch (e) {
      return (_mapDioException(e), null);
    } on ApiException catch (e) {
      return (_mapApiException(e), null);
    } catch (e) {
      return (ServerFailure(message: e.toString()), null);
    }
  }

  @override
  Future<(Failure?, TransferResult?)> transfer({
    required String fromWalletId,
    required String toWalletId,
    required double amount,
    required String idempotencyKey,
  }) async {
    try {
      final result = await _remote.transfer(
        fromWalletId: fromWalletId,
        toWalletId: toWalletId,
        amount: amount,
        idempotencyKey: idempotencyKey,
      );
      // Invalidate caches for both wallets
      await _invalidateCaches(fromWalletId);
      await _invalidateCaches(toWalletId);
      return (
        null,
        TransferResult(debit: result.debit, credit: result.credit),
      );
    } on DioException catch (e) {
      return (_mapDioException(e), null);
    } on ApiException catch (e) {
      return (_mapApiException(e), null);
    } catch (e) {
      return (ServerFailure(message: e.toString()), null);
    }
  }

  @override
  Future<(Failure?, PagedResult<Transaction>?)> getTransactions({
    required String walletId,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final paged = await _remote.getTransactions(
        walletId: walletId,
        page: page,
        pageSize: pageSize,
      );
      // Cache first page of transactions for offline browsing
      if (page == 1) {
        await _localTx.cacheTransactions(walletId, paged.items.cast<TransactionModel>());
      }
      return (
        null,
        PagedResult<Transaction>(
          items: paged.items,
          totalCount: paged.totalCount,
          page: paged.page,
          pageSize: paged.pageSize,
        ),
      );
    } on DioException catch (e) {
      // ── Offline fallback (first page only) ────────────────────────
      if (_isNetworkError(e) && page == 1) {
        final cached = await _localTx.getCachedTransactions(walletId);
        if (cached != null && cached.isNotEmpty) {
          return (
            null,
            PagedResult<Transaction>(
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

  // ── Cache Invalidation ───────────────────────────────────────────

  Future<void> _invalidateCaches(String walletId) async {
    await _localTx.clearWalletCache(walletId);
    await _localWallet.clearCache();
  }

  // ── Exception Mapping ────────────────────────────────────────────

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
          errors.addAll(
            (data['errors'] as List).map((e) => e.toString()),
          );
        }
        traceId = data['traceId'] as String?;
      }

      final message = errors.isNotEmpty ? errors.first : e.message ?? '';

      return switch (response.statusCode) {
        404 => NotFoundFailure(message: message, errors: errors, traceId: traceId),
        400 => ValidationFailure(message: message, errors: errors, traceId: traceId),
        409 => ConflictFailure(message: message, errors: errors, traceId: traceId),
        422 => InsufficientFundsFailure(message: message, errors: errors, traceId: traceId),
        _ => ServerFailure(message: message, errors: errors, traceId: traceId),
      };
    }

    return ServerFailure(message: e.message ?? 'Unknown error');
  }

  Failure _mapApiException(ApiException e) {
    return switch (e.statusCode) {
      404 => NotFoundFailure(message: e.message, errors: e.errors, traceId: e.traceId),
      400 => ValidationFailure(message: e.message, errors: e.errors, traceId: e.traceId),
      409 => ConflictFailure(message: e.message, errors: e.errors, traceId: e.traceId),
      422 => InsufficientFundsFailure(message: e.message, errors: e.errors, traceId: e.traceId),
      _ => ServerFailure(message: e.message, errors: e.errors, traceId: e.traceId),
    };
  }

  bool _isNetworkError(DioException e) {
    return e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout;
  }
}
