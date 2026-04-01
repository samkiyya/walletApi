/// {@template cbe_hero_app_bar}
/// A consistent, reusable [SliverAppBar] with a CBE-branded gradient hero section.
///
/// Features:
/// - Smooth collapse animation into a standard app bar
/// - Native [actions] for perfect vertical alignment
/// - Flawless safe-area handling preventing layout bleeding
/// - Interpolated cross-fades ensuring crisp typography 
///
/// Use this for top-level pages that need a strong branding presence
/// (like the Wallets list or Wallet Details). Use [CbeAppBar] for simpler inner pages.
/// {@endtemplate}
library;

import 'package:flutter/material.dart';
import 'package:wallet_app/app/theme.dart';
import 'package:wallet_app/core/presentation/widgets/theme_toggle_button.dart';

class CbeHeroAppBar extends StatelessWidget {
  /// The title displayed in the AppBar when fully collapsed.
  final String title;

  /// The widget displayed in the expanded hero section.
  /// Must be bounded (e.g., Column with mainAxisSize: min).
  final Widget heroContent;

  /// The total height of the expanded hero section excluding the status bar.
  final double expandedHeight;

  /// Additional native actions (theme toggle is always included).
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
      stretch: true, // Overscroll bounce effect
      backgroundColor: scheme.primary,
      surfaceTintColor: Colors.transparent, // Prevents M3 auto-tinting scroll artifacts
      elevation: 0,
      iconTheme: IconThemeData(color: colors.onGradient), // Standard back button color
      
      // Native actions layer, guaranteeing perfect vertical centering within kToolbarHeight
      actions: [
        ...?actions,
        ThemeToggleButton(color: colors.onGradient),
        const SizedBox(width: 8),
      ],

      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final topPadding = MediaQuery.of(context).padding.top;
          final minExtent = kToolbarHeight + topPadding;
          final maxExtent = expandedHeight + topPadding;
          final currentHeight = constraints.maxHeight;
          
          // 0.0 = fully collapsed, 1.0 = fully expanded
          final expansionRatio = 
              ((currentHeight - minExtent) / (maxExtent - minExtent)).clamp(0.0, 1.0);
          
          // Cross-fade opacity curves natively synced to scroll
          final titleOpacity = (1.0 - (expansionRatio * 2)).clamp(0.0, 1.0);
          final heroOpacity = ((expansionRatio - 0.2) * 1.5).clamp(0.0, 1.0);

          return Stack(
            fit: StackFit.expand,
            children: [
              // 1. Background Gradient (stretches natively)
              Container(
                decoration: const BoxDecoration(
                  gradient: kHeroGradient,
                ),
              ),
              
              // 2. Solid color overlay when collapsing to erase gradient noise
              Opacity(
                opacity: 1.0 - expansionRatio,
                child: Container(color: scheme.primary),
              ),

              // 3. Hero Content perfectly bounded beneath the native app bar zone
              Positioned(
                top: minExtent, 
                left: 20,
                right: 20,
                bottom: 20, // Internal padding
                child: Opacity(
                  opacity: heroOpacity,
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: heroContent,
                  ),
                ),
              ),

              // 4. Centered Collapsed Title aligned securely in the toolbar matrix
              Positioned(
                top: topPadding, 
                left: 56, // Clears back button
                right: 56, // Clears actions
                height: kToolbarHeight,
                child: Opacity(
                  opacity: titleOpacity,
                  child: Center(
                    child: Text(
                      title,
                      style: TextStyle(
                        color: colors.onGradient,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
