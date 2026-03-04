import 'package:flutter/material.dart';
import 'package:zerodoc/core/constants/app_spacing.dart';
import 'package:zerodoc/features/home/domain/entities/desk_file.dart';
import 'package:zerodoc/features/home/presentation/widgets/swipeable_file_card.dart';

class DeskFileList extends StatelessWidget {
  const DeskFileList({
    required this.files,
    required this.onFileTap,
    required this.onFileDelete,
    super.key,
  });

  final List<DeskFile> files;
  final ValueChanged<DeskFile> onFileTap;
  final ValueChanged<DeskFile> onFileDelete;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: AppSpacing.pagePadding.copyWith(top: AppSpacing.sm),
      sliver: SliverList.separated(
        itemCount: files.length,
        separatorBuilder: (_, index) => const SizedBox(height: AppSpacing.sm),
        itemBuilder: (context, index) {
          final file = files[index];
          return SwipeableFileCard(
            key: ValueKey(file.id),
            file: file,
            onTap: () => onFileTap(file),
            onDelete: () => onFileDelete(file),
          );
        },
      ),
    );
  }
}
