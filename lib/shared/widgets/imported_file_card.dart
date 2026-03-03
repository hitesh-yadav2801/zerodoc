import 'package:flutter/material.dart';
import 'package:zerodoc/core/constants/app_spacing.dart';
import 'package:zerodoc/core/theme/app_colors.dart';
import 'package:zerodoc/core/theme/app_shadows.dart';
import 'package:zerodoc/core/theme/app_typography.dart';
import 'package:zerodoc/shared/services/file_service.dart';

class ImportedFileCard extends StatelessWidget {
  const ImportedFileCard({
    required this.fileName,
    required this.onRemove,
    this.pageCount,
    this.sizeBytes,
    super.key,
  });

  final String fileName;
  final VoidCallback onRemove;
  final int? pageCount;
  final int? sizeBytes;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.paperCard,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        boxShadow: AppShadows.sm,
      ),
      child: Row(
        children: [
          const Icon(
            Icons.picture_as_pdf_rounded,
            color: AppColors.slate,
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  style: AppTypography.label(color: AppColors.ink),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (pageCount != null || sizeBytes != null)
                  Text(
                    [
                      if (pageCount != null) '$pageCount pages',
                      if (sizeBytes != null)
                        FileService.formatFileSize(sizeBytes!),
                    ].join(' · '),
                    style: AppTypography.caption(color: AppColors.inkMuted),
                  ),
              ],
            ),
          ),
          IconButton(
            onPressed: onRemove,
            icon: const Icon(
              Icons.close_rounded,
              size: 18,
              color: AppColors.inkMuted,
            ),
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }
}
