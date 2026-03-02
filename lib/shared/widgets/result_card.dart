import 'package:flutter/material.dart';
import 'package:zerodoc/core/constants/app_spacing.dart';
import 'package:zerodoc/core/theme/app_colors.dart';
import 'package:zerodoc/core/theme/app_shadows.dart';
import 'package:zerodoc/core/theme/app_typography.dart';
import 'package:zerodoc/shared/widgets/ghost_button.dart';
import 'package:zerodoc/shared/widgets/primary_button.dart';
import 'package:zerodoc/shared/widgets/secondary_button.dart';

class ResultCard extends StatelessWidget {
  const ResultCard({
    required this.fileName,
    required this.onSave,
    required this.onShare,
    this.isError = false,
    this.errorMessage,
    this.sizeComparison,
    this.onOpenWorkbench,
    this.onRetry,
    super.key,
  });

  final String fileName;
  final bool isError;
  final String? errorMessage;
  final String? sizeComparison;
  final VoidCallback onSave;
  final VoidCallback onShare;
  final VoidCallback? onOpenWorkbench;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.paperBg,
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 32),
          padding: const EdgeInsets.all(AppSpacing.xxl),
          decoration: BoxDecoration(
            color: AppColors.paperCard,
            borderRadius: BorderRadius.circular(24),
            boxShadow: AppShadows.md,
          ),
          child: isError ? _buildError() : _buildSuccess(),
        ),
      ),
    );
  }

  Widget _buildSuccess() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: AppSpacing.iconXxl,
          height: AppSpacing.iconXxl,
          decoration: const BoxDecoration(
            color: AppColors.sage,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check_rounded, color: Colors.white, size: 28),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text('Done!', style: AppTypography.resultTitle(color: AppColors.ink)),
        const SizedBox(height: AppSpacing.xs),
        Text(
          fileName,
          style: AppTypography.label(color: AppColors.inkMuted),
          textAlign: TextAlign.center,
        ),
        if (sizeComparison != null) ...[
          const SizedBox(height: AppSpacing.md),
          Text(
            sizeComparison!,
            style: AppTypography.caption(color: AppColors.inkMuted),
          ),
        ],
        const SizedBox(height: AppSpacing.xxl),
        PrimaryButton(label: 'Save to Files', onPressed: onSave),
        const SizedBox(height: AppSpacing.md),
        SecondaryButton(label: 'Share', onPressed: onShare),
        if (onOpenWorkbench != null) ...[
          const SizedBox(height: AppSpacing.sm),
          GhostButton(
            label: 'Open in Workbench →',
            onPressed: onOpenWorkbench!,
          ),
        ],
      ],
    );
  }

  Widget _buildError() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: AppSpacing.iconXxl,
          height: AppSpacing.iconXxl,
          decoration: const BoxDecoration(
            color: AppColors.terracotta,
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
          style: AppTypography.sectionHeader(color: AppColors.ink),
        ),
        if (errorMessage != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            errorMessage!,
            style: AppTypography.label(color: AppColors.inkMuted),
            textAlign: TextAlign.center,
          ),
        ],
        const SizedBox(height: AppSpacing.xxl),
        if (onRetry != null)
          PrimaryButton(label: 'Try Again', onPressed: onRetry),
      ],
    );
  }
}
