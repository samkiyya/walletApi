/// {@template wallets_page}
/// Main page displaying all wallets in a scrollable list.
///
/// Features:
/// - Pull-to-refresh for manual data reload
/// - Shimmer skeleton loading state
/// - FAB to create a new wallet via bottom sheet
/// - Staggered card entrance animations
/// - Error state with retry button
/// - CBE branded header and color scheme
/// - Client-side search by wallet ID or owner name
/// {@endtemplate}
library;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import 'package:wallet_app/app/theme.dart';
import 'package:wallet_app/core/presentation/utils/responsive.dart';
import 'package:wallet_app/core/presentation/widgets/cbe_hero_app_bar.dart';
import 'package:wallet_app/di/injection_container.dart';
import 'package:wallet_app/features/wallet/domain/entities/wallet.dart';
import 'package:wallet_app/features/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:wallet_app/features/wallet/presentation/bloc/wallet_event.dart';
import 'package:wallet_app/features/wallet/presentation/bloc/wallet_state.dart';
import 'package:wallet_app/features/wallet/presentation/widgets/create_wallet_dialog.dart';
import 'package:wallet_app/features/wallet/presentation/widgets/wallet_card.dart';

class WalletsPage extends StatelessWidget {
  const WalletsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<WalletBloc>()..add(const LoadWallets()),
      child: const _WalletsView(),
    );
  }
}

class _WalletsView extends StatefulWidget {
  const _WalletsView();

  @override
  State<_WalletsView> createState() => _WalletsViewState();
}

class _WalletsViewState extends State<_WalletsView> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  String _searchQuery = '';
  bool _isFabExtended = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
      if (_isFabExtended) {
        setState(() => _isFabExtended = false);
      }
    } else if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
      if (!_isFabExtended) {
        setState(() => _isFabExtended = true);
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /// Client-side filter by wallet ID or owner name.
  List<Wallet> _filterWallets(List<Wallet> wallets) {
    if (_searchQuery.isEmpty) return wallets;
    final query = _searchQuery.toLowerCase();
    return wallets.where((w) {
      final nameMatch =
          w.ownerName?.toLowerCase().contains(query) ?? false;
      final idMatch = w.id.toLowerCase().contains(query);
      return nameMatch || idMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.cbeColors;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.background,
      body: CustomScrollView(
        controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        slivers: [
          // ── CBE Branded App Bar ──────────────────────────────
          CbeHeroAppBar(
            title: 'My Wallets',
            expandedHeight: 140,
            heroContent: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colors.onGradient.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.account_balance_rounded,
                    color: colors.onGradient,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'CBE Wallet',
                        style: TextStyle(
                          color: colors.onGradient,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                      Text(
                        'Commercial Bank of Ethiopia',
                        style: TextStyle(
                          color: colors.onGradientMuted,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
    
          // ── Search Bar ───────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: TextField(
                controller: _searchController,
                onChanged: (value) =>
                    setState(() => _searchQuery = value.trim()),
                decoration: InputDecoration(
                  hintText: 'Search by name or wallet ID...',
                  prefixIcon:
                      Icon(Icons.search_rounded, color: colors.textMuted),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear_rounded,
                              color: colors.textMuted),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: colors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: colors.divider),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: colors.divider),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                        color: scheme.primary, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                ),
              ),
            ),
          ),
    
          // ── Body ──────────────────────────────────────────────
          BlocConsumer<WalletBloc, WalletState>(
            listener: (context, state) {
              if (state is WalletCreated) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        Icon(Icons.check_circle_rounded,
                            color: scheme.onInverseSurface, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Wallet "${state.wallet.ownerName ?? 'Anonymous'}" created!',
                            style: TextStyle(color: scheme.onInverseSurface),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
                context.read<WalletBloc>().add(const LoadWallets());
              }
              if (state is WalletError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        Icon(Icons.error_outline_rounded,
                            color: scheme.onInverseSurface, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(state.message,
                              style: TextStyle(color: scheme.onInverseSurface)),
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is WalletLoading) {
                return _buildShimmerLoading(colors);
              }
    
              if (state is WalletsLoaded) {
                final filtered = _filterWallets(state.wallets);
    
                if (state.wallets.isEmpty) {
                  return SliverFillRemaining(
                    child: _buildEmptyState(context, colors),
                  );
                }
    
                if (filtered.isEmpty) {
                  return SliverFillRemaining(
                    child: _buildNoResultsState(context, colors),
                  );
                }
    
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final wallet = filtered[index];
                      return WalletCard(
                        wallet: wallet,
                        index: index,
                        onTap: () =>
                            context.push('/wallets/${wallet.id}'),
                      );
                    },
                    childCount: filtered.length,
                  ),
                );
              }
    
              if (state is WalletError) {
                return SliverFillRemaining(
                  child: _buildErrorState(context, state.message, colors),
                );
              }
    
              return _buildShimmerLoading(colors);
            },
          ),
    
          // Bottom padding for FAB
          const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateDialog(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Wallet'),
      ),
    );
  }

  void _showCreateDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => BlocProvider.value(
        value: context.read<WalletBloc>(),
        child: const CreateWalletDialog(),
      ),
    );
  }

  Widget _buildShimmerLoading(CbeColors colors) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (_, index) => Shimmer.fromColors(
          baseColor: colors.surfaceLight,
          highlightColor: colors.surface,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            height: 160,
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        childCount: 4,
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, CbeColors colors) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 24,
          vertical: context.fluidHeight(40, min: 20, max: 80),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colors.cbePurpleLight,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.account_balance_wallet_outlined,
                size: 56,
                color: colors.cbePurple,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Wallets Yet',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Create your first CBE wallet to start making deposits, withdrawals, and transfers.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => _showCreateDialog(context),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Create First Wallet'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoResultsState(BuildContext context, CbeColors colors) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colors.cbePurpleLight,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.search_off_rounded,
                size: 56,
                color: colors.textMuted,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Results Found',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'No wallets match "$_searchQuery". Try a different name or ID.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(
      BuildContext context, String message, CbeColors colors) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colors.errorRedLight,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.wifi_off_rounded,
                size: 56,
                color: colors.errorRed,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Something went wrong',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () =>
                  context.read<WalletBloc>().add(const LoadWallets()),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
