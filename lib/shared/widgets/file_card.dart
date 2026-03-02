import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zerodoc/core/constants/app_durations.dart';
import 'package:zerodoc/core/constants/app_spacing.dart';
import 'package:zerodoc/core/theme/app_colors.dart';
import 'package:zerodoc/core/theme/app_shadows.dart';
import 'package:zerodoc/core/theme/app_typography.dart';

class FileCard extends StatefulWidget {
  const FileCard({
    required this.fileName,
    required this.onTap,
    this.pageCount,
    this.fileSize,
    this.subtitle,
    this.onDismissed,
    super.key,
  });

  final String fileName;
  final int? pageCount;
  final String? fileSize;
  final String? subtitle;
  final VoidCallback onTap;
  final VoidCallback? onDismissed;

  @override
  State<FileCard> createState() => _FileCardState();
}

class _FileCardState extends State<FileCard> {
  bool _pressed = false;

  String get _metadata {
    final parts = <String>[];
    if (widget.pageCount != null) {
      parts.add('${widget.pageCount} pages');
    }
    if (widget.fileSize != null) parts.add(widget.fileSize!);
    if (widget.subtitle != null) parts.add(widget.subtitle!);
    return parts.join(' · ');
  }

  Widget _buildCard() {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        HapticFeedback.lightImpact();
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1.0,
        duration: AppDurations.cardPress,
        curve: Curves.easeOut,
        child: Container(
          height: AppSpacing.fileCardHeight,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.paperCard,
            borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
            boxShadow: AppShadows.sm,
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.slateLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.picture_as_pdf_rounded,
                  color: AppColors.slate,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.fileName,
                      style: AppTypography.bodyMedium(color: AppColors.ink),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (_metadata.isNotEmpty)
                      Text(
                        _metadata,
                        style:
                            AppTypography.caption(color: AppColors.inkMuted),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.onDismissed == null) return _buildCard();

    return Dismissible(
      key: ValueKey(widget.fileName),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        HapticFeedback.heavyImpact();
        widget.onDismissed?.call();
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: AppColors.terracotta,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        ),
        child: const Icon(Icons.delete_rounded, color: Colors.white),
      ),
      child: _buildCard(),
    );
  }
}
