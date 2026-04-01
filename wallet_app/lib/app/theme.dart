library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  const AppTheme._();

  // ══════════════════════════════════════════════════════════════════
  // 60% — NEUTRAL (Backgrounds, surfaces, cards)
  // ══════════════════════════════════════════════════════════════════
  static const Color background = Color(0xFFF7F7FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceLight = Color(0xFFF0F0F5);
  static const Color divider = Color(0xFFE8E8EE);
  static const Color inputFill = Color(0xFFF4F4F8);

  // ══════════════════════════════════════════════════════════════════
  // 30% — COMPLEMENTARY DARK (Text, icons, strong accents)
  // ══════════════════════════════════════════════════════════════════
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF5A5A72);
  static const Color textMuted = Color(0xFF9090A7);
  static const Color darkSurface = Color(0xFF2D2D3A);

  // ══════════════════════════════════════════════════════════════════
  // 10% — CBE BRAND (Accent, CTA buttons, highlights)
  // ══════════════════════════════════════════════════════════════════
  static const Color cbePurple = Color(0xFF662D91);
  static const Color cbePurpleDark = Color(0xFF4A1D6B);
  static const Color cbePurpleLight = Color(0xFFEDE4F5);
  static const Color cbeGold = Color(0xFFD4A843);

  // ══════════════════════════════════════════════════════════════════
  // SEMANTIC COLORS
  // ══════════════════════════════════════════════════════════════════
  static const Color successGreen = Color(0xFF2E7D51);
  static const Color successGreenLight = Color(0xFFE8F5EE);
  static const Color errorRed = Color(0xFFD32F2F);
  static const Color errorRedLight = Color(0xFFFDECEC);
  static const Color warningAmber = Color(0xFFF9A825);
  static const Color infoPurple = Color(0xFF7B61FF);

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
  // THEME DATA
  // ══════════════════════════════════════════════════════════════════
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.light(
        surface: surface,
        primary: cbePurple,
        secondary: cbeGold,
        error: errorRed,
        onPrimary: Colors.white,
        onSurface: textPrimary,
        onError: Colors.white,
      ),
      textTheme: GoogleFonts.interTextTheme(
        const TextTheme(
          displayLarge: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w800,
            color: textPrimary,
            letterSpacing: -1.5,
          ),
          displayMedium: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: textPrimary,
            letterSpacing: -0.5,
          ),
          headlineMedium: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: textPrimary,
          ),
          titleLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: textPrimary,
          ),
          titleMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: textPrimary,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: textSecondary,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: textSecondary,
          ),
          bodySmall: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: textMuted,
          ),
          labelLarge: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: textPrimary,
            letterSpacing: 0.5,
          ),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        iconTheme: const IconThemeData(color: textPrimary),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: divider.withValues(alpha: 0.8)),
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
        fillColor: inputFill,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
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
        labelStyle: GoogleFonts.inter(color: textMuted, fontSize: 14),
        hintStyle: GoogleFonts.inter(color: textMuted, fontSize: 14),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: cbePurple,
        foregroundColor: Colors.white,
        elevation: 3,
        shape: CircleBorder(),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: darkSurface,
        contentTextStyle: GoogleFonts.inter(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
      dividerTheme: const DividerThemeData(color: divider, thickness: 1),
    );
  }
}
