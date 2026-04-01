library;

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:wallet_app/core/constants/api_constants.dart';
import 'package:wallet_app/core/network/app_interceptor.dart';
import 'package:wallet_app/core/network/secure_http_client.dart';
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

  final adapter = dio.httpClientAdapter as IOHttpClientAdapter;

  adapter.createHttpClient = () {
    // return HttpSecurityPinningClient(
    //   ["T4eoRdbfIYF3G9IOGamqR3Vgye2bNLHQTSCOY8u3y5w="],
    // );
   return  createSecureHttpClient();
  };

  // ── Structured Interceptors ─────────────────────────────────────
  // Order matters: AppDioInterceptor logs before any retry logic would go.
  dio.interceptors.add(AppDioInterceptor());

  AppLogger.info(
    'Dio client initialized → ${ApiConstants.baseUrl}',
    tag: 'Network',
  );

  return dio;
}
