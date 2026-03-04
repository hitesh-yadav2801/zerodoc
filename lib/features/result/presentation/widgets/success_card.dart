import 'package:flutter/material.dart';
import 'package:zerodoc/core/constants/app_spacing.dart';
import 'package:zerodoc/core/theme/app_colors.dart';
import 'package:zerodoc/core/theme/app_shadows.dart';
import 'package:zerodoc/core/theme/app_typography.dart';
import 'package:zerodoc/shared/widgets/ghost_button.dart';
import 'package:zerodoc/shared/widgets/primary_button.dart';

class SuccessCard extends StatelessWidget {
  const SuccessCard({
    required this.fileName,
    required this.onSave,
    required this.onShare,
    this.onOpenInWorkbench,
    super.key,
  });

  final String fileName;
  final VoidCallback onSave;
  final VoidCallback onShare;
  final VoidCallback? onOpenInWorkbench;

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
              color: c.sage,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Done!',
            style: AppTypography.resultTitle(color: c.ink),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            fileName,
            style: AppTypography.label(color: c.inkMuted),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.xxl),
          PrimaryButton(label: 'Save to Files', onPressed: onSave),
          const SizedBox(height: AppSpacing.sm),
          GhostButton(label: 'Share', onPressed: onShare),
          if (onOpenInWorkbench != null) ...[
            const SizedBox(height: AppSpacing.xs),
            GhostButton(
              label: 'Open in Workbench →',
              onPressed: onOpenInWorkbench!,
            ),
          ],
        ],
      ),
    );
  }
}
