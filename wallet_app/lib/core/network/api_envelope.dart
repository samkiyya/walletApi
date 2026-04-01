library;

class ApiEnvelope<T> {
  final bool success;
  final T? data;
  final List<String>? errors;
  final String? traceId;
  final DateTime? timestamp;

  const ApiEnvelope({
    required this.success,
    this.data,
    this.errors,
    this.traceId,
    this.timestamp,
  });

  factory ApiEnvelope.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json)? dataParser,
  ) {
    return ApiEnvelope<T>(
      success: json['success'] as bool? ?? false,
      data: json['data'] != null && dataParser != null
          ? dataParser(json['data'])
          : null,
      errors: (json['errors'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      traceId: json['traceId'] as String?,
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'] as String)
          : null,
    );
  }
}
