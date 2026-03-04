import 'package:flutter/material.dart';
import 'package:zerodoc/core/constants/app_spacing.dart';
import 'package:zerodoc/core/theme/app_colors.dart';
import 'package:zerodoc/core/theme/app_shadows.dart';
import 'package:zerodoc/core/theme/app_typography.dart';
import 'package:zerodoc/shared/widgets/primary_button.dart';

class ErrorCard extends StatelessWidget {
  const ErrorCard({
    required this.message,
    required this.onRetry,
    super.key,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: BoxDecoration(
        color: c.paperCard,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppShadows.md(context),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: c.terracotta,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.warning_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Something went wrong',
            style: AppTypography.sectionHeader(color: c.ink),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            message,
            style: AppTypography.label(color: c.inkMuted),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xxl),
          PrimaryButton(label: 'Try Again', onPressed: onRetry),
        ],
      ),
    );
  }
}
