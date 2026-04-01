/// {@template app_theme}
/// CBE (Commercial Bank of Ethiopia) branded theme system.
///
/// Follows the **60/30/10 design rule**:
/// - **60% Neutral** — White, light gray, soft backgrounds
/// - **30% Complementary** — Dark tones (deep charcoal, black text)
/// - **10% Brand** — CBE Purple (#662D91) as the signature accent
///
/// Supports both Light and Dark modes with consistent branding.
/// Typography: Google Fonts Inter for modern, clean readability.
/// {@endtemplate}
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ══════════════════════════════════════════════════════════════════════
// CbeColors — ThemeExtension for CBE-specific semantic colors
// ══════════════════════════════════════════════════════════════════════

/// Carries CBE-specific colors that vary between light and dark mode.
/// Access via `Theme.of(context).extension<CbeColors>()!`.
class CbeColors extends ThemeExtension<CbeColors> {
  final Color background;
  final Color surface;
  final Color surfaceLight;
  final Color divider;
  final Color inputFill;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color cbePurpleLight;
  final Color successGreenLight;
  final Color errorRedLight;
  final Color cardShadow;

  const CbeColors({
    required this.background,
    required this.surface,
    required this.surfaceLight,
    required this.divider,
    required this.inputFill,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.cbePurpleLight,
    required this.successGreenLight,
    required this.errorRedLight,
    required this.cardShadow,
  });

  // ── Light Mode Palette ──────────────────────────────────────────
  static const light = CbeColors(
    background: Color(0xFFF7F7FA),
    surface: Color(0xFFFFFFFF),
    surfaceLight: Color(0xFFF0F0F5),
    divider: Color(0xFFE8E8EE),
    inputFill: Color(0xFFF4F4F8),
    textPrimary: Color(0xFF1A1A2E),
    textSecondary: Color(0xFF5A5A72),
    textMuted: Color(0xFF9090A7),
    cbePurpleLight: Color(0xFFEDE4F5),
    successGreenLight: Color(0xFFE8F5EE),
    errorRedLight: Color(0xFFFDECEC),
    cardShadow: Color(0x0A000000),
  );

  // ── Dark Mode Palette ───────────────────────────────────────────
  static const dark = CbeColors(
    background: Color(0xFF101014),
    surface: Color(0xFF1C1C24),
    surfaceLight: Color(0xFF26262F),
    divider: Color(0xFF2E2E3A),
    inputFill: Color(0xFF22222C),
    textPrimary: Color(0xFFEEEEF2),
    textSecondary: Color(0xFFB0B0C0),
    textMuted: Color(0xFF7878A0),
    cbePurpleLight: Color(0xFF2A1D3D),
    successGreenLight: Color(0xFF1A2E22),
    errorRedLight: Color(0xFF2E1A1A),
    cardShadow: Color(0x20000000),
  );

  @override
  CbeColors copyWith({
    Color? background,
    Color? surface,
    Color? surfaceLight,
    Color? divider,
    Color? inputFill,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? cbePurpleLight,
    Color? successGreenLight,
    Color? errorRedLight,
    Color? cardShadow,
  }) {
    return CbeColors(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceLight: surfaceLight ?? this.surfaceLight,
      divider: divider ?? this.divider,
      inputFill: inputFill ?? this.inputFill,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      cbePurpleLight: cbePurpleLight ?? this.cbePurpleLight,
      successGreenLight: successGreenLight ?? this.successGreenLight,
      errorRedLight: errorRedLight ?? this.errorRedLight,
      cardShadow: cardShadow ?? this.cardShadow,
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
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      cbePurpleLight: Color.lerp(cbePurpleLight, other.cbePurpleLight, t)!,
      successGreenLight:
          Color.lerp(successGreenLight, other.successGreenLight, t)!,
      errorRedLight: Color.lerp(errorRedLight, other.errorRedLight, t)!,
      cardShadow: Color.lerp(cardShadow, other.cardShadow, t)!,
    );
  }
}

/// Convenience extension to access CbeColors from any context.
extension CbeColorsExt on BuildContext {
  CbeColors get cbeColors => Theme.of(this).extension<CbeColors>()!;
}

class AppTheme {
  const AppTheme._();

  // ══════════════════════════════════════════════════════════════════
  // 60% — NEUTRAL (Backgrounds, surfaces, cards)
  // ══════════════════════════════════════════════════════════════════
  static const Color background = Color(0xFFF7F7FA);       // Soft off-white
  static const Color surface = Color(0xFFFFFFFF);           // Pure white cards
  static const Color surfaceLight = Color(0xFFF0F0F5);     // Light gray fills
  static const Color divider = Color(0xFFE8E8EE);          // Subtle dividers
  static const Color inputFill = Color(0xFFF4F4F8);        // Input backgrounds

  // ══════════════════════════════════════════════════════════════════
  // 30% — COMPLEMENTARY DARK (Text, icons, strong accents)
  // ══════════════════════════════════════════════════════════════════
  static const Color textPrimary = Color(0xFF1A1A2E);      // Near-black
  static const Color textSecondary = Color(0xFF5A5A72);    // Medium gray
  static const Color textMuted = Color(0xFF9090A7);        // Light gray text
  static const Color darkSurface = Color(0xFF2D2D3A);      // Deep charcoal

  // ══════════════════════════════════════════════════════════════════
  // 10% — CBE BRAND (Accent, CTA buttons, highlights)
  // ══════════════════════════════════════════════════════════════════
  static const Color cbePurple = Color(0xFF662D91);        // CBE primary purple
  static const Color cbePurpleDark = Color(0xFF4A1D6B);    // Pressed/dark variant
  static const Color cbePurpleLight = Color(0xFFEDE4F5);   // Light purple tint
  static const Color cbeGold = Color(0xFFD4A843);          // CBE gold accent

  // ══════════════════════════════════════════════════════════════════
  // SEMANTIC COLORS
  // ══════════════════════════════════════════════════════════════════
  static const Color successGreen = Color(0xFF2E7D51);     // Deposits/income
  static const Color successGreenLight = Color(0xFFE8F5EE);
  static const Color errorRed = Color(0xFFD32F2F);         // Withdrawals/errors
  static const Color errorRedLight = Color(0xFFFDECEC);
  static const Color warningAmber = Color(0xFFF9A825);
  static const Color infoPurple = Color(0xFF7B61FF);       // Transfers

  // ══════════════════════════════════════════════════════════════════
  // GRADIENTS
  // ══════════════════════════════════════════════════════════════════
  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF662D91), Color(0xFF4A1D6B)],
  );

  static const LinearGradient depositGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2E7D51), Color(0xFF43A66E)],
  );

  static const LinearGradient withdrawGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFD32F2F), Color(0xFFEF5350)],
  );

  static const LinearGradient transferGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF662D91), Color(0xFF9C27B0)],
  );

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF662D91), Color(0xFF4A1D6B), Color(0xFF371555)],
  );

  // ══════════════════════════════════════════════════════════════════
  // LIGHT THEME
  // ══════════════════════════════════════════════════════════════════
  static ThemeData get lightTheme {
    return _buildTheme(
      brightness: Brightness.light,
      cbeColors: CbeColors.light,
      scaffoldBg: background,
      surfaceColor: surface,
      onSurfaceColor: textPrimary,
      inputFillColor: inputFill,
      dividerColor: divider,
      appBarBg: surface,
      appBarFg: textPrimary,
      snackBarBg: darkSurface,
      cardBorderColor: divider,
    );
  }

  // ══════════════════════════════════════════════════════════════════
  // DARK THEME
  // ══════════════════════════════════════════════════════════════════
  static ThemeData get darkTheme {
    return _buildTheme(
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
  }

  // ══════════════════════════════════════════════════════════════════
  // SHARED THEME BUILDER
  // ══════════════════════════════════════════════════════════════════
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
    final textSecondaryColor =
        isDark ? const Color(0xFFB0B0C0) : textSecondary;
    final textMutedColor = isDark ? const Color(0xFF7878A0) : textMuted;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: scaffoldBg,
      extensions: [cbeColors],
      colorScheme: ColorScheme(
        brightness: brightness,
        surface: surfaceColor,
        onSurface: onSurfaceColor,
        primary: cbePurple,
        onPrimary: Colors.white,
        secondary: cbeGold,
        onSecondary: Colors.black,
        error: errorRed,
        onError: Colors.white,
        surfaceContainerHighest: inputFillColor,
      ),
      textTheme: GoogleFonts.interTextTheme(
        TextTheme(
          displayLarge: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w800,
            color: onSurfaceColor,
            letterSpacing: -1.5,
          ),
          displayMedium: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: onSurfaceColor,
            letterSpacing: -0.5,
          ),
          headlineMedium: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: onSurfaceColor,
          ),
          titleLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: onSurfaceColor,
          ),
          titleMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: onSurfaceColor,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: textSecondaryColor,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: textSecondaryColor,
          ),
          bodySmall: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: textMutedColor,
          ),
          labelLarge: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: onSurfaceColor,
            letterSpacing: 0.5,
          ),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: appBarBg,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: appBarFg,
        ),
        iconTheme: IconThemeData(color: appBarFg),
      ),
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: cardBorderColor.withValues(alpha: 0.8)),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: cbePurple,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: cbePurple,
          side: const BorderSide(color: cbePurple, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: inputFillColor,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: cbePurple, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: errorRed, width: 1.5),
        ),
        labelStyle: GoogleFonts.inter(color: textMutedColor, fontSize: 14),
        hintStyle: GoogleFonts.inter(color: textMutedColor, fontSize: 14),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: cbePurple,
        foregroundColor: Colors.white,
        elevation: 3,
        shape: CircleBorder(),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: snackBarBg,
        contentTextStyle: GoogleFonts.inter(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surfaceColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: dividerColor,
        thickness: 1,
      ),
    );
  }
}
