import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zerodoc/core/constants/app_spacing.dart';
import 'package:zerodoc/core/theme/app_colors.dart';
import 'package:zerodoc/core/theme/app_typography.dart';
import 'package:zerodoc/features/home/domain/entities/desk_file.dart';
import 'package:zerodoc/shared/services/file_service.dart';
import 'package:zerodoc/shared/widgets/file_card.dart';

/// A file card that reveals a delete button when swiped left.
///
/// Unlike [Dismissible], this does not remove the widget from the tree.
/// The card slides to reveal a delete button behind it. Tapping the
/// delete button triggers [onDelete].
class SwipeableFileCard extends StatefulWidget {
  const SwipeableFileCard({
    required this.file,
    required this.onTap,
    required this.onDelete,
    super.key,
  });

  final DeskFile file;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  State<SwipeableFileCard> createState() => _SwipeableFileCardState();
}

class _SwipeableFileCardState extends State<SwipeableFileCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;

  static const _deleteButtonWidth = 80.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-0.2, 0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    final delta = details.primaryDelta ?? 0;
    _controller.value -= delta / (context.size?.width ?? 400);
  }

  Future<void> _onHorizontalDragEnd(DragEndDetails details) async {
    if (_controller.value > 0.1) {
      await _controller.forward();
    } else {
      await _controller.reverse();
    }
  }

  Future<void> _onDeleteTap() async {
    await HapticFeedback.heavyImpact();
    await _controller.reverse();
    widget.onDelete();
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return SizedBox(
      height: AppSpacing.fileCardHeight,
      child: Stack(
        children: [
          // Delete button behind the card
          Positioned.fill(
            child: Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: _onDeleteTap,
                child: Container(
                  width: _deleteButtonWidth,
                  height: AppSpacing.fileCardHeight,
                  decoration: BoxDecoration(
                    color: c.terracotta,
                    borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.delete_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Delete',
                        style: AppTypography.caption(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Slideable card
          SlideTransition(
            position: _slideAnimation,
            child: GestureDetector(
              onHorizontalDragUpdate: _onHorizontalDragUpdate,
              onHorizontalDragEnd: _onHorizontalDragEnd,
              child: FileCard(
                fileName: widget.file.name,
                pageCount: widget.file.pageCount,
                fileSize: FileService.formatFileSize(widget.file.sizeBytes),
                subtitle: _relativeTime(widget.file.addedAt),
                onTap: widget.onTap,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _relativeTime(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final fileDay = DateTime(date.year, date.month, date.day);
    final diff = today.difference(fileDay).inDays;

    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    if (diff < 7) return '$diff days ago';

    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}';
  }
}
