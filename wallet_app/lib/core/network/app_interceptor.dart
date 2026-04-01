/// {@template app_dio_interceptor}
/// Production-grade Dio interceptor providing:
///
/// 1. **Structured logging** via [AppLogger] (replaces raw `print` calls)
/// 2. **Request timing** — measures end-to-end latency per call
/// 3. **Idempotency key injection** — adds `X-Idempotency-Key` header on
///    mutating requests (POST/PUT/PATCH) automatically
/// 4. **Correlation ID propagation** — `X-Request-Id` for distributed tracing
///    with the backend API
/// {@endtemplate}
library;

import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';

import 'package:wallet_app/core/utils/app_logger.dart';

class AppDioInterceptor extends Interceptor {
  final _uuid = const Uuid();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // ── Correlation ID ────────────────────────────────────────────
    // Unique per request; lets you correlate client logs with server logs.
    final requestId = _uuid.v4();
    options.headers['X-Request-Id'] = requestId;

    // ── Idempotency Key (POST/PUT/PATCH only) ─────────────────────
    // Financial APIs MUST be idempotent. Auto-inject unless caller set one.
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

/// {@template certificate_pinning_interceptor}
/// SSL/TLS Certificate Pinning interceptor.
///
/// IMPORTANT — Development vs Production:
/// - In development the server runs on `http://10.0.2.2` (emulator localhost)
///   which has no TLS. No pinning is applied. The `BadCertificateCallback`
///   is set to allow all for local emulator traffic ONLY in debug mode.
/// - In production, replace [_allowedFingerprints] with the SHA-256
///   fingerprints of your server certificate's leaf and/or intermediate CA.
///   Pinning is enforced when [kDebugMode] is false.
///
/// How to get the fingerprint:
/// ```bash
/// openssl s_client -connect api.cbe.com.et:443 < /dev/null 2>/dev/null \
///   | openssl x509 -fingerprint -sha256 -noout
/// ```
/// {@endtemplate}
class CertificatePinningInterceptor extends Interceptor {
  /// SHA-256 fingerprints of trusted server certificates.
  /// Replace with your actual certificate fingerprints before going to production.
  static const _allowedFingerprints = <String>[
    // PRODUCTION: Add your cert fingerprint here, e.g.:
    // 'AA:BB:CC:DD:EE:FF:...',
  ];

  HttpClient createPinnedHttpClient() {
    final client = HttpClient();

    client.badCertificateCallback = (cert, host, port) {
      // ── Development bypass ─────────────────────────────────────
      // Only allow self-signed or local certs in debug mode.
      if (const bool.fromEnvironment('dart.vm.product') == false) {
        AppLogger.warning(
          'Certificate validation bypassed for $host:$port (DEBUG MODE ONLY)',
          tag: 'TLS',
        );
        return true;
      }

      // ── Production enforcement ─────────────────────────────────
      if (_allowedFingerprints.isEmpty) {
        // No pins configured: fail closed and reject untrusted certs.
        AppLogger.error(
          'Certificate rejected: No pins configured. Set fingerprints in '
          'CertificatePinningInterceptor._allowedFingerprints.',
          tag: 'TLS',
        );
        return false;
      }

      final certFingerprint = sha256
          .convert(cert.der)
          .bytes
          .map((byte) => byte.toRadixString(16).padLeft(2, '0').toUpperCase())
          .join(':');

      final trusted = _allowedFingerprints.any(
        (pin) => pin.toUpperCase() == certFingerprint,
      );

      if (!trusted) {
        AppLogger.error(
          'PINNING FAILURE: $host:$port rejected. '
          'Got: $certFingerprint.',
          tag: 'TLS',
        );
      }

      return trusted;
    };

    return client;
  }
}
