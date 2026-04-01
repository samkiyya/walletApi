/// {@template cbe_colors}
/// ThemeExtension carrying ALL semantic design tokens for the CBE app.
///
/// This is the **single source of truth** for all colors in the UI layer.
/// Widgets access colors via `context.cbeColors` — never raw `Color(...)`
/// or `Colors.xxx`.
///
/// Light and dark palettes are defined as static constants and plugged
/// into [ThemeData.extensions] by [AppTheme].
/// {@endtemplate}
library;

import 'package:flutter/material.dart';

import 'package:wallet_app/app/theme/design_tokens.dart';

class CbeColors extends ThemeExtension<CbeColors> {
  // ── Surface & Background ────────────────────────────────────────────
  final Color background;
  final Color surface;
  final Color surfaceLight;
  final Color divider;
  final Color inputFill;
  final Color cardShadow;

  // ── Text ────────────────────────────────────────────────────────────
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;

  // ── On-Gradient (text/icons on purple gradient backgrounds) ─────────
  final Color onGradient;
  final Color onGradientMuted;

  // ── Bottom Sheet Handle ─────────────────────────────────────────────
  final Color handle;

  // ── Brand (theme-resolved, not static constants) ────────────────────
  final Color cbePurple;
  final Color cbePurpleLight;
  final Color cbeGold;

  // ── Semantic Status ─────────────────────────────────────────────────
  final Color successGreen;
  final Color successGreenLight;
  final Color errorRed;
  final Color errorRedLight;

  const CbeColors({
    required this.background,
    required this.surface,
    required this.surfaceLight,
    required this.divider,
    required this.inputFill,
    required this.cardShadow,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.onGradient,
    required this.onGradientMuted,
    required this.handle,
    required this.cbePurple,
    required this.cbePurpleLight,
    required this.cbeGold,
    required this.successGreen,
    required this.successGreenLight,
    required this.errorRed,
    required this.errorRedLight,
  });

  // ── Light Mode ──────────────────────────────────────────────────────
  static const light = CbeColors(
    background: Color(0xFFF7F7FA),
    surface: Color(0xFFFFFFFF),
    surfaceLight: Color(0xFFF0F0F5),
    divider: Color(0xFFE8E8EE),
    inputFill: Color(0xFFF4F4F8),
    cardShadow: Color(0x0A000000),
    textPrimary: Color(0xFF1A1A2E),
    textSecondary: Color(0xFF5A5A72),
    textMuted: Color(0xFF9090A7),
    onGradient: kOnGradient,
    onGradientMuted: kOnGradientMuted,
    handle: Color(0xFFD0D0D8),
    cbePurple: kCbePurple,
    cbePurpleLight: Color(0xFFEDE4F5),
    cbeGold: kCbeGold,
    successGreen: kSuccessGreen,
    successGreenLight: Color(0xFFE8F5EE),
    errorRed: kErrorRed,
    errorRedLight: Color(0xFFFDECEC),
  );

  // ── Dark Mode ───────────────────────────────────────────────────────
  static const dark = CbeColors(
    background: Color(0xFF101014),
    surface: Color(0xFF1C1C24),
    surfaceLight: Color(0xFF26262F),
    divider: Color(0xFF2E2E3A),
    inputFill: Color(0xFF22222C),
    cardShadow: Color(0x20000000),
    textPrimary: Color(0xFFEEEEF2),
    textSecondary: Color(0xFFB0B0C0),
    textMuted: Color(0xFF7878A0),
    onGradient: kOnGradient,
    onGradientMuted: kOnGradientMuted,
    handle: Color(0xFF48485A),
    cbePurple: kCbePurple,
    cbePurpleLight: Color(0xFF2A1D3D),
    cbeGold: kCbeGold,
    successGreen: kSuccessGreen,
    successGreenLight: Color(0xFF1A2E22),
    errorRed: kErrorRed,
    errorRedLight: Color(0xFF2E1A1A),
  );

  @override
  CbeColors copyWith({
    Color? background,
    Color? surface,
    Color? surfaceLight,
    Color? divider,
    Color? inputFill,
    Color? cardShadow,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? onGradient,
    Color? onGradientMuted,
    Color? handle,
    Color? cbePurple,
    Color? cbePurpleLight,
    Color? cbeGold,
    Color? successGreen,
    Color? successGreenLight,
    Color? errorRed,
    Color? errorRedLight,
  }) {
    return CbeColors(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceLight: surfaceLight ?? this.surfaceLight,
      divider: divider ?? this.divider,
      inputFill: inputFill ?? this.inputFill,
      cardShadow: cardShadow ?? this.cardShadow,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      onGradient: onGradient ?? this.onGradient,
      onGradientMuted: onGradientMuted ?? this.onGradientMuted,
      handle: handle ?? this.handle,
      cbePurple: cbePurple ?? this.cbePurple,
      cbePurpleLight: cbePurpleLight ?? this.cbePurpleLight,
      cbeGold: cbeGold ?? this.cbeGold,
      successGreen: successGreen ?? this.successGreen,
      successGreenLight: successGreenLight ?? this.successGreenLight,
      errorRed: errorRed ?? this.errorRed,
      errorRedLight: errorRedLight ?? this.errorRedLight,
    );
  }

  @override
  CbeColors lerp(ThemeExtension<CbeColors>? other, double t) {
    if (other is! CbeColors) return this;
    return CbeColors(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceLight: Color.lerp(surfaceLight, other.surfaceLight, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      inputFill: Color.lerp(inputFill, other.inputFill, t)!,
      cardShadow: Color.lerp(cardShadow, other.cardShadow, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      onGradient: Color.lerp(onGradient, other.onGradient, t)!,
      onGradientMuted: Color.lerp(onGradientMuted, other.onGradientMuted, t)!,
      handle: Color.lerp(handle, other.handle, t)!,
      cbePurple: Color.lerp(cbePurple, other.cbePurple, t)!,
      cbePurpleLight: Color.lerp(cbePurpleLight, other.cbePurpleLight, t)!,
      cbeGold: Color.lerp(cbeGold, other.cbeGold, t)!,
      successGreen: Color.lerp(successGreen, other.successGreen, t)!,
      successGreenLight: Color.lerp(
        successGreenLight,
        other.successGreenLight,
        t,
      )!,
      errorRed: Color.lerp(errorRed, other.errorRed, t)!,
      errorRedLight: Color.lerp(errorRedLight, other.errorRedLight, t)!,
    );
  }
}

/// Convenience extension to access [CbeColors] from any [BuildContext].
extension CbeColorsExt on BuildContext {
  CbeColors get cbeColors => Theme.of(this).extension<CbeColors>()!;
}
