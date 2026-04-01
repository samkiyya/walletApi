library;

import 'package:go_router/go_router.dart';

import 'package:wallet_app/features/transaction/presentation/pages/transactions_page.dart';
import 'package:wallet_app/features/wallet/presentation/pages/wallet_detail_page.dart';
import 'package:wallet_app/features/wallet/presentation/pages/wallets_page.dart';

/// Creates the app-wide [GoRouter] instance.
GoRouter createRouter() {
  return GoRouter(
    initialLocation: '/',
    routes: [
      // ── Home: Wallet List ─────────────────────────────────────
      GoRoute(
        path: '/',
        name: 'wallets',
        builder: (context, state) => const WalletsPage(),
      ),

      // ── Wallet Detail ─────────────────────────────────────────
      GoRoute(
        path: '/wallets/:id',
        name: 'wallet-detail',
        builder: (context, state) {
          final walletId = state.pathParameters['id']!;
          return WalletDetailPage(walletId: walletId);
        },
        routes: [
          // ── Full Transaction History (nested under wallet) ────
          GoRoute(
            path: 'transactions',
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
