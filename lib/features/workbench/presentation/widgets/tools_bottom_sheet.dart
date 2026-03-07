import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:zerodoc/core/constants/app_spacing.dart';
import 'package:zerodoc/core/constants/tool_routes.dart';
import 'package:zerodoc/core/theme/app_colors.dart';
import 'package:zerodoc/core/theme/app_typography.dart';
import 'package:zerodoc/shared/widgets/tool_card.dart';

class _ToolDef {
  const _ToolDef({required this.icon, required this.label, required this.id});
  final IconData icon;
  final String label;
  final String id;
}

class _ToolCategoryData {
  const _ToolCategoryData({required this.label, required this.tools});
  final String label;
  final List<_ToolDef> tools;
}

class ToolsBottomSheet extends StatelessWidget {
  const ToolsBottomSheet({
    required this.filePath,
    required this.fileName,
    super.key,
  });

  final String filePath;
  final String fileName;

  static const _categories = <_ToolCategoryData>[
    _ToolCategoryData(
      label: 'Organize',
      tools: [
        _ToolDef(icon: Icons.call_merge_rounded, label: 'Merge', id: ToolRoutes.merge),
        _ToolDef(icon: Icons.call_split_rounded, label: 'Split', id: ToolRoutes.split),
        _ToolDef(icon: Icons.swap_vert_rounded, label: 'Reorder', id: ToolRoutes.reorder),
      ],
    ),
    _ToolCategoryData(
      label: 'Modify',
      tools: [
        _ToolDef(icon: Icons.rotate_right_rounded, label: 'Rotate', id: ToolRoutes.rotate),
        _ToolDef(icon: Icons.compress_rounded, label: 'Compress', id: ToolRoutes.compress),
        _ToolDef(icon: Icons.filter_b_and_w_rounded, label: 'Grayscale', id: ToolRoutes.grayscale),
      ],
    ),
    _ToolCategoryData(
      label: 'Secure',
      tools: [
        _ToolDef(icon: Icons.lock_rounded, label: 'Encrypt', id: ToolRoutes.encrypt),
        _ToolDef(icon: Icons.lock_open_rounded, label: 'Unlock', id: ToolRoutes.unlock),
        _ToolDef(icon: Icons.cleaning_services_rounded, label: 'Sanitize', id: ToolRoutes.sanitize),
      ],
    ),
    _ToolCategoryData(
      label: 'Convert',
      tools: [
        _ToolDef(icon: Icons.image_rounded, label: 'Img→PDF', id: ToolRoutes.imgToPdf),
        _ToolDef(icon: Icons.photo_library_rounded, label: 'PDF→Img', id: ToolRoutes.pdfToImg),
        _ToolDef(icon: Icons.text_snippet_rounded, label: 'OCR', id: ToolRoutes.ocr),
      ],
    ),
    _ToolCategoryData(
      label: 'Annotate',
      tools: [
        _ToolDef(icon: Icons.draw_rounded, label: 'Sign', id: ToolRoutes.sign),
        _ToolDef(icon: Icons.branding_watermark_rounded, label: 'Watermark', id: ToolRoutes.watermark),
        _ToolDef(icon: Icons.format_list_numbered_rounded, label: 'Page #', id: ToolRoutes.pageNumbers),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: c.paperBg,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: c.inkMuted.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Tools',
                style: AppTypography.pageTitle(color: c.ink),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: AppSpacing.pagePadding.copyWith(bottom: 48),
                  itemCount: _categories.length,
                  itemBuilder: (context, i) {
                    final section = _categories[i];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.xl),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            section.label,
                            style: AppTypography.chip(color: c.inkMuted),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Row(
                            children: section.tools.map((tool) {
                              return Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                  child: ToolCard(
                                    icon: tool.icon,
                                    label: tool.label,
                                    onTap: () {
                                      HapticFeedback.lightImpact();
                                      context.pop();
                                      context.push(
                                        ToolRoutes.path(tool.id),
                                        extra: {
                                          'initialFilePath': filePath,
                                          'initialFileName': fileName,
                                        },
                                      );
                                    },
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
