/// {@template app_theme}
/// CBE (Commercial Bank of Ethiopia) branded design system.
///
/// Follows the **60/30/10 design rule**:
/// - **60% Neutral** — White, light gray, soft backgrounds
/// - **30% Complementary** — Dark tones (deep charcoal, black text)
/// - **10% Brand** — CBE Purple (#662D91) as the signature accent
///
/// Architecture:
/// - [CbeColors] — ThemeExtension carrying ALL semantic tokens
/// - [AppTheme] — Factory that builds [ThemeData] with full component coverage
///
/// **Design System Contract**:
/// No widget may use raw `Colors.xxx` or reference `AppTheme` statics.
/// All color access must go through:
/// - `Theme.of(context).colorScheme.*`
/// - `context.cbeColors.*`
/// - Component themes (TextTheme, IconTheme, etc.)
///
/// Supports both Light and Dark modes with consistent branding.
/// Typography: Google Fonts Inter for modern, clean readability.
/// {@endtemplate}
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ══════════════════════════════════════════════════════════════════════════
// DESIGN TOKENS — Private constants, never exported to widgets
// ══════════════════════════════════════════════════════════════════════════

// Brand
const _cbePurple = Color(0xFF662D91);
const _cbePurpleDark = Color(0xFF4A1D6B);
const _cbeGold = Color(0xFFD4A843);

// Semantic
const _successGreen = Color(0xFF2E7D51);
const _errorRed = Color(0xFFD32F2F);
const _warningAmber = Color(0xFFF9A825);

// On-gradient (text/icons placed on purple gradient backgrounds)
const _onGradient = Color(0xFFFFFFFF);
const _onGradientMuted = Color(0xB3FFFFFF); // 70% white

// ══════════════════════════════════════════════════════════════════════════
// CbeColors — ThemeExtension carrying ALL semantic design tokens
// ══════════════════════════════════════════════════════════════════════════

/// Carries CBE-specific semantic colors that vary between light and dark mode.
///
/// Access via `context.cbeColors` (convenience extension) or
/// `Theme.of(context).extension<CbeColors>()!`.
///
/// This is the **single source of truth** for all colors in the UI layer.
/// Widgets must NEVER use raw `Color(...)` or `Colors.xxx` directly.
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

  // ── Light Mode Palette ──────────────────────────────────────────────
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
    onGradient: _onGradient,
    onGradientMuted: _onGradientMuted,
    handle: Color(0xFFD0D0D8),
    cbePurple: _cbePurple,
    cbePurpleLight: Color(0xFFEDE4F5),
    cbeGold: _cbeGold,
    successGreen: _successGreen,
    successGreenLight: Color(0xFFE8F5EE),
    errorRed: _errorRed,
    errorRedLight: Color(0xFFFDECEC),
  );

  // ── Dark Mode Palette ───────────────────────────────────────────────
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
    onGradient: _onGradient,
    onGradientMuted: _onGradientMuted,
    handle: Color(0xFF48485A),
    cbePurple: _cbePurple,
    cbePurpleLight: Color(0xFF2A1D3D),
    cbeGold: _cbeGold,
    successGreen: _successGreen,
    successGreenLight: Color(0xFF1A2E22),
    errorRed: _errorRed,
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
      onGradientMuted:
          Color.lerp(onGradientMuted, other.onGradientMuted, t)!,
      handle: Color.lerp(handle, other.handle, t)!,
      cbePurple: Color.lerp(cbePurple, other.cbePurple, t)!,
      cbePurpleLight: Color.lerp(cbePurpleLight, other.cbePurpleLight, t)!,
      cbeGold: Color.lerp(cbeGold, other.cbeGold, t)!,
      successGreen: Color.lerp(successGreen, other.successGreen, t)!,
      successGreenLight:
          Color.lerp(successGreenLight, other.successGreenLight, t)!,
      errorRed: Color.lerp(errorRed, other.errorRed, t)!,
      errorRedLight: Color.lerp(errorRedLight, other.errorRedLight, t)!,
    );
  }
}

/// Convenience extension to access [CbeColors] from any [BuildContext].
extension CbeColorsExt on BuildContext {
  CbeColors get cbeColors => Theme.of(this).extension<CbeColors>()!;
}

// ══════════════════════════════════════════════════════════════════════════
// AppTheme — ThemeData factory (GRADIENTS + BUILDER)
//
// Widgets should NEVER reference AppTheme color statics.
// They may reference gradient constants for BoxDecoration usage only.
// ══════════════════════════════════════════════════════════════════════════

class AppTheme {
  const AppTheme._();

  // ── Gradients (decoration data — OK to reference in widgets) ────────
  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [_cbePurple, _cbePurpleDark],
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
    colors: [_cbePurple, Color(0xFF9C27B0)],
  );

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [_cbePurple, _cbePurpleDark, Color(0xFF371555)],
  );

  // ══════════════════════════════════════════════════════════════════════
  // LIGHT THEME
  // ══════════════════════════════════════════════════════════════════════
  static ThemeData get lightTheme {
    return _buildTheme(
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
  }

  // ══════════════════════════════════════════════════════════════════════
  // DARK THEME
  // ══════════════════════════════════════════════════════════════════════
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

  // ══════════════════════════════════════════════════════════════════════
  // SHARED THEME BUILDER — Full component coverage
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
    final textSecondaryColor =
        isDark ? const Color(0xFFB0B0C0) : const Color(0xFF5A5A72);
    final textMutedColor =
        isDark ? const Color(0xFF7878A0) : const Color(0xFF9090A7);

    final colorScheme = ColorScheme(
      brightness: brightness,
      surface: surfaceColor,
      onSurface: onSurfaceColor,
      primary: _cbePurple,
      onPrimary: _onGradient,
      secondary: _cbeGold,
      onSecondary: const Color(0xFF1A1A2E),
      error: _errorRed,
      onError: _onGradient,
      surfaceContainerHighest: inputFillColor,
      inverseSurface: snackBarBg,
      onInverseSurface: _onGradient,
    );

    final textTheme = GoogleFonts.interTextTheme(
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
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: scaffoldBg,
      extensions: [cbeColors],
      colorScheme: colorScheme,
      textTheme: textTheme,

      // ── AppBar ──────────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: appBarBg,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        surfaceTintColor: surfaceColor,
        centerTitle: true,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: appBarFg,
        ),
        iconTheme: IconThemeData(color: appBarFg),
        actionsIconTheme: IconThemeData(color: appBarFg),
      ),

      // ── Card ────────────────────────────────────────────────────────
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: cardBorderColor.withValues(alpha: 0.8)),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),

      // ── Elevated Button ─────────────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _cbePurple,
          foregroundColor: _onGradient,
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

      // ── Outlined Button ─────────────────────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _cbePurple,
          side: const BorderSide(color: _cbePurple, width: 1.5),
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

      // ── Text Button ─────────────────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _cbePurple,
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ── Icon Button ─────────────────────────────────────────────────
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: onSurfaceColor,
        ),
      ),

      // ── Icon Theme (global) ─────────────────────────────────────────
      iconTheme: IconThemeData(
        color: onSurfaceColor,
        size: 24,
      ),

      // ── Input Decoration ────────────────────────────────────────────
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
          borderSide: const BorderSide(color: _cbePurple, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _errorRed, width: 1.5),
        ),
        labelStyle: GoogleFonts.inter(color: textMutedColor, fontSize: 14),
        hintStyle: GoogleFonts.inter(color: textMutedColor, fontSize: 14),
      ),

      // ── FAB ─────────────────────────────────────────────────────────
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _cbePurple,
        foregroundColor: _onGradient,
        elevation: 3,
        shape: CircleBorder(),
      ),

      // ── SnackBar ────────────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: snackBarBg,
        contentTextStyle: GoogleFonts.inter(
          color: _onGradient,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),

      // ── Bottom Sheet ────────────────────────────────────────────────
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surfaceColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),

      // ── Divider ─────────────────────────────────────────────────────
      dividerTheme: DividerThemeData(
        color: dividerColor,
        thickness: 1,
      ),

      // ── List Tile ───────────────────────────────────────────────────
      listTileTheme: ListTileThemeData(
        textColor: onSurfaceColor,
        iconColor: textMutedColor,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),

      // ── Progress Indicator ──────────────────────────────────────────
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: _cbePurple,
      ),

      // ── Checkbox ────────────────────────────────────────────────────
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return _cbePurple;
          return surfaceColor;
        }),
        checkColor: WidgetStateProperty.all(_onGradient),
        side: BorderSide(color: dividerColor, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),

      // ── Switch ──────────────────────────────────────────────────────
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return _onGradient;
          return textMutedColor;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return _cbePurple;
          return dividerColor;
        }),
      ),

      // ── Radio ───────────────────────────────────────────────────────
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return _cbePurple;
          return textMutedColor;
        }),
      ),

      // ── Chip ────────────────────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: surfaceColor,
        selectedColor: _cbePurple,
        labelStyle: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: onSurfaceColor,
        ),
        side: BorderSide(color: dividerColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),

      // ── Tab Bar ─────────────────────────────────────────────────────
      tabBarTheme: TabBarThemeData(
        labelColor: _cbePurple,
        unselectedLabelColor: textMutedColor,
        indicatorColor: _cbePurple,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),

      // ── Navigation Bar ──────────────────────────────────────────────
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surfaceColor,
        indicatorColor: _cbePurple.withValues(alpha: 0.15),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: _cbePurple);
          }
          return IconThemeData(color: textMutedColor);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _cbePurple,
            );
          }
          return GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: textMutedColor,
          );
        }),
      ),
    );
  }
}
