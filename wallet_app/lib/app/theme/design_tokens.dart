/// {@template design_tokens}
/// Private design tokens for the CBE design system.
///
/// Contains all raw color values, gradients, and spacing constants.
/// **These are NEVER imported by widgets directly** — they feed into
/// [CbeColors] and [AppTheme] which provide the public API.
///
/// Follows the **60/30/10 design rule**:
/// - **60% Neutral** — Whites, grays, soft backgrounds
/// - **30% Complementary** — Dark tones (charcoal, near-black text)
/// - **10% Brand** — CBE Purple (#662D91) as the signature accent
/// {@endtemplate}
library;

import 'package:flutter/material.dart';

// ══════════════════════════════════════════════════════════════════════════
// BRAND COLORS
// ══════════════════════════════════════════════════════════════════════════

const kCbePurple = Color(0xFF662D91);
const kCbePurpleDark = Color(0xFF4A1D6B);
const kCbeGold = Color(0xFFD4A843);

// ══════════════════════════════════════════════════════════════════════════
// SEMANTIC COLORS
// ══════════════════════════════════════════════════════════════════════════

const kSuccessGreen = Color(0xFF2E7D51);
const kErrorRed = Color(0xFFD32F2F);

// ══════════════════════════════════════════════════════════════════════════
// ON-GRADIENT (text/icons placed on purple gradient backgrounds)
// ══════════════════════════════════════════════════════════════════════════

const kOnGradient = Color(0xFFFFFFFF);
const kOnGradientMuted = Color(0xB3FFFFFF); // 70% white

// ══════════════════════════════════════════════════════════════════════════
// GRADIENTS
// ══════════════════════════════════════════════════════════════════════════

const kCardGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [kCbePurple, kCbePurpleDark],
);

const kDepositGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFF2E7D51), Color(0xFF43A66E)],
);

const kWithdrawGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFD32F2F), Color(0xFFEF5350)],
);

const kTransferGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [kCbePurple, Color(0xFF9C27B0)],
);

const kHeroGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [kCbePurple, kCbePurpleDark, Color(0xFF371555)],
);
