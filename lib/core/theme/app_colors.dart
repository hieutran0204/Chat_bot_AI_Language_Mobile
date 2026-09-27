// name: app_colors.dart
// description: Centralized design system color palette and token definitions.
//              Provides primary, background, text, semantic, chat, and gradient tokens.

import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Primary Brand Palette ─────────────────────────────────
  static const Color primary        = Color(0xFF6C63FF); // indigo-purple
  static const Color primaryLight   = Color(0xFF9D97FF); // light violet
  static const Color primaryDark    = Color(0xFF4A42D6); // deep indigo
  static const Color primaryAccent  = Color(0xFF8B5CF6); // vivid purple

  // ── Secondary / AI Accents ────────────────────────────────
  static const Color secondary      = Color(0xFF06B6D4); // vibrant cyan (voice & AI)
  static const Color secondaryLight = Color(0xFF67E8F9); // soft cyan
  static const Color accentPink     = Color(0xFFEC4899); // energy pink
  static const Color accentAmber    = Color(0xFFF59E0B); // streak / trophy gold

  // ── Background Surfaces (Dark Mode) ───────────────────────
  static const Color bgDark         = Color(0xFF0D0E1A); // base canvas (near-black)
  static const Color bgSurface      = Color(0xFF13152B); // standard card surface
  static const Color bgElevated     = Color(0xFF1C1F3A); // text fields, dropdowns
  static const Color bgCardHover    = Color(0xFF23274A); // hover / highlighted card
  static const Color bgGlass        = Color(0x331C1F3A); // translucent glassmorphism

  // ── Typography Tokens ─────────────────────────────────────
  static const Color textPrimary    = Color(0xFFF0F0FF); // high emphasis
  static const Color textSecondary  = Color(0xFF8A8DB8); // medium emphasis
  static const Color textMuted      = Color(0xFF64689A); // low emphasis
  static const Color textHint       = Color(0xFF4E5179); // placeholder / inactive

  // ── Semantic & Status Colors ──────────────────────────────
  static const Color success        = Color(0xFF4ADE80); // green: correct grammar, passed
  static const Color successLight   = Color(0xFF86EFAC);
  static const Color successBg      = Color(0x1F4ADE80); // 12% alpha background
  
  static const Color warning        = Color(0xFFFBBF24); // amber: minor weakness
  static const Color warningLight   = Color(0xFFFDE68A);
  static const Color warningBg      = Color(0x1FFBBF24);

  static const Color error          = Color(0xFFF87171); // red: grammar mistake, fail
  static const Color errorLight     = Color(0xFFFCA5A5);
  static const Color errorBg        = Color(0x1FF87171);

  static const Color info           = Color(0xFF38BDF8); // sky blue: tip, hint, note
  static const Color infoBg         = Color(0x1F38BDF8);

  // ── Borders & Dividers ────────────────────────────────────
  static const Color border         = Color(0xFF252849);
  static const Color borderLight    = Color(0xFF333765);
  static const Color borderFocus    = Color(0xFF6C63FF);
  static const Color divider        = Color(0xFF1E2040);

  // ── Chat & Tutor Specific Tokens ──────────────────────────
  static const Color userBubble     = Color(0xFF4A42D6); // user message container
  static const Color aiBubble       = Color(0xFF1A1C35); // AI message container
  static const Color correctionChip = Color(0x2BEE5253); // error highlight chip
  static const Color highlightChip  = Color(0x2B10AC84); // improvement highlight

  // ── Gradients ─────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6C63FF), Color(0xFF4A42D6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF8B5CF6), Color(0xFF06B6D4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient bgGradient = LinearGradient(
    colors: [Color(0xFF0D0E1A), Color(0xFF13152B)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF161833), Color(0xFF111326)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient voicePulseGradient = LinearGradient(
    colors: [Color(0xFF6C63FF), Color(0xFF06B6D4), Color(0xFFEC4899)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
