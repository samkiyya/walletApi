
library;


import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';

import 'package:wallet_app/core/utils/app_logger.dart';

class AppDioInterceptor extends Interceptor {
  final _uuid = const Uuid();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // ── Correlation ID ────────────────────────────────────────────
    final requestId = _uuid.v4();
    options.headers['X-Request-Id'] = requestId;

    // ── Idempotency Key (POST/PUT/PATCH only) ─────────────────────
    final method = options.method.toUpperCase();
    if (['POST', 'PUT', 'PATCH'].contains(method)) {
      options.headers.putIfAbsent('X-Idempotency-Key', () => _uuid.v4());
    }

    // ── Request Timestamp ─────────────────────────────────────────
    options.extra['_requestStartMs'] = DateTime.now().millisecondsSinceEpoch;

    AppLogger.request(method, options.path, body: options.data);

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final duration = _getDuration(response.requestOptions);
    AppLogger.response(
      response.statusCode ?? 0,
      response.requestOptions.path,
      body: response.data,
      duration: duration,
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final duration = _getDuration(err.requestOptions);
    final statusCode = err.response?.statusCode ?? 0;
    final durationStr = '${duration?.inMilliseconds ?? '?'}ms';

    AppLogger.error(
      'HTTP Error [$statusCode] ${err.requestOptions.method} '
      '${err.requestOptions.path} ($durationStr)',
      tag: 'Network',
      error: err.message,
    );

    if (err.response?.data != null) {
      AppLogger.error(
        '  ↳ Response body: ${err.response?.data}',
        tag: 'Network',
      );
    }

    handler.next(err);
  }

  // ── Helpers ───────────────────────────────────────────────────────

  Duration? _getDuration(RequestOptions options) {
    final startMs = options.extra['_requestStartMs'] as int?;
    if (startMs == null) return null;
    return Duration(
      milliseconds: DateTime.now().millisecondsSinceEpoch - startMs,
    );
  }
}

