import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zerodoc/core/constants/app_spacing.dart';
import 'package:zerodoc/core/constants/app_strings.dart';
import 'package:zerodoc/core/theme/app_colors.dart';
import 'package:zerodoc/core/theme/app_typography.dart';
import 'package:zerodoc/shared/widgets/tool_card.dart';

class ToolsPage extends StatelessWidget {
  const ToolsPage({super.key});

  static const _categories = <_ToolCategoryData>[
    _ToolCategoryData(
      label: 'Organize',
      tools: [
        _ToolDef(icon: Icons.call_merge_rounded, label: 'Merge'),
        _ToolDef(icon: Icons.call_split_rounded, label: 'Split'),
        _ToolDef(icon: Icons.swap_vert_rounded, label: 'Reorder'),
      ],
    ),
    _ToolCategoryData(
      label: 'Modify',
      tools: [
        _ToolDef(icon: Icons.rotate_right_rounded, label: 'Rotate'),
        _ToolDef(icon: Icons.compress_rounded, label: 'Compress'),
        _ToolDef(icon: Icons.filter_b_and_w_rounded, label: 'Grayscale'),
      ],
    ),
    _ToolCategoryData(
      label: 'Secure',
      tools: [
        _ToolDef(icon: Icons.lock_rounded, label: 'Encrypt'),
        _ToolDef(icon: Icons.lock_open_rounded, label: 'Unlock'),
        _ToolDef(icon: Icons.cleaning_services_rounded, label: 'Sanitize'),
      ],
    ),
    _ToolCategoryData(
      label: 'Convert',
      tools: [
        _ToolDef(icon: Icons.image_rounded, label: 'Img→PDF'),
        _ToolDef(icon: Icons.photo_library_rounded, label: 'PDF→Img'),
        _ToolDef(icon: Icons.text_snippet_rounded, label: 'OCR'),
      ],
    ),
    _ToolCategoryData(
      label: 'Annotate',
      tools: [
        _ToolDef(icon: Icons.draw_rounded, label: 'Sign'),
        _ToolDef(icon: Icons.branding_watermark_rounded, label: 'Watermark'),
        _ToolDef(icon: Icons.format_list_numbered_rounded, label: 'Page #'),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: AppSpacing.pagePadding.copyWith(top: 24),
        children: [
          Text(
            'All Tools',
            style: AppTypography.pageTitle(color: AppColors.ink),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            AppStrings.slogan,
            style: AppTypography.caption(color: AppColors.inkMuted),
          ),
          const SizedBox(height: AppSpacing.xxl),
          for (int i = 0; i < _categories.length; i++) ...[
            if (i > 0) const SizedBox(height: AppSpacing.xl),
            _ToolCategorySection(
              label: _categories[i].label,
              tools: _categories[i].tools,
            ),
          ],
          const SizedBox(height: AppSpacing.xxxl),
        ],
      ),
    );
  }
}

class _ToolDef {
  const _ToolDef({required this.icon, required this.label});
  final IconData icon;
  final String label;
}

class _ToolCategoryData {
  const _ToolCategoryData({required this.label, required this.tools});
  final String label;
  final List<_ToolDef> tools;
}

class _ToolCategorySection extends StatelessWidget {
  const _ToolCategorySection({
    required this.label,
    required this.tools,
  });

  final String label;
  final List<_ToolDef> tools;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.chip(color: AppColors.inkMuted),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: tools.map((tool) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ToolCard(
                  icon: tool.icon,
                  label: tool.label,
                  onTap: HapticFeedback.lightImpact,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
