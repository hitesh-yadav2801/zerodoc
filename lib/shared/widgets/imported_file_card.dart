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
    final c = AppColors.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: c.paperCard,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        boxShadow: AppShadows.sm(context),
      ),
      child: Row(
        children: [
          Icon(
            Icons.picture_as_pdf_rounded,
            color: c.slate,
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  style: AppTypography.label(color: c.ink),
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
                    style: AppTypography.caption(color: c.inkMuted),
                  ),
              ],
            ),
          ),
          IconButton(
            onPressed: onRemove,
            icon: Icon(
              Icons.close_rounded,
              size: 18,
              color: c.inkMuted,
            ),
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }
}
