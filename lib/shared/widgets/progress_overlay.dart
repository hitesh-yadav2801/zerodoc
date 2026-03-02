import 'package:flutter/material.dart';
import 'package:zerodoc/core/constants/app_spacing.dart';
import 'package:zerodoc/core/theme/app_colors.dart';
import 'package:zerodoc/core/theme/app_shadows.dart';
import 'package:zerodoc/core/theme/app_typography.dart';

class ProgressOverlay extends StatelessWidget {
  const ProgressOverlay({
    this.message = 'Processing...',
    super.key,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.paperBg,
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 32),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
          decoration: BoxDecoration(
            color: AppColors.paperCard,
            borderRadius: BorderRadius.circular(24),
            boxShadow: AppShadows.md,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 48,
                height: 48,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: AppColors.slate,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                message,
                style: AppTypography.body(color: AppColors.inkMuted),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
