library;

import 'package:dio/dio.dart';

import 'package:wallet_app/core/constants/api_constants.dart';
import 'package:wallet_app/core/error/api_exception.dart';
import 'package:wallet_app/core/network/api_envelope.dart';
import 'package:wallet_app/features/wallet/data/models/paged_response_model.dart';
import 'package:wallet_app/features/transaction/data/models/transaction_model.dart';

class TransactionRemoteDataSource {
  final Dio _dio;

  const TransactionRemoteDataSource(this._dio);

  /// POST /api/v1/wallets/{id}/deposit
  Future<TransactionModel> deposit({
    required String walletId,
    required double amount,
    required String idempotencyKey,
  }) async {
    final response = await _dio.post(
      ApiConstants.deposit(walletId),
      data: {'amount': amount, 'idempotencyKey': idempotencyKey},
    );
    return _parseTransactionResponse(response);
  }

  /// POST /api/v1/wallets/{id}/withdraw
  Future<TransactionModel> withdraw({
    required String walletId,
    required double amount,
    required String idempotencyKey,
  }) async {
    final response = await _dio.post(
      ApiConstants.withdraw(walletId),
      data: {'amount': amount, 'idempotencyKey': idempotencyKey},
    );
    return _parseTransactionResponse(response);
  }

  /// POST /api/v1/wallets/transfers
  Future<TransferResponseModel> transfer({
    required String fromWalletId,
    required String toWalletId,
    required double amount,
    required String idempotencyKey,
  }) async {
    final response = await _dio.post(
      ApiConstants.transfers,
      data: {
        'fromWalletId': fromWalletId,
        'toWalletId': toWalletId,
        'amount': amount,
        'idempotencyKey': idempotencyKey,
      },
    );

    final envelope = ApiEnvelope.fromJson(
      response.data as Map<String, dynamic>,
      (data) =>
          TransferResponseModel.fromJson(data as Map<String, dynamic>),
    );

    if (!envelope.success || envelope.data == null) {
      throw ApiException(
        statusCode: response.statusCode ?? 500,
        message: envelope.errors?.first ?? 'Unknown error',
        errors: envelope.errors ?? [],
        traceId: envelope.traceId,
      );
    }

    return envelope.data!;
  }

  /// GET /api/v1/wallets/{id}/transactions?page=X&pageSize=Y
  Future<PagedResponseModel<TransactionModel>> getTransactions({
    required String walletId,
    int page = 1,
    int pageSize = 20,
  }) async {
    final response = await _dio.get(
      ApiConstants.transactions(walletId),
      queryParameters: {'page': page, 'pageSize': pageSize},
    );

    final envelope = ApiEnvelope.fromJson(
      response.data as Map<String, dynamic>,
      (data) => PagedResponseModel.fromJson(
        data as Map<String, dynamic>,
        (item) => TransactionModel.fromJson(item),
      ),
    );

    if (!envelope.success || envelope.data == null) {
      throw ApiException(
        statusCode: response.statusCode ?? 500,
        message: envelope.errors?.first ?? 'Unknown error',
        errors: envelope.errors ?? [],
        traceId: envelope.traceId,
      );
    }

    return envelope.data!;
  }

  /// Shared parser for single-transaction envelope responses.
  TransactionModel _parseTransactionResponse(Response response) {
    final envelope = ApiEnvelope.fromJson(
      response.data as Map<String, dynamic>,
      (data) =>
          TransactionModel.fromJson(data as Map<String, dynamic>),
    );

    if (!envelope.success || envelope.data == null) {
      throw ApiException(
        statusCode: response.statusCode ?? 500,
        message: envelope.errors?.first ?? 'Unknown error',
        errors: envelope.errors ?? [],
        traceId: envelope.traceId,
      );
    }

    return envelope.data!;
  }
}
