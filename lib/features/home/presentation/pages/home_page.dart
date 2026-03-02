import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zerodoc/core/constants/app_spacing.dart';
import 'package:zerodoc/core/constants/app_strings.dart';
import 'package:zerodoc/core/theme/app_colors.dart';
import 'package:zerodoc/core/theme/app_typography.dart';
import 'package:zerodoc/features/home/domain/entities/desk_file.dart';
import 'package:zerodoc/features/home/presentation/providers/desk_provider.dart';
import 'package:zerodoc/features/home/presentation/widgets/desk_file_list.dart';
import 'package:zerodoc/shared/widgets/app_snackbar.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  Future<void> _onImport(BuildContext context, WidgetRef ref) async {
    final failure = await ref.read(deskProvider.notifier).importFile();
    if (failure != null && context.mounted) {
      AppSnackBar.show(context, message: failure.message, isError: true);
    }
  }

  void _onFileDismissed(
    BuildContext context,
    WidgetRef ref,
    DeskFile file,
  ) {
    ref.read(deskProvider.notifier).removeFile(file.id).then(
      (removed) {
        if (removed != null && context.mounted) {
          AppSnackBar.show(
            context,
            message: 'Removed ${removed.name}',
            actionLabel: 'Undo',
            onAction: () {
              ref.read(deskProvider.notifier).undoRemove(removed);
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deskState = ref.watch(deskProvider);

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          _buildHeader(context, ref),
          _buildSectionTitle(),
          deskState.when(
            loading: _buildLoading,
            error: (error, _) => _buildError(context, ref, error),
            data: (files) => files.isEmpty
                ? _buildEmpty()
                : DeskFileList(
                    files: files,
                    onFileTap: (_) {},
                    onFileDismissed: (file) =>
                        _onFileDismissed(context, ref, file),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    return SliverPadding(
      padding: AppSpacing.pagePadding.copyWith(top: 24, bottom: 8),
      sliver: SliverToBoxAdapter(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _greeting,
                  style: AppTypography.pageTitle(color: AppColors.ink),
                ),
                const SizedBox(height: 2),
                Text(
                  AppStrings.slogan,
                  style: AppTypography.caption(color: AppColors.inkMuted),
                ),
              ],
            ),
            FloatingActionButton.small(
              heroTag: 'home_fab',
              onPressed: () => _onImport(context, ref),
              child: const Icon(Icons.add_rounded),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle() {
    return SliverPadding(
      padding: AppSpacing.pagePadding.copyWith(top: 24),
      sliver: SliverToBoxAdapter(
        child: Text(
          'On the Desk',
          style: AppTypography.sectionHeader(color: AppColors.ink),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return const SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: CircularProgressIndicator(color: AppColors.slate),
      ),
    );
  }

  Widget _buildError(BuildContext context, WidgetRef ref, Object error) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 100),
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
                'Could not load your files.',
                style: AppTypography.body(color: AppColors.inkMuted),
              ),
              const SizedBox(height: AppSpacing.lg),
              TextButton(
                onPressed: () => ref.invalidate(deskProvider),
                child: Text(
                  'Retry',
                  style: AppTypography.label(color: AppColors.slate),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.description_outlined,
                size: 64,
                color: AppColors.inkMuted.withValues(alpha: 0.4),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Nothing on the desk yet.',
                style: AppTypography.body(color: AppColors.inkMuted),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Tap + to import a document.',
                style: AppTypography.caption(color: AppColors.inkMuted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
