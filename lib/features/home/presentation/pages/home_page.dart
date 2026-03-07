import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zerodoc/core/constants/app_spacing.dart';
import 'package:zerodoc/core/constants/app_strings.dart';
import 'package:zerodoc/core/theme/app_colors.dart';
import 'package:zerodoc/core/theme/app_typography.dart';
import 'package:zerodoc/shared/providers/file_service_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  Future<void> _onImport(BuildContext context, WidgetRef ref) async {
    final fileService = ref.read(fileServiceProvider);
    final pickedFile = await fileService.pickPdf();
    if (pickedFile != null && context.mounted) {
      context.push(
        '/workbench',
        extra: {
          'filePath': pickedFile.path,
          'fileName': pickedFile.uri.pathSegments.last,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = AppColors.of(context);

    return Scaffold(
      backgroundColor: c.paperCard,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.pagePadding.copyWith(top: 24, bottom: 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAppBar(context, c),
              const SizedBox(height: 48),
              _buildImportButton(context, ref, c),
              const SizedBox(height: 48),
              _buildHistoryPlaceholder(context, c),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, AppColorsResolved c) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.dashboard_customize_rounded,
                    size: 28,
                    color: c.slate,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    AppStrings.appName,
                    style: AppTypography.pageTitle(color: c.ink).copyWith(fontSize: 24),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                AppStrings.slogan,
                style: AppTypography.caption(color: c.inkMuted),
              ),
            ],
          ),
        ),
        Text(
          _greeting,
          style: AppTypography.body(color: c.inkMuted),
        ),
      ],
    );
  }

  Widget _buildImportButton(BuildContext context, WidgetRef ref, AppColorsResolved c) {
    return InkWell(
      onTap: () => _onImport(context, ref),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
        decoration: BoxDecoration(
          color: c.sageTint,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: c.sage.withValues(alpha: 0.3), width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_circle_outline_rounded,
              size: 32,
              color: c.sage,
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Import PDF',
                  style: AppTypography.sectionHeader(color: c.ink),
                ),
                Text(
                  'Select a document to edit',
                  style: AppTypography.caption(color: c.inkMuted),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryPlaceholder(BuildContext context, AppColorsResolved c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Files',
          style: AppTypography.sectionHeader(color: c.ink),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: c.paperCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: c.slate.withValues(alpha: 0.1), width: 1),
          ),
          child: Center(
            child: Text(
              'No recent files yet.',
              style: AppTypography.body(color: c.inkMuted),
            ),
          ),
        ),
      ],
    );
  }
}
