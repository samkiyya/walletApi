import 'package:flutter/material.dart';

class AppBoundary extends StatelessWidget {
  final Widget child;

  const AppBoundary({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    // 1. Fluid Mobile Scaling
    // Synthesizes a proportional text scaling factor relative to a standard 375 mobile design.
    // Handles all different mobile sizes perfectly natively.
    final screenWidth = media.size.width;
    final isDesktopOrTablet = screenWidth > 600;
    final fluidScale = isDesktopOrTablet ? 1.0 : (screenWidth / 375).clamp(0.85, 1.15);

    // 2. Global Safety and Normalization
    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 650), // Tablet/Desktop constraint boundary
          child: MediaQuery(
            data: media.copyWith(
              // Clamp OS scaling + fluid device scaling to prevent busted layouts
              textScaler: TextScaler.linear(
                media.textScaler.scale(fluidScale).clamp(0.8, 1.4),
              ),
            ),
            // 3. Global SafeArea handling
            child: SafeArea(
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}