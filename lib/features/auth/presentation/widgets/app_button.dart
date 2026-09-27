// name: app_button.dart
// description: Reusable primary button with loading state and gradient style.

import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double? width;
  final double? height;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveHeight = height ?? context.h(50);
    final isEnabled = onPressed != null && !isLoading;

    return SizedBox(
      width: width ?? double.infinity,
      height: effectiveHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: isEnabled
              ? AppColors.primaryGradient
              : const LinearGradient(colors: [Color(0xFF2E3150), Color(0xFF252840)]),
          borderRadius: AppSpacing.roundedMd,
          boxShadow: isEnabled
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  )
                ]
              : [],
        ),
        child: ElevatedButton(
          onPressed: isEnabled ? onPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: const RoundedRectangleBorder(borderRadius: AppSpacing.roundedMd),
          ),
          child: isLoading
              ? SizedBox(
                  width: context.w(22),
                  height: context.w(22),
                  child: const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : Text(
                  label,
                  style: AppTypography.labelLarge.copyWith(
                    fontSize: context.sp(15),
                    color: isEnabled ? Colors.white : AppColors.textMuted,
                  ),
                ),
        ),
      ),
    );
  }
}
