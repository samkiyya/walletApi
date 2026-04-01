library;

import 'package:equatable/equatable.dart';

sealed class Failure extends Equatable {
  final String message;
  final List<String> errors;
  final String? traceId;

  const Failure({required this.message, this.errors = const [], this.traceId});

  @override
  List<Object?> get props => [message, errors, traceId];
}

/// HTTP 500 — Unhandled server error.
final class ServerFailure extends Failure {
  const ServerFailure({
    super.message = 'An unexpected server error occurred.',
    super.errors,
    super.traceId,
  });
}

/// HTTP 404 — Resource not found (mirrors [NotFoundException]).
final class NotFoundFailure extends Failure {
  const NotFoundFailure({
    super.message = 'The requested resource was not found.',
    super.errors,
    super.traceId,
  });
}

/// HTTP 400 — Validation or domain rule violation.
final class ValidationFailure extends Failure {
  const ValidationFailure({
    super.message = 'The request contains invalid data.',
    super.errors,
    super.traceId,
  });
}

/// HTTP 422 — Insufficient wallet balance (mirrors [InsufficientFundsException]).
final class InsufficientFundsFailure extends Failure {
  const InsufficientFundsFailure({
    super.message = 'Insufficient funds for this operation.',
    super.errors,
    super.traceId,
  });
}

/// HTTP 409 — Concurrency conflict or duplicate idempotency key.
final class ConflictFailure extends Failure {
  const ConflictFailure({
    super.message = 'A conflict occurred. Please retry.',
    super.errors,
    super.traceId,
  });
}

/// No network connectivity or request timeout.
final class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'Network error. Please check your connection.',
    super.errors,
    super.traceId,
  });
}
