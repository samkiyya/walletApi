library;

import 'package:go_router/go_router.dart';

import 'package:wallet_app/features/transaction/presentation/pages/transactions_page.dart';
import 'package:wallet_app/features/wallet/presentation/pages/wallet_detail_page.dart';
import 'package:wallet_app/features/wallet/presentation/pages/wallets_page.dart';

/// Centralized route paths (industry practice)
abstract final class AppRoutes {
  static const wallets = '/';
  static const walletDetail = '/wallets/:id';
  static const walletTransactions = 'transactions';
}

/// Creates the app-wide [GoRouter] instance.
GoRouter createRouter() {
  return GoRouter(
    initialLocation: AppRoutes.wallets,

    routes: [
      // ── Wallets (Home) ───────────────────────────────────────
      GoRoute(
        path: AppRoutes.wallets,
        name: 'wallets',
        builder: (context, state) => const WalletsPage(),
      ),

      // ── Wallet Detail Scope ──────────────────────────────────
      GoRoute(
        path: AppRoutes.walletDetail,
        name: 'wallet-detail',
        builder: (context, state) {
          final walletId = state.pathParameters['id']!;
          return WalletDetailPage(walletId: walletId);
        },

        routes: [
          // ── Wallet Transactions (nested feature route) ───────
          GoRoute(
            path: AppRoutes.walletTransactions,
            name: 'wallet-transactions',
            builder: (context, state) {
              final walletId = state.pathParameters['id']!;
              return TransactionsPage(walletId: walletId);
            },
          ),
        ],
      ),
    ],
  );
}
