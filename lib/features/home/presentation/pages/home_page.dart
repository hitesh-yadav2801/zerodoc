import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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

  void _onFileDelete(
    BuildContext context,
    WidgetRef ref,
    DeskFile file,
  ) {
    final removed = ref.read(deskProvider.notifier).softRemoveFile(file.id);
    if (removed == null) return;

    var undone = false;

    AppSnackBar.show(
      context,
      message: 'Removed ${removed.name}',
      actionLabel: 'Undo',
      duration: const Duration(seconds: 5),
      onAction: () {
        undone = true;
        ref.read(deskProvider.notifier).undoSoftRemove(removed);
      },
      onDismissed: () {
        if (!undone) {
          unawaited(
            ref.read(deskProvider.notifier).confirmRemoveFile(removed.id),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = AppColors.of(context);
    final deskState = ref.watch(deskProvider);

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          _buildHeader(context, ref, c),
          _buildSectionTitle(c),
          deskState.when(
            loading: () => _buildLoading(c),
            error: (error, _) => _buildError(context, ref, error, c),
            data: (files) => files.isEmpty
                ? _buildEmpty(c)
                : DeskFileList(
                    files: files,
                    onFileTap: (file) => context.push(
                      '/workbench',
                      extra: {
                        'filePath': file.path,
                        'fileName': file.name,
                      },
                    ),
                    onFileDelete: (file) =>
                        _onFileDelete(context, ref, file),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref, AppColorsResolved c) {
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
                  style: AppTypography.pageTitle(color: c.ink),
                ),
                const SizedBox(height: 2),
                Text(
                  AppStrings.slogan,
                  style: AppTypography.caption(color: c.inkMuted),
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

  Widget _buildSectionTitle(AppColorsResolved c) {
    return SliverPadding(
      padding: AppSpacing.pagePadding.copyWith(top: 24),
      sliver: SliverToBoxAdapter(
        child: Text(
          'On the Desk',
          style: AppTypography.sectionHeader(color: c.ink),
        ),
      ),
    );
  }

  Widget _buildLoading(AppColorsResolved c) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: CircularProgressIndicator(color: c.slate),
      ),
    );
  }

  Widget _buildError(BuildContext context, WidgetRef ref, Object error, AppColorsResolved c) {
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
                color: c.terracotta.withValues(alpha: 0.6),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Could not load your files.',
                style: AppTypography.body(color: c.inkMuted),
              ),
              const SizedBox(height: AppSpacing.lg),
              TextButton(
                onPressed: () => ref.invalidate(deskProvider),
                child: Text(
                  'Retry',
                  style: AppTypography.label(color: c.slate),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmpty(AppColorsResolved c) {
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
                color: c.inkMuted.withValues(alpha: 0.4),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Nothing on the desk yet.',
                style: AppTypography.body(color: c.inkMuted),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Tap + to import a document.',
                style: AppTypography.caption(color: c.inkMuted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
