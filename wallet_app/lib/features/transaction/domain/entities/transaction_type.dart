
library;

enum TransactionType {
  deposit('Deposit'),
  withdrawal('Withdrawal'),
  transferOut('TransferOut'),
  transferIn('TransferIn');

  /// The string representation as returned by the backend API.
  final String value;

  const TransactionType(this.value);

  static TransactionType fromString(String value) {
    return TransactionType.values.firstWhere(
      (e) => e.value.toLowerCase() == value.toLowerCase(),
      orElse: () => TransactionType.deposit,
    );
  }
}
