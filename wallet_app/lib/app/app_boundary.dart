library;

import 'package:flutter/material.dart';

class AppBoundary extends StatelessWidget {
  final Widget child;

  const AppBoundary({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final screenWidth = media.size.width;
    final isCompact = screenWidth < 600;
    final fluidScale = isCompact ? (screenWidth / 375).clamp(0.85, 1.15) : 1.0;
    final clampedScale = (media.textScaler.scale(fluidScale)).clamp(0.8, 1.4);

    return MediaQuery(
      data: media.copyWith(textScaler: TextScaler.linear(clampedScale)),
      child: SafeArea(child: child),
    );
  }
}
