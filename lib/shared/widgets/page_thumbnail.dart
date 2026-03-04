import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:zerodoc/core/constants/app_spacing.dart';
import 'package:zerodoc/core/theme/app_colors.dart';
import 'package:zerodoc/core/theme/app_shadows.dart';
import 'package:zerodoc/core/theme/app_typography.dart';

class PageThumbnail extends StatelessWidget {
  const PageThumbnail({
    required this.pageNumber,
    this.imageBytes,
    this.isSelected = false,
    this.onTap,
    super.key,
  });

  final int pageNumber;
  final Uint8List? imageBytes;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSpacing.thumbnailRadius),
          boxShadow: isSelected
              ? AppShadows.md(context)
              : AppShadows.sm(context),
          border: isSelected ? Border.all(color: c.slate, width: 2.5) : null,
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.thumbnailRadius),
              child: imageBytes != null
                  ? Image.memory(
                      imageBytes!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    )
                  : ColoredBox(
                      color: Colors.white,
                      child: Center(
                        child: Icon(
                          Icons.description_outlined,
                          color: c.inkMuted.withValues(alpha: 0.3),
                          size: 32,
                        ),
                      ),
                    ),
            ),
            Positioned(
              right: 6,
              bottom: 6,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: c.paperBg,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '$pageNumber',
                  style: AppTypography.pageBadge(color: c.inkMuted),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
