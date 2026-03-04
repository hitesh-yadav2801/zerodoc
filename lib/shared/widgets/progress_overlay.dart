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
    final c = AppColors.of(context);
    return ColoredBox(
      color: c.paperBg,
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 32),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
          decoration: BoxDecoration(
            color: c.paperCard,
            borderRadius: BorderRadius.circular(24),
            boxShadow: AppShadows.md(context),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 48,
                height: 48,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: c.slate,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                message,
                style: AppTypography.body(color: c.inkMuted),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
