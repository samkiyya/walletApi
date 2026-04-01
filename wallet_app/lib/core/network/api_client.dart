/// {@template api_client}
/// Production-grade Dio HTTP client factory.
///
/// Wires up:
/// - [AppDioInterceptor] for structured logging, timing, idempotency
/// - [CertificatePinningInterceptor] for TLS security
///
/// All [print] calls have been replaced with [AppLogger].
/// {@endtemplate}
library;

import 'package:dio/dio.dart';
import 'package:dio/io.dart';

import 'package:wallet_app/core/constants/api_constants.dart';
import 'package:wallet_app/core/network/app_interceptor.dart';
import 'package:wallet_app/core/utils/app_logger.dart';

Dio createDioClient() {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: ApiConstants.connectTimeout,
      receiveTimeout: ApiConstants.receiveTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  // ── Certificate Pinning ─────────────────────────────────────────
  // Wire up the custom HttpClient adapter with certificate validation.
  final pinning = CertificatePinningInterceptor();
  (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient =
      pinning.createPinnedHttpClient;

  // ── Structured Interceptors ─────────────────────────────────────
  // Order matters: AppDioInterceptor logs before any retry logic would go.
  dio.interceptors.add(AppDioInterceptor());

  AppLogger.info(
    'Dio client initialized → ${ApiConstants.baseUrl}',
    tag: 'Network',
  );

  return dio;
}
