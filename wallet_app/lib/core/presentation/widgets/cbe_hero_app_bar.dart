/// {@template cbe_hero_app_bar}
/// A consistent, reusable [SliverAppBar] with a CBE-branded gradient hero section.
///
/// Features:
/// - Smooth collapse animation into a standard app bar
/// - Hero background gradient
/// - Standardized theme toggle button in the top right
/// - Back button support
///
/// Use this for top-level pages that need a strong branding presence
/// (like the Wallets list or Wallet Details). Use [CbeAppBar] for simpler inner pages.
/// {@endtemplate}
library;

import 'package:flutter/material.dart';
import 'package:wallet_app/app/theme.dart';
import 'package:wallet_app/core/presentation/widgets/theme_toggle_button.dart';

class CbeHeroAppBar extends StatelessWidget {
  /// The title displayed when the app bar is fully collapsed.
  final String title;

  /// The widget displayed in the expanded hero section.
  final Widget heroContent;

  /// The maximum height of the expanded hero section.
  final double expandedHeight;

  /// Additional actions (theme toggle is always included automatically).
  final List<Widget>? actions;

  const CbeHeroAppBar({
    super.key,
    required this.title,
    required this.heroContent,
    this.expandedHeight = 220.0,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.cbeColors;
    final scheme = Theme.of(context).colorScheme;

    return SliverAppBar(
      expandedHeight: expandedHeight,
      floating: false,
      pinned: true,
      backgroundColor: scheme.primary,
      surfaceTintColor: scheme.primary,
      iconTheme: IconThemeData(color: colors.onGradient), // For back button
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final currentHeight = constraints.maxHeight;
          final topPadding = MediaQuery.of(context).padding.top;
          
          final collapseRatio = ((currentHeight - kToolbarHeight - topPadding) /
                  (expandedHeight - kToolbarHeight - topPadding))
              .clamp(0.0, 1.0);

          return Stack(
            fit: StackFit.expand,
            children: [
              // ── Expanded hero content (fades out on collapse) ──
              Opacity(
                opacity: collapseRatio,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: kHeroGradient,
                  ),
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ...?actions,
                                ThemeToggleButton(color: colors.onGradient),
                              ],
                            ),
                          ),
                          Positioned.fill(
                            top: kToolbarHeight,
                            child: heroContent,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // ── Collapsed title (fades in on collapse) ──
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: kToolbarHeight + topPadding,
                child: Opacity(
                  opacity: (1.0 - collapseRatio).clamp(0.0, 1.0),
                  child: Container(
                    color: scheme.primary,
                    alignment: Alignment.bottomCenter,
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Text(
                      title,
                      style: TextStyle(
                        color: colors.onGradient,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
