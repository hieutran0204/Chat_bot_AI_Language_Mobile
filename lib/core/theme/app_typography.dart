// name: app_typography.dart
// description: Centralized typography system based on Inter Google Font.
//              Provides scalable display, headline, title, body, and label text styles.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTypography {
  AppTypography._();

  // ── Font Family ───────────────────────────────────────────
  static const String fontFamily = 'Inter';

  // ── Display Styles (Hero, Large titles) ────────────────────
  static TextStyle get displayLarge => GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 1.25,
        letterSpacing: -0.8,
        color: AppColors.textPrimary,
      );

  static TextStyle get displayMedium => GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        height: 1.28,
        letterSpacing: -0.6,
        color: AppColors.textPrimary,
      );

  static TextStyle get displaySmall => GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.33,
        letterSpacing: -0.4,
        color: AppColors.textPrimary,
      );

  // ── Headline Styles (Section headers, dialog titles) ──────
  static TextStyle get headlineLarge => GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        height: 1.36,
        letterSpacing: -0.3,
        color: AppColors.textPrimary,
      );

  static TextStyle get headlineMedium => GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.4,
        letterSpacing: -0.2,
        color: AppColors.textPrimary,
      );

  static TextStyle get headlineSmall => GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.44,
        color: AppColors.textPrimary,
      );

  // ── Title Styles (Card titles, list headers) ───────────────
  static TextStyle get titleLarge => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.5,
        color: AppColors.textPrimary,
      );

  static TextStyle get titleMedium => GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        height: 1.46,
        color: AppColors.textPrimary,
      );

  static TextStyle get titleSmall => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.42,
        color: AppColors.textSecondary,
      );

  // ── Body Styles (Paragraphs, descriptions, messages) ───────
  static TextStyle get bodyLarge => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: AppColors.textPrimary,
      );

  static TextStyle get bodyMedium => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.45,
        color: AppColors.textSecondary,
      );

  static TextStyle get bodySmall => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.4,
        color: AppColors.textMuted,
      );

  // ── Label Styles (Buttons, chips, badges, tabs) ───────────
  static TextStyle get labelLarge => GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        color: AppColors.textPrimary,
      );

  static TextStyle get labelMedium => GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.2,
        color: AppColors.textSecondary,
      );

  static TextStyle get labelSmall => GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.3,
        color: AppColors.textMuted,
      );

  // ── Domain-Specific AI Tutor Typography ───────────────────
  static TextStyle get chatUser => GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 1.45,
        color: Colors.white,
      );

  static TextStyle get chatAi => GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 1.55,
        color: AppColors.textPrimary,
      );

  static TextStyle get correctionMistake => GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        decoration: TextDecoration.lineThrough,
        decorationColor: AppColors.error,
        color: AppColors.errorLight,
      );

  static TextStyle get correctionFixed => GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.success,
      );

  static TextStyle get phoneticIpa => GoogleFonts.inter(
        fontSize: 13,
        fontStyle: FontStyle.italic,
        color: AppColors.textSecondary,
      );

  // ── TextTheme for MaterialApp ─────────────────────────────
  static TextTheme get textTheme => TextTheme(
        displayLarge: displayLarge,
        displayMedium: displayMedium,
        displaySmall: displaySmall,
        headlineLarge: headlineLarge,
        headlineMedium: headlineMedium,
        headlineSmall: headlineSmall,
        titleLarge: titleLarge,
        titleMedium: titleMedium,
        titleSmall: titleSmall,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        bodySmall: bodySmall,
        labelLarge: labelLarge,
        labelMedium: labelMedium,
        labelSmall: labelSmall,
      );
}

// ─────────────────────────────────────────────────────────────
// Extensions for easy modifier chaining
// ─────────────────────────────────────────────────────────────
extension AppTextStyleX on TextStyle {
  TextStyle withColor(Color color) => copyWith(color: color);
  TextStyle get bold => copyWith(fontWeight: FontWeight.w700);
  TextStyle get semiBold => copyWith(fontWeight: FontWeight.w600);
  TextStyle get medium => copyWith(fontWeight: FontWeight.w500);
  TextStyle get regular => copyWith(fontWeight: FontWeight.w400);
  TextStyle get light => copyWith(fontWeight: FontWeight.w300);
  TextStyle get italic => copyWith(fontStyle: FontStyle.italic);
  TextStyle get lineThrough => copyWith(decoration: TextDecoration.lineThrough);
  TextStyle get underline => copyWith(decoration: TextDecoration.underline);
}

extension AppTypographyContextX on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;
  TextStyle get displayLarge => AppTypography.displayLarge;
  TextStyle get displayMedium => AppTypography.displayMedium;
  TextStyle get headlineMedium => AppTypography.headlineMedium;
  TextStyle get titleLarge => AppTypography.titleLarge;
  TextStyle get titleMedium => AppTypography.titleMedium;
  TextStyle get bodyLarge => AppTypography.bodyLarge;
  TextStyle get bodyMedium => AppTypography.bodyMedium;
  TextStyle get bodySmall => AppTypography.bodySmall;
  TextStyle get labelLarge => AppTypography.labelLarge;
}
