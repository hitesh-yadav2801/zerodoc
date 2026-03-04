import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zerodoc/core/constants/app_spacing.dart';
import 'package:zerodoc/core/theme/app_colors.dart';
import 'package:zerodoc/core/theme/app_typography.dart';
import 'package:zerodoc/features/workbench/presentation/providers/workbench_provider.dart';
import 'package:zerodoc/features/workbench/presentation/widgets/page_thumbnail_tile.dart';
import 'package:zerodoc/features/workbench/presentation/widgets/rename_bottom_sheet.dart';
import 'package:zerodoc/features/workbench/presentation/widgets/workbench_action_bar.dart';
import 'package:zerodoc/shared/widgets/app_snackbar.dart';

class WorkbenchPage extends ConsumerWidget {
  const WorkbenchPage({
    required this.filePath,
    required this.fileName,
    super.key,
  });

  final String filePath;
  final String fileName;

  ({String filePath, String fileName}) get _arg =>
      (filePath: filePath, fileName: fileName);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(workbenchProvider(_arg));

    return Scaffold(
      backgroundColor: AppColors.paperBg,
      body: state.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.slate),
        ),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 48,
                color: AppColors.terracotta.withValues(alpha: 0.6),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Could not open this file.',
                style: AppTypography.body(color: AppColors.inkMuted),
              ),
              const SizedBox(height: AppSpacing.lg),
              TextButton(
                onPressed: () => context.pop(),
                child: Text(
                  'Go Back',
                  style: AppTypography.label(color: AppColors.slate),
                ),
              ),
            ],
          ),
        ),
        data: (wb) => SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  _buildAppBar(context, ref, wb),
                  Expanded(
                    child: wb.isReorderMode
                        ? _buildReorderGrid(ref, wb)
                        : _buildGrid(ref, wb),
                  ),
                ],
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: WorkbenchActionBar(
                  visible: wb.hasSelection,
                  onRotateLeft: () => ref
                      .read(workbenchProvider(_arg).notifier)
                      .rotateSelected(-90),
                  onRotateRight: () => ref
                      .read(workbenchProvider(_arg).notifier)
                      .rotateSelected(90),
                  onExtract: () => _onExtract(context, ref),
                  onDelete: () => _onDelete(context, ref, wb),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(
    BuildContext context,
    WidgetRef ref,
    WorkbenchState wb,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back_rounded, color: AppColors.ink),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => _showRenameSheet(context, ref, wb.fileName),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      wb.fileName,
                      style: AppTypography.sectionHeader(color: AppColors.ink),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.edit_rounded,
                    size: 16,
                    color: AppColors.inkMuted,
                  ),
                ],
              ),
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded, color: AppColors.ink),
            onSelected: (value) =>
                _onMenuAction(context, ref, value, wb),
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: 'select_all',
                child: Text('Select All'),
              ),
              const PopupMenuItem(
                value: 'deselect_all',
                child: Text('Deselect All'),
              ),
              const PopupMenuItem(
                value: 'reorder',
                child: Text('Reorder Pages'),
              ),
              const PopupMenuItem(
                value: 'save_copy',
                child: Text('Save as new copy'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGrid(WidgetRef ref, WorkbenchState wb) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.7,
      ),
      itemCount: wb.pages.length,
      itemBuilder: (context, index) {
        return PageThumbnailTile(
          pageState: wb.pages[index],
          displayIndex: index,
          onTap: () =>
              ref.read(workbenchProvider(_arg).notifier).toggleSelection(index),
          onLongPress: () =>
              ref.read(workbenchProvider(_arg).notifier).toggleReorderMode(),
        );
      },
    );
  }

  Widget _buildReorderGrid(WidgetRef ref, WorkbenchState wb) {
    return ReorderableListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
      itemCount: wb.pages.length,
      onReorder: (oldIndex, newIndex) =>
          ref.read(workbenchProvider(_arg).notifier).reorder(oldIndex, newIndex),
      proxyDecorator: (child, index, animation) {
        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) => Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(AppSpacing.thumbnailRadius),
            child: child,
          ),
          child: child,
        );
      },
      itemBuilder: (context, index) {
        return Padding(
          key: ValueKey(wb.pages[index].originalIndex),
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              const Icon(
                Icons.drag_handle_rounded,
                color: AppColors.inkMuted,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SizedBox(
                  height: 120,
                  child: PageThumbnailTile(
                    pageState: wb.pages[index],
                    displayIndex: index,
                    onTap: () {},
                    onLongPress: () {},
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showRenameSheet(
    BuildContext context,
    WidgetRef ref,
    String currentName,
  ) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.paperCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => RenameBottomSheet(
        currentName: currentName,
        onRename: (name) =>
            ref.read(workbenchProvider(_arg).notifier).rename(name),
      ),
    );
  }

  void _onMenuAction(
    BuildContext context,
    WidgetRef ref,
    String action,
    WorkbenchState wb,
  ) {
    final notifier = ref.read(workbenchProvider(_arg).notifier);
    switch (action) {
      case 'select_all':
        notifier.selectAll();
      case 'deselect_all':
        notifier.deselectAll();
      case 'reorder':
        notifier.toggleReorderMode();
      case 'save_copy':
        _onSaveCopy(context, ref);
    }
  }

  Future<void> _onSaveCopy(BuildContext context, WidgetRef ref) async {
    final (failure, outputPath) =
        await ref.read(workbenchProvider(_arg).notifier).saveAsNewCopy();
    if (!context.mounted) return;
    if (failure != null) {
      AppSnackBar.show(context, message: failure.message, isError: true);
    } else {
      final wb = ref.read(workbenchProvider(_arg)).value;
      await context.push('/result', extra: {
        'outputPath': outputPath,
        'fileName': wb?.fileName ?? fileName,
        'showOpenInWorkbench': true,
      });
    }
  }

  Future<void> _onExtract(BuildContext context, WidgetRef ref) async {
    final (failure, outputPath) =
        await ref.read(workbenchProvider(_arg).notifier).extractSelected();
    if (!context.mounted) return;
    if (failure != null) {
      AppSnackBar.show(context, message: failure.message, isError: true);
    } else {
      ref.read(workbenchProvider(_arg).notifier).deselectAll();
      final baseName = fileName.replaceAll(RegExp(r'\.pdf$'), '');
      await context.push('/result', extra: {
        'outputPath': outputPath,
        'fileName': '${baseName}_extract.pdf',
        'showOpenInWorkbench': true,
      });
    }
  }

  void _onDelete(
    BuildContext context,
    WidgetRef ref,
    WorkbenchState wb,
  ) {
    final remaining = wb.pages.where((p) => !p.isSelected).length;
    if (remaining == 0) {
      AppSnackBar.show(
        context,
        message: 'Cannot delete all pages',
        isError: true,
      );
      return;
    }
    ref.read(workbenchProvider(_arg).notifier).deleteSelected();
  }
}
