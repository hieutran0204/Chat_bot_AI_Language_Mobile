// name: app_theme.dart
// description: Centralized ThemeData combining AppColors, AppTypography, and AppSpacing.
//              Provides unified dark theme tokens for all Material 3 widgets.

import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.bgDark,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          onPrimary: Colors.white,
          primaryContainer: AppColors.primaryDark,
          onPrimaryContainer: AppColors.primaryLight,
          secondary: AppColors.secondary,
          onSecondary: Colors.white,
          surface: AppColors.bgSurface,
          onSurface: AppColors.textPrimary,
          error: AppColors.error,
          onError: Colors.white,
        ),
        textTheme: AppTypography.textTheme,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.bgElevated,
          hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textHint),
          labelStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
          border: OutlineInputBorder(
            borderRadius: AppSpacing.roundedMd,
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppSpacing.roundedMd,
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppSpacing.roundedMd,
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: AppSpacing.roundedMd,
            borderSide: const BorderSide(color: AppColors.error),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: AppSpacing.roundedMd,
            borderSide: const BorderSide(color: AppColors.error, width: 1.5),
          ),
          contentPadding: AppSpacing.inputPadding,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(52),
            shape: const RoundedRectangleBorder(borderRadius: AppSpacing.roundedMd),
            textStyle: AppTypography.labelLarge,
            elevation: 0,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primaryLight,
            textStyle: AppTypography.labelMedium,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.textPrimary,
            side: const BorderSide(color: AppColors.borderLight),
            shape: const RoundedRectangleBorder(borderRadius: AppSpacing.roundedMd),
            textStyle: AppTypography.labelLarge,
          ),
        ),
        cardTheme: const CardThemeData(
          color: AppColors.bgSurface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.roundedLg,
            side: BorderSide(color: AppColors.border),
          ),
        ),
        dividerTheme: const DividerThemeData(
          color: AppColors.divider,
          thickness: 1,
          space: 1,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.bgDark,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: AppTypography.titleLarge,
          iconTheme: const IconThemeData(color: AppColors.textPrimary),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.bgSurface,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textMuted,
          type: BottomNavigationBarType.fixed,
        ),
      );
}
