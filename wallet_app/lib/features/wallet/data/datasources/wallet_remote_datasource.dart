library;

import 'package:dio/dio.dart';

import 'package:wallet_app/core/constants/api_constants.dart';
import 'package:wallet_app/core/error/api_exception.dart';
import 'package:wallet_app/core/network/api_envelope.dart';
import 'package:wallet_app/features/wallet/data/models/paged_response_model.dart';
import 'package:wallet_app/features/wallet/data/models/wallet_model.dart';

class WalletRemoteDataSource {
  final Dio _dio;

  const WalletRemoteDataSource(this._dio);

  /// POST /api/v1/wallets — Creates a new wallet.
  Future<WalletModel> createWallet({String? ownerName}) async {
    final response = await _dio.post(
      ApiConstants.wallets,
      data: {'ownerName': ownerName},
    );
    return _parseWalletResponse(response);
  }

  /// GET /api/v1/wallets/{id} — Fetches a single wallet.
  Future<WalletModel> getWallet(String id) async {
    final response = await _dio.get(ApiConstants.walletById(id));
    return _parseWalletResponse(response);
  }

  /// GET /api/v1/wallets?page={page}&pageSize={pageSize} — Lists all wallets.
  Future<PagedResponseModel<WalletModel>> getWallets({
    int page = 1,
    int pageSize = 20,
  }) async {
    final response = await _dio.get(
      ApiConstants.wallets,
      queryParameters: {'page': page, 'pageSize': pageSize},
    );

    final envelope = ApiEnvelope.fromJson(
      response.data as Map<String, dynamic>,
      (data) => PagedResponseModel.fromJson(
        data as Map<String, dynamic>,
        (item) => WalletModel.fromJson(item),
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

  /// Shared parser for single-wallet envelope responses.
  WalletModel _parseWalletResponse(Response response) {
    final envelope = ApiEnvelope.fromJson(
      response.data as Map<String, dynamic>,
      (data) => WalletModel.fromJson(data as Map<String, dynamic>),
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
