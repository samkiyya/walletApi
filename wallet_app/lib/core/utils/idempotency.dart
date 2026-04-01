library;

import 'package:uuid/uuid.dart';

class IdempotencyKeyGenerator {
  const IdempotencyKeyGenerator._();

  static const _uuid = Uuid();

  /// Generates a deposit idempotency key: `dep-<uuid>`.
  static String deposit() => 'dep-${_uuid.v4()}';

  /// Generates a withdrawal idempotency key: `wd-<uuid>`.
  static String withdraw() => 'wd-${_uuid.v4()}';

  /// Generates a transfer idempotency key: `tx-<uuid>`.
  static String transfer() => 'tx-${_uuid.v4()}';
}
