import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zerodoc/core/constants/app_spacing.dart';
import 'package:zerodoc/core/theme/app_colors.dart';
import 'package:zerodoc/core/theme/app_typography.dart';
import 'package:zerodoc/features/home/domain/entities/desk_file.dart';
import 'package:zerodoc/features/home/presentation/providers/desk_provider.dart';
import 'package:zerodoc/shared/services/file_service.dart';

class DeskSelectionPage extends ConsumerStatefulWidget {
  const DeskSelectionPage({
    this.allowMultiple = false,
    super.key,
  });

  /// Whether multiple files can be selected.
  final bool allowMultiple;

  @override
  ConsumerState<DeskSelectionPage> createState() => _DeskSelectionPageState();
}

class _DeskSelectionPageState extends ConsumerState<DeskSelectionPage> {
  final _selectedIds = <String>{};

  void _onToggle(String id) {
    setState(() {
      if (widget.allowMultiple) {
        if (_selectedIds.contains(id)) {
          _selectedIds.remove(id);
        } else {
          _selectedIds.add(id);
        }
      } else {
        _selectedIds.clear();
        _selectedIds.add(id);
      }
    });
  }

  void _onConfirm(List<DeskFile> allFiles) {
    final selectedFiles = allFiles
        .where((f) => _selectedIds.contains(f.id))
        .toList();
    context.pop(selectedFiles);
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final deskState = ref.watch(deskProvider);

    return Scaffold(
      backgroundColor: c.paperBg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, c),
            Expanded(
              child: deskState.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
                data: (files) {
                  if (files.isEmpty) {
                    return Center(
                      child: Text(
                        'Your desk is empty',
                        style: AppTypography.body(color: c.inkMuted),
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: AppSpacing.pagePadding.copyWith(
                      top: AppSpacing.md,
                    ),
                    itemCount: files.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      final file = files[index];
                      final isSelected = _selectedIds.contains(file.id);

                      return _SelectionCard(
                        file: file,
                        isSelected: isSelected,
                        onTap: () => _onToggle(file.id),
                      );
                    },
                  );
                },
              ),
            ),
            if (deskState.value != null && deskState.value!.isNotEmpty)
              _buildBottomBar(c, deskState.value!),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppColorsResolved c) {
    return Padding(
      padding: AppSpacing.pagePadding.copyWith(top: 24, bottom: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: Icon(Icons.arrow_back_rounded, color: c.ink),
          ),
          const SizedBox(width: 8),
          Text(
            'Choose from Desk',
            style: AppTypography.pageTitle(color: c.ink),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(AppColorsResolved c, List<DeskFile> files) {
    final count = _selectedIds.length;
    final isEnabled = count > 0;

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.pagePadding.left,
        16,
        AppSpacing.pagePadding.right,
        AppSpacing.pagePadding.bottom + 16,
      ),
      decoration: BoxDecoration(
        color: c.paperCard,
        boxShadow: [
          BoxShadow(
            color: c.ink.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$count selected',
            style: AppTypography.label(color: c.ink),
          ),
          ElevatedButton(
            onPressed: isEnabled ? () => _onConfirm(files) : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: c.slate,
              foregroundColor: Colors.white,
              disabledBackgroundColor: c.slate.withValues(alpha: 0.5),
              disabledForegroundColor: Colors.white.withValues(alpha: 0.5),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              elevation: 0,
            ),
            child: Text(
              'Confirm',
              style: AppTypography.label(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectionCard extends StatelessWidget {
  const _SelectionCard({
    required this.file,
    required this.isSelected,
    required this.onTap,
  });

  final DeskFile file;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      child: Container(
        padding: AppSpacing.cardPadding,
        decoration: BoxDecoration(
          color: c.paperCard,
          border: Border.all(
            color: isSelected ? c.slate : Colors.transparent,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          boxShadow: [
            BoxShadow(
              color: c.ink.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? c.slate
                      : c.inkMuted.withValues(alpha: 0.3),
                  width: isSelected ? 6 : 1.5,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    file.name,
                    style: AppTypography.body(color: c.ink),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '${file.pageCount} pages',
                        style: AppTypography.caption(color: c.inkMuted),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: c.inkMuted,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        FileService.formatFileSize(file.sizeBytes),
                        style: AppTypography.caption(color: c.inkMuted),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
