library;

class ApiException implements Exception {
  /// HTTP status code returned by the server.
  final int statusCode;

  /// Human-readable error message (primary).
  final String message;

  /// All error messages from the `errors` array in [ApiEnvelope].
  final List<String> errors;

  /// Correlation / trace ID for debugging (from backend middleware).
  final String? traceId;

  const ApiException({
    required this.statusCode,
    required this.message,
    this.errors = const [],
    this.traceId,
  });

  @override
  String toString() =>
      'ApiException(status: $statusCode, message: $message, traceId: $traceId)';
}
