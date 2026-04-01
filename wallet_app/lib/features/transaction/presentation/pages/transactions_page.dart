library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import 'package:wallet_app/app/theme.dart';
import 'package:wallet_app/di/injection_container.dart';
import 'package:wallet_app/features/transaction/presentation/bloc/transaction_bloc.dart';
import 'package:wallet_app/features/transaction/presentation/bloc/transaction_event.dart';
import 'package:wallet_app/features/transaction/presentation/bloc/transaction_state.dart';
import 'package:wallet_app/features/transaction/presentation/widgets/transaction_tile.dart';

class TransactionsPage extends StatelessWidget {
  final String walletId;

  const TransactionsPage({super.key, required this.walletId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<TransactionBloc>()
        ..add(LoadTransactions(walletId: walletId)),
      child: _TransactionsView(walletId: walletId),
    );
  }
}

class _TransactionsView extends StatelessWidget {
  final String walletId;

  const _TransactionsView({required this.walletId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Transaction History'),
        backgroundColor: AppTheme.surface,
      ),
      body: BlocBuilder<TransactionBloc, TransactionState>(
        builder: (context, state) {
          if (state is TransactionLoading) {
            return _buildShimmerLoading();
          }

          if (state is TransactionsLoaded) {
            if (state.transactions.isEmpty) {
              return _buildEmptyState(context);
            }

            return RefreshIndicator(
              color: AppTheme.cbePurple,
              onRefresh: () async {
                context.read<TransactionBloc>().add(
                      LoadTransactions(walletId: walletId),
                    );
                await Future.delayed(const Duration(milliseconds: 500));
              },
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                padding: const EdgeInsets.only(top: 12, bottom: 32),
                itemCount: state.transactions.length +
                    (state.hasNextPage ? 1 : 0),
                itemBuilder: (context, index) {
                  // ── Load more trigger ─────────────────────────
                  if (index == state.transactions.length) {
                    // Trigger next page load
                    context.read<TransactionBloc>().add(
                          LoadTransactions(
                            walletId: walletId,
                            page: state.page + 1,
                          ),
                        );
                    return const Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.cbePurple,
                          strokeWidth: 2,
                        ),
                      ),
                    );
                  }

                  return TransactionTile(
                    transaction: state.transactions[index],
                    index: index,
                  );
                },
              ),
            );
          }

          if (state is TransactionError) {
            return _buildErrorState(context, state.message);
          }

          return _buildShimmerLoading();
        },
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: AppTheme.surfaceLight,
      highlightColor: AppTheme.surface,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 12),
        itemCount: 8,
        itemBuilder: (_, index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          height: 72,
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.cbePurpleLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.receipt_long_outlined,
                size: 56,
                color: AppTheme.cbePurple,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Transactions',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'This wallet has no transaction history yet.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.errorRedLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                size: 56,
                color: AppTheme.errorRed,
              ),
            ),
            const SizedBox(height: 24),
            Text(message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.read<TransactionBloc>().add(
                    LoadTransactions(walletId: walletId),
                  ),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
