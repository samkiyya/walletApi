/// {@template component_themes}
/// Component-level theme definitions for the CBE design system.
///
/// Encapsulates all Material component theme overrides in one place.
/// Called by [AppTheme._buildTheme] to produce the final [ThemeData].
///
/// Adding a new component theme? Add a static method here and
/// wire it up in [AppTheme._buildTheme].
/// {@endtemplate}
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:wallet_app/app/theme/design_tokens.dart';

/// Factory methods that produce component-level theme objects.
///
/// Every method is `static` and takes only the parameters it needs,
/// keeping the API narrow and testable.
class CbeComponentThemes {
  const CbeComponentThemes._();

  // ── AppBar ──────────────────────────────────────────────────────────
  static AppBarTheme appBar({
    required Color background,
    required Color foreground,
  }) {
    return AppBarTheme(
      backgroundColor: background,
      elevation: 0,
      scrolledUnderElevation: 0.5,
      surfaceTintColor: background,
      centerTitle: true,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: foreground,
      ),
      iconTheme: IconThemeData(color: foreground),
      actionsIconTheme: IconThemeData(color: foreground),
    );
  }

  // ── Card ────────────────────────────────────────────────────────────
  static CardThemeData card({required Color surface, required Color border}) {
    return CardThemeData(
      color: surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: border.withValues(alpha: 0.8)),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }

  // ── Elevated Button ─────────────────────────────────────────────────
  static ElevatedButtonThemeData elevatedButton() {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: kCbePurple,
        foregroundColor: kOnGradient,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700),
        elevation: 0,
      ),
    );
  }

  // ── Outlined Button ─────────────────────────────────────────────────
  static OutlinedButtonThemeData outlinedButton() {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: kCbePurple,
        side: const BorderSide(color: kCbePurple, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    );
  }

  // ── Text Button ─────────────────────────────────────────────────────
  static TextButtonThemeData textButton() {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: kCbePurple,
        textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    );
  }

  // ── Icon Button ─────────────────────────────────────────────────────
  static IconButtonThemeData iconButton({required Color foreground}) {
    return IconButtonThemeData(
      style: IconButton.styleFrom(foregroundColor: foreground),
    );
  }

  // ── Input Decoration ────────────────────────────────────────────────
  static InputDecorationTheme inputDecoration({
    required Color fillColor,
    required Color hintColor,
  }) {
    return InputDecorationTheme(
      filled: true,
      fillColor: fillColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: kCbePurple, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: kErrorRed, width: 1.5),
      ),
      labelStyle: GoogleFonts.inter(color: hintColor, fontSize: 14),
      hintStyle: GoogleFonts.inter(color: hintColor, fontSize: 14),
    );
  }

  // ── FAB ─────────────────────────────────────────────────────────────
  static const FloatingActionButtonThemeData fab =
      FloatingActionButtonThemeData(
        backgroundColor: kCbePurple,
        foregroundColor: kOnGradient,
        elevation: 3,
        shape: CircleBorder(),
      );

  // ── SnackBar ────────────────────────────────────────────────────────
  static SnackBarThemeData snackBar({required Color background}) {
    return SnackBarThemeData(
      backgroundColor: background,
      contentTextStyle: GoogleFonts.inter(
        color: kOnGradient,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      behavior: SnackBarBehavior.floating,
    );
  }

  // ── Bottom Sheet ────────────────────────────────────────────────────
  static BottomSheetThemeData bottomSheet({required Color surface}) {
    return BottomSheetThemeData(
      backgroundColor: surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
    );
  }

  // ── Divider ─────────────────────────────────────────────────────────
  static DividerThemeData divider({required Color color}) {
    return DividerThemeData(color: color, thickness: 1);
  }

  // ── List Tile ───────────────────────────────────────────────────────
  static ListTileThemeData listTile({
    required Color textColor,
    required Color iconColor,
  }) {
    return ListTileThemeData(
      textColor: textColor,
      iconColor: iconColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }

  // ── Progress Indicator ──────────────────────────────────────────────
  static const ProgressIndicatorThemeData progressIndicator =
      ProgressIndicatorThemeData(color: kCbePurple);

  // ── Checkbox ────────────────────────────────────────────────────────
  static CheckboxThemeData checkbox({
    required Color surface,
    required Color border,
  }) {
    return CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return kCbePurple;
        return surface;
      }),
      checkColor: WidgetStateProperty.all(kOnGradient),
      side: BorderSide(color: border, width: 1.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    );
  }

  // ── Switch ──────────────────────────────────────────────────────────
  static SwitchThemeData switchTheme({
    required Color muted,
    required Color divider,
  }) {
    return SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return kOnGradient;
        return muted;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return kCbePurple;
        return divider;
      }),
    );
  }

  // ── Radio ───────────────────────────────────────────────────────────
  static RadioThemeData radio({required Color muted}) {
    return RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return kCbePurple;
        return muted;
      }),
    );
  }

  // ── Chip ────────────────────────────────────────────────────────────
  static ChipThemeData chip({
    required Color surface,
    required Color border,
    required Color labelColor,
  }) {
    return ChipThemeData(
      backgroundColor: surface,
      selectedColor: kCbePurple,
      labelStyle: GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: labelColor,
      ),
      side: BorderSide(color: border),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  // ── Tab Bar ─────────────────────────────────────────────────────────
  static TabBarThemeData tabBar({required Color muted}) {
    return TabBarThemeData(
      labelColor: kCbePurple,
      unselectedLabelColor: muted,
      indicatorColor: kCbePurple,
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  // ── Navigation Bar ──────────────────────────────────────────────────
  static NavigationBarThemeData navigationBar({
    required Color surface,
    required Color muted,
  }) {
    return NavigationBarThemeData(
      backgroundColor: surface,
      indicatorColor: kCbePurple.withValues(alpha: 0.15),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: kCbePurple);
        }
        return IconThemeData(color: muted);
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: kCbePurple,
          );
        }
        return GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: muted,
        );
      }),
    );
  }
}
