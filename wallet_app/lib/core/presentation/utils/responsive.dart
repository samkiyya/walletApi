/// {@template responsive_utils}
/// A senior-level, unified responsive framework for the application.
/// 
/// Embraces the "Flutter Way" by avoiding rigid, hardcoded device breakpoints 
/// (like `isTablet`). Instead, it leverages intrinsic constraints, fluid math, 
/// and Flutter 3.x targeted `MediaQuery` getters (e.g., `sizeOf` instead of 
/// `of`) to prevent unnecessary widget tree rebuilds.
/// {@endtemplate}
library;

import 'package:flutter/material.dart';

/// Extension on [BuildContext] for elegant, optimized responsive design.
extension ResponsiveContext on BuildContext {
  // ── 1. Optimized Window Metrics ──────────────────────────────────
  // Using MediaQuery.xOf(context) instead of MediaQuery.of(context).x 
  // is a core Flutter 3 optimization. It ensures widgets only rebuild 
  // when the SPECIFIC metric changes, not any metric.

  /// The physical width of the screen.
  double get width => MediaQuery.sizeOf(this).width;

  /// The physical height of the screen.
  double get height => MediaQuery.sizeOf(this).height;

  /// The height of the system status bar (notch area).
  double get safeTop => MediaQuery.paddingOf(this).top;

  /// The height of the system navigation bar (or home indicator).
  double get safeBottom => MediaQuery.paddingOf(this).bottom;

  /// The height of the on-screen keyboard (if open).
  double get keyboardHeight => MediaQuery.viewInsetsOf(this).bottom;

  /// Returns true if the keyboard is actively visible on the screen.
  bool get isKeyboardVisible => MediaQuery.viewInsetsOf(this).bottom > 0;

  /// Text scaling factor configured by the user in OS accessibility settings.
  double get textScale => MediaQuery.textScalerOf(this).scale(14) / 14;

  // ── 2. Fluid & Adaptive Math ──────────────────────────────────────

  /// Calculates a fluid dimension that scales proportionally with the screen width
  /// but locks securely between a [min] and [max] boundary.
  /// 
  /// The [baseWidth] represents the design draft's width (usually 375 for mobile).
  /// This is vastly superior to rigid breakpoints as it organically morphs.
  double fluid(double size, {double? min, double? max, double baseWidth = 375}) {
    final scale = width / baseWidth;
    final fluidSize = size * scale;
    return fluidSize.clamp(min ?? size * 0.8, max ?? size * 1.5);
  }

  /// Calculates a height scaling proportionally with the screen height.
  /// Useful for dramatic vertical spacing (e.g., empty states).
  double fluidHeight(double size, {double? min, double? max, double baseHeight = 812}) {
    final scale = height / baseHeight;
    final fluidSize = size * scale;
    return fluidSize.clamp(min ?? size * 0.8, max ?? size * 1.5);
  }
}

// ── 3. Constraint Wrappers ──────────────────────────────────────────

/// A core widget that restricts its child to a maximum width and perfectly 
/// centers it. 
/// 
/// This is the "Flutter Way" to handle large screens (tablets/desktop) 
/// without relying on explicit breakpoints. The UI naturally flows until 
/// it hits a reasonable maximum readable width.
class AppResponsiveConstraint extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const AppResponsiveConstraint({
    super.key,
    required this.child,
    this.maxWidth = 600,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
