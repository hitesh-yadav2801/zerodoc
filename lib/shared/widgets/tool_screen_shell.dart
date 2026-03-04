import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zerodoc/core/constants/app_spacing.dart';
import 'package:zerodoc/core/theme/app_colors.dart';
import 'package:zerodoc/core/theme/app_typography.dart';
import 'package:zerodoc/shared/widgets/primary_button.dart';

/// Reusable 3-section layout for every tool screen.
///
/// Section 1: [fileSection] — File Drop Zone / imported file list
/// Section 2: [optionsSection] — Tool-specific options
/// Section 3: [actionLabel] + [onAction] — Fixed action button at bottom
class ToolScreenShell extends StatelessWidget {
  const ToolScreenShell({
    required this.title,
    required this.fileSection,
    required this.actionLabel,
    required this.onAction,
    this.optionsSection,
    this.isActionEnabled = false,
    this.isLoading = false,
    super.key,
  });

  final String title;
  final Widget fileSection;
  final Widget? optionsSection;
  final String actionLabel;
  final VoidCallback? onAction;
  final bool isActionEnabled;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Scaffold(
      backgroundColor: c.paperBg,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context, c),
            Expanded(
              child: ListView(
                padding: AppSpacing.pagePadding.copyWith(top: 8, bottom: 100),
                children: [
                  fileSection,
                  if (optionsSection != null) ...[
                    const SizedBox(height: AppSpacing.xl),
                    optionsSection!,
                  ],
                ],
              ),
            ),
            _buildActionBar(c),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, AppColorsResolved c) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: Icon(Icons.arrow_back_rounded, color: c.ink),
          ),
          const SizedBox(width: 4),
          Text(
            title,
            style: AppTypography.sectionHeader(color: c.ink),
          ),
        ],
      ),
    );
  }

  Widget _buildActionBar(AppColorsResolved c) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: c.paperBg,
        border: Border(
          top: BorderSide(color: c.divider),
        ),
      ),
      child: PrimaryButton(
        label: actionLabel,
        onPressed: onAction,
        isEnabled: isActionEnabled,
        isLoading: isLoading,
      ),
    );
  }
}
