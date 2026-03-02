import 'package:flutter/material.dart';
import 'package:zerodoc/core/constants/app_spacing.dart';
import 'package:zerodoc/features/home/domain/entities/desk_file.dart';
import 'package:zerodoc/shared/services/file_service.dart';
import 'package:zerodoc/shared/widgets/file_card.dart';

class DeskFileList extends StatelessWidget {
  const DeskFileList({
    required this.files,
    required this.onFileTap,
    required this.onFileDismissed,
    super.key,
  });

  final List<DeskFile> files;
  final ValueChanged<DeskFile> onFileTap;
  final ValueChanged<DeskFile> onFileDismissed;

  static String _relativeTime(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final fileDay = DateTime(date.year, date.month, date.day);
    final diff = today.difference(fileDay).inDays;

    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    if (diff < 7) return '$diff days ago';

    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}';
  }

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: AppSpacing.pagePadding.copyWith(top: AppSpacing.sm),
      sliver: SliverList.separated(
        itemCount: files.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
        itemBuilder: (context, index) {
          final file = files[index];
          return FileCard(
            fileName: file.name,
            pageCount: file.pageCount,
            fileSize: FileService.formatFileSize(file.sizeBytes),
            subtitle: _relativeTime(file.addedAt),
            dismissKey: file.id,
            onTap: () => onFileTap(file),
            onDismissed: () => onFileDismissed(file),
          );
        },
      ),
    );
  }
}
