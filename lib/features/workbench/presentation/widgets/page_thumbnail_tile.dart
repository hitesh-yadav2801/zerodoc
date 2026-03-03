import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zerodoc/core/constants/app_spacing.dart';
import 'package:zerodoc/core/theme/app_colors.dart';
import 'package:zerodoc/core/theme/app_shadows.dart';
import 'package:zerodoc/core/theme/app_typography.dart';
import 'package:zerodoc/features/workbench/domain/entities/page_state.dart';

class PageThumbnailTile extends StatelessWidget {
  const PageThumbnailTile({
    required this.pageState,
    required this.displayIndex,
    required this.onTap,
    required this.onLongPress,
    super.key,
  });

  final PageState pageState;
  final int displayIndex;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      onLongPress: () {
        HapticFeedback.mediumImpact();
        onLongPress();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: AppColors.paperWhite,
          borderRadius: BorderRadius.circular(AppSpacing.thumbnailRadius),
          boxShadow: pageState.isSelected ? AppShadows.md : AppShadows.sm,
          border: pageState.isSelected
              ? Border.all(color: AppColors.slate, width: 2.5)
              : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
            pageState.isSelected
                ? AppSpacing.thumbnailRadius - 2
                : AppSpacing.thumbnailRadius,
          ),
          child: Stack(
            children: [
              if (pageState.thumbnail != null)
                Positioned.fill(
                  child: Transform.rotate(
                    angle: pageState.rotation * math.pi / 180,
                    child: Image.memory(
                      pageState.thumbnail!,
                      fit: BoxFit.contain,
                    ),
                  ),
                )
              else
                const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.slate,
                    strokeWidth: 2,
                  ),
                ),
              Positioned(
                right: 6,
                bottom: 6,
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: const BoxDecoration(
                    color: AppColors.paperBg,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${displayIndex + 1}',
                    style: AppTypography.pageBadge(color: AppColors.inkMuted),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
