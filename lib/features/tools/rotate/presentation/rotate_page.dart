import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zerodoc/shared/providers/file_service_provider.dart';
import 'package:zerodoc/shared/widgets/app_snackbar.dart';
import 'package:zerodoc/shared/widgets/file_drop_zone.dart';
import 'package:zerodoc/shared/widgets/tool_screen_shell.dart';

/// Rotate & Reorder: picks a file then opens the Workbench directly.
class RotatePage extends ConsumerWidget {
  const RotatePage({
    super.key,
    this.initialFilePath,
    this.initialFileName,
  });

  final String? initialFilePath;
  final String? initialFileName;

  Future<void> _pickAndOpen(BuildContext context, WidgetRef ref) async {
    final fileService = ref.read(fileServiceProvider);
    final picked = await fileService.pickPdf();
    if (picked == null) return;

    if (!context.mounted) return;
    await context.push('/workbench', extra: {
      'filePath': picked.path,
      'fileName': picked.uri.pathSegments.last,
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ToolScreenShell(
      title: 'Rotate & Reorder',
      fileSection: FileDropZone(
        onTap: () async {
          try {
            await _pickAndOpen(context, ref);
          } on Exception catch (e) {
            if (context.mounted) {
              AppSnackBar.show(context, message: '$e', isError: true);
            }
          }
        },
        label: 'Import PDF to open in Workbench',
      ),
      actionLabel: 'Open in Workbench',
      onAction: null,
    );
  }
}
