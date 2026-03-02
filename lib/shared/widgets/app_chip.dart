import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zerodoc/core/constants/app_spacing.dart';
import 'package:zerodoc/core/theme/app_colors.dart';
import 'package:zerodoc/core/theme/app_typography.dart';

class AppChip extends StatelessWidget {
  const AppChip({
    required this.label,
    required this.onTap,
    this.isActive = false,
    super.key,
  });

  final String label;
  final VoidCallback onTap;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: AppSpacing.chipHeight,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: isActive ? AppColors.slate : AppColors.paperWhite,
          borderRadius: BorderRadius.circular(AppSpacing.chipRadius),
          border: isActive
              ? null
              : Border.all(color: AppColors.divider),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppTypography.chip(
            color: isActive ? Colors.white : AppColors.ink,
          ),
        ),
      ),
    );
  }
}
