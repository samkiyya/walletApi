/// {@template wallet_detail_page}
/// Single wallet detail page with balance display and action buttons.
///
/// Shows:
/// - Hero balance card with CBE gradient
/// - Quick action buttons: Deposit, Withdraw, Transfer
/// - Inline recent transactions (last 5)
/// - Link to full transaction history
///
/// Manages two BLoC instances:
/// - [WalletBloc] for wallet data
/// - [TransactionBloc] for financial operations + recent history
/// {@endtemplate}
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:wallet_app/app/theme.dart';
import 'package:wallet_app/di/injection_container.dart';
import 'package:wallet_app/features/transaction/presentation/bloc/transaction_bloc.dart';
import 'package:wallet_app/features/transaction/presentation/bloc/transaction_event.dart';
import 'package:wallet_app/features/transaction/presentation/bloc/transaction_state.dart';
import 'package:wallet_app/features/transaction/presentation/widgets/amount_input_sheet.dart';
import 'package:wallet_app/features/transaction/presentation/widgets/transaction_tile.dart';
import 'package:wallet_app/features/transaction/presentation/widgets/transfer_sheet.dart';
import 'package:wallet_app/features/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:wallet_app/features/wallet/presentation/bloc/wallet_event.dart';
import 'package:wallet_app/features/wallet/presentation/bloc/wallet_state.dart';

class WalletDetailPage extends StatelessWidget {
  final String walletId;

  const WalletDetailPage({super.key, required this.walletId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              sl<WalletBloc>()..add(LoadWalletDetail(walletId)),
        ),
        BlocProvider(
          create: (_) => sl<TransactionBloc>()
            ..add(LoadTransactions(walletId: walletId, pageSize: 5)),
        ),
      ],
      child: _WalletDetailView(walletId: walletId),
    );
  }
}

class _WalletDetailView extends StatelessWidget {
  final String walletId;

  const _WalletDetailView({required this.walletId});

  @override
  Widget build(BuildContext context) {
    final colors = context.cbeColors;

    return Scaffold(
      backgroundColor: colors.background,
      body: BlocConsumer<TransactionBloc, TransactionState>(
        listener: (context, txState) {
          final scheme = Theme.of(context).colorScheme;
          if (txState is TransactionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.check_circle_rounded,
                        color: scheme.onInverseSurface, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                        child: Text(txState.message,
                            style: TextStyle(
                                color: scheme.onInverseSurface))),
                  ],
                ),
              ),
            );
            // Refresh wallet balance and transactions after operation
            context.read<WalletBloc>().add(LoadWalletDetail(walletId));
            context.read<TransactionBloc>().add(
                  LoadTransactions(walletId: walletId, pageSize: 5),
                );
          }
          if (txState is TransactionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.error_outline_rounded,
                        color: scheme.onInverseSurface, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                        child: Text(txState.message,
                            style: TextStyle(
                                color: scheme.onInverseSurface))),
                  ],
                ),
              ),
            );
          }
        },
        builder: (context, txState) {
          return BlocBuilder<WalletBloc, WalletState>(
            builder: (context, walletState) {
              return CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // ── Hero AppBar ────────────────────────────────
                  _buildSliverAppBar(context, walletState),

                  // ── Action Buttons ─────────────────────────────
                  SliverToBoxAdapter(
                    child: _buildActionButtons(context),
                  ),

                  // ── Wallet ID Copy Section ─────────────────────
                  SliverToBoxAdapter(
                    child: _buildWalletIdSection(context),
                  ),

                  // ── Recent Transactions Header ─────────────────
                  SliverToBoxAdapter(
                    child: Padding(
                      padding:
                          const EdgeInsets.fromLTRB(20, 24, 20, 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Recent Transactions',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          TextButton(
                            onPressed: () => context.push(
                              '/wallets/$walletId/transactions',
                            ),
                            child: const Text('See All'),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ── Transaction List ───────────────────────────
                  _buildTransactionList(context, txState),

                  const SliverPadding(
                      padding: EdgeInsets.only(bottom: 32)),
                ],
              );
            },
          );
        },
      ),
    );
  }

  // ── Hero AppBar with Balance ──────────────────────────────────────

  Widget _buildSliverAppBar(BuildContext context, WalletState state) {
    final colors = context.cbeColors;
    final scheme = Theme.of(context).colorScheme;
    final currencyFormat =
        NumberFormat.currency(symbol: 'ETB ', decimalDigits: 2);

    String balance = 'ETB 0.00';
    String ownerName = 'Loading...';

    if (state is WalletDetailLoaded) {
      balance = currencyFormat.format(state.wallet.balance);
      ownerName = state.wallet.ownerName ?? 'Anonymous Wallet';
    }

    return SliverAppBar(
      expandedHeight: 220,
      pinned: true,
      backgroundColor: scheme.primary,
      foregroundColor: scheme.onPrimary,
      iconTheme: IconThemeData(color: scheme.onPrimary),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(gradient: AppTheme.heroGradient),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    ownerName,
                    style: TextStyle(
                      color: colors.onGradient.withValues(alpha: 0.85),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    balance,
                    style: TextStyle(
                      color: colors.onGradient,
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1,
                    ),
                  )
                      .animate(
                          target: state is WalletDetailLoaded ? 1 : 0)
                      .fadeIn(duration: 400.ms)
                      .slideY(begin: 0.2, end: 0, duration: 400.ms),
                  const SizedBox(height: 4),
                  Text(
                    'Available Balance',
                    style: TextStyle(
                      color: colors.onGradientMuted,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      title: Text(
        'Wallet Details',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: scheme.onPrimary,
        ),
      ),
    );
  }

  // ── Action Buttons ────────────────────────────────────────────────

  Widget _buildActionButtons(BuildContext context) {
    final colors = context.cbeColors;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Row(
        children: [
          _ActionButton(
            icon: Icons.south_west_rounded,
            label: 'Deposit',
            color: colors.successGreen,
            bgColor: colors.successGreenLight,
            onTap: () => _showDeposit(context),
          ),
          const SizedBox(width: 12),
          _ActionButton(
            icon: Icons.north_east_rounded,
            label: 'Withdraw',
            color: colors.errorRed,
            bgColor: colors.errorRedLight,
            onTap: () => _showWithdraw(context),
          ),
          const SizedBox(width: 12),
          _ActionButton(
            icon: Icons.swap_horiz_rounded,
            label: 'Transfer',
            color: colors.cbePurple,
            bgColor: colors.cbePurpleLight,
            onTap: () => _showTransfer(context),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 500.ms, delay: 200.ms)
        .slideY(begin: 0.15, end: 0, duration: 500.ms, delay: 200.ms);
  }

  // ── Wallet ID Copy Section ────────────────────────────────────────

  Widget _buildWalletIdSection(BuildContext context) {
    final colors = context.cbeColors;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.divider),
      ),
      child: Row(
        children: [
          Icon(Icons.tag_rounded, size: 18, color: colors.textSecondary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              walletId,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontFamily: 'monospace',
                    fontSize: 12,
                    color: colors.textSecondary,
                  ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: walletId));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Wallet ID copied!'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: colors.cbePurpleLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.copy_rounded, size: 14, color: colors.cbePurple),
                  const SizedBox(width: 4),
                  Text(
                    'Copy',
                    style: TextStyle(
                      color: colors.cbePurple,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Transaction List ──────────────────────────────────────────────

  Widget _buildTransactionList(
      BuildContext context, TransactionState txState) {
    final colors = context.cbeColors;

    if (txState is TransactionLoading) {
      return SliverFillRemaining(
        child: Center(
          child: CircularProgressIndicator(color: colors.cbePurple),
        ),
      );
    }

    if (txState is TransactionsLoaded) {
      if (txState.transactions.isEmpty) {
        return SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colors.divider),
            ),
            child: Column(
              children: [
                Icon(Icons.receipt_long_outlined,
                    size: 48, color: colors.textMuted),
                const SizedBox(height: 12),
                Text(
                  'No transactions yet',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  'Make your first deposit to get started',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        );
      }

      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (_, index) => TransactionTile(
            transaction: txState.transactions[index],
            index: index,
          ),
          childCount: txState.transactions.length,
        ),
      );
    }

    return const SliverToBoxAdapter(child: SizedBox.shrink());
  }

  // ── Bottom Sheet Launchers ────────────────────────────────────────

  void _showDeposit(BuildContext context) {
    final txBloc = context.read<TransactionBloc>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => AmountInputSheet(
        title: 'Deposit Funds',
        subtitle: 'Add money to your wallet',
        icon: Icons.south_west_rounded,
        gradient: AppTheme.depositGradient,
        buttonLabel: 'Confirm Deposit',
        onSubmit: (amount) {
          txBloc.add(SubmitDeposit(walletId: walletId, amount: amount));
        },
      ),
    );
  }

  void _showWithdraw(BuildContext context) {
    final txBloc = context.read<TransactionBloc>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => AmountInputSheet(
        title: 'Withdraw Funds',
        subtitle: 'Take money from your wallet',
        icon: Icons.north_east_rounded,
        gradient: AppTheme.withdrawGradient,
        buttonLabel: 'Confirm Withdrawal',
        onSubmit: (amount) {
          txBloc.add(SubmitWithdraw(walletId: walletId, amount: amount));
        },
      ),
    );
  }

  void _showTransfer(BuildContext context) {
    final txBloc = context.read<TransactionBloc>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => TransferSheet(
        fromWalletId: walletId,
        onSubmit: (toWalletId, amount) {
          txBloc.add(SubmitTransfer(
            fromWalletId: walletId,
            toWalletId: toWalletId,
            amount: amount,
          ));
        },
      ),
    );
  }
}

// ── Action Button Widget ──────────────────────────────────────────────

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color bgColor;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.bgColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.cbeColors;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.divider),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(height: 10),
              Text(
                label,
                style: TextStyle(
                  color: colors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
