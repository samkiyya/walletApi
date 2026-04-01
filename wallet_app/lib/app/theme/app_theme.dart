/// {@template app_theme}
/// ThemeData factory for the CBE design system.
///
/// Assembles [CbeColors], [CbeComponentThemes], and [TextTheme] into
/// complete [ThemeData] instances for light and dark modes.
///
/// Widgets never reference this class for colors — they use
/// `context.cbeColors` or `Theme.of(context).colorScheme`.
/// {@endtemplate}
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:wallet_app/app/theme/cbe_colors.dart';
import 'package:wallet_app/app/theme/component_themes.dart';
import 'package:wallet_app/app/theme/design_tokens.dart';

class AppTheme {
  const AppTheme._();

  // ══════════════════════════════════════════════════════════════════════
  // PUBLIC API
  // ══════════════════════════════════════════════════════════════════════

  static ThemeData get lightTheme => _buildTheme(
    brightness: Brightness.light,
    cbeColors: CbeColors.light,
    scaffoldBg: const Color(0xFFF7F7FA),
    surfaceColor: const Color(0xFFFFFFFF),
    onSurfaceColor: const Color(0xFF1A1A2E),
    inputFillColor: const Color(0xFFF4F4F8),
    dividerColor: const Color(0xFFE8E8EE),
    appBarBg: const Color(0xFFFFFFFF),
    appBarFg: const Color(0xFF1A1A2E),
    snackBarBg: const Color(0xFF2D2D3A),
    cardBorderColor: const Color(0xFFE8E8EE),
  );

  static ThemeData get darkTheme => _buildTheme(
    brightness: Brightness.dark,
    cbeColors: CbeColors.dark,
    scaffoldBg: const Color(0xFF101014),
    surfaceColor: const Color(0xFF1C1C24),
    onSurfaceColor: const Color(0xFFEEEEF2),
    inputFillColor: const Color(0xFF22222C),
    dividerColor: const Color(0xFF2E2E3A),
    appBarBg: const Color(0xFF1C1C24),
    appBarFg: const Color(0xFFEEEEF2),
    snackBarBg: const Color(0xFF2A2A34),
    cardBorderColor: const Color(0xFF2E2E3A),
  );

  // ══════════════════════════════════════════════════════════════════════
  // PRIVATE BUILDER
  // ══════════════════════════════════════════════════════════════════════

  static ThemeData _buildTheme({
    required Brightness brightness,
    required CbeColors cbeColors,
    required Color scaffoldBg,
    required Color surfaceColor,
    required Color onSurfaceColor,
    required Color inputFillColor,
    required Color dividerColor,
    required Color appBarBg,
    required Color appBarFg,
    required Color snackBarBg,
    required Color cardBorderColor,
  }) {
    final isDark = brightness == Brightness.dark;
    final textSecondaryColor = isDark
        ? const Color(0xFFB0B0C0)
        : const Color(0xFF5A5A72);
    final textMutedColor = isDark
        ? const Color(0xFF7878A0)
        : const Color(0xFF9090A7);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: scaffoldBg,
      extensions: [cbeColors],

      // ── Color Scheme ──────────────────────────────────────────────
      colorScheme: ColorScheme(
        brightness: brightness,
        surface: surfaceColor,
        onSurface: onSurfaceColor,
        primary: kCbePurple,
        onPrimary: kOnGradient,
        secondary: kCbeGold,
        onSecondary: const Color(0xFF1A1A2E),
        error: kErrorRed,
        onError: kOnGradient,
        surfaceContainerHighest: inputFillColor,
        inverseSurface: snackBarBg,
        onInverseSurface: kOnGradient,
      ),

      // ── Typography ────────────────────────────────────────────────
      textTheme: _textTheme(onSurfaceColor, textSecondaryColor, textMutedColor),

      // ── Components (delegated to CbeComponentThemes) ──────────────
      appBarTheme: CbeComponentThemes.appBar(
        background: appBarBg,
        foreground: appBarFg,
      ),
      cardTheme: CbeComponentThemes.card(
        surface: surfaceColor,
        border: cardBorderColor,
      ),
      elevatedButtonTheme: CbeComponentThemes.elevatedButton(),
      outlinedButtonTheme: CbeComponentThemes.outlinedButton(),
      textButtonTheme: CbeComponentThemes.textButton(),
      iconButtonTheme: CbeComponentThemes.iconButton(
        foreground: onSurfaceColor,
      ),
      iconTheme: IconThemeData(color: onSurfaceColor, size: 24),
      inputDecorationTheme: CbeComponentThemes.inputDecoration(
        fillColor: inputFillColor,
        hintColor: textMutedColor,
      ),
      floatingActionButtonTheme: CbeComponentThemes.fab,
      snackBarTheme: CbeComponentThemes.snackBar(background: snackBarBg),
      bottomSheetTheme: CbeComponentThemes.bottomSheet(surface: surfaceColor),
      dividerTheme: CbeComponentThemes.divider(color: dividerColor),
      listTileTheme: CbeComponentThemes.listTile(
        textColor: onSurfaceColor,
        iconColor: textMutedColor,
      ),
      progressIndicatorTheme: CbeComponentThemes.progressIndicator,
      checkboxTheme: CbeComponentThemes.checkbox(
        surface: surfaceColor,
        border: dividerColor,
      ),
      switchTheme: CbeComponentThemes.switchTheme(
        muted: textMutedColor,
        divider: dividerColor,
      ),
      radioTheme: CbeComponentThemes.radio(muted: textMutedColor),
      chipTheme: CbeComponentThemes.chip(
        surface: surfaceColor,
        border: dividerColor,
        labelColor: onSurfaceColor,
      ),
      tabBarTheme: CbeComponentThemes.tabBar(muted: textMutedColor),
      navigationBarTheme: CbeComponentThemes.navigationBar(
        surface: surfaceColor,
        muted: textMutedColor,
      ),
    );
  }

  // ── Text Theme ──────────────────────────────────────────────────────

  static TextTheme _textTheme(Color primary, Color secondary, Color muted) {
    return GoogleFonts.interTextTheme(
      TextTheme(
        displayLarge: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.w800,
          color: primary,
          letterSpacing: -1.5,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: primary,
          letterSpacing: -0.5,
        ),
        headlineMedium: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: primary,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: primary,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: primary,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: secondary,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: secondary,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: muted,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: primary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
