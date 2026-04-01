library;

class ApiConstants {
  const ApiConstants._();
  static const String baseUrl = 'http://10.0.2.2:5000';

  // ── Wallet Endpoints ──────────────────────────────────────────────
  static const String wallets = '/api/v1/wallets';
  static String walletById(String id) => '/api/v1/wallets/$id';
  static String deposit(String walletId) =>
      '/api/v1/wallets/$walletId/deposit';
  static String withdraw(String walletId) =>
      '/api/v1/wallets/$walletId/withdraw';
  static const String transfers = '/api/v1/wallets/transfers';
  static String transactions(String walletId) =>
      '/api/v1/wallets/$walletId/transactions';

  // ── Timeouts ──────────────────────────────────────────────────────
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 60);

  // ── Pagination Defaults ───────────────────────────────────────────
  static const int defaultPage = 1;
  static const int defaultPageSize = 20;
}
