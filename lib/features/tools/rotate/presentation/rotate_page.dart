import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zerodoc/features/home/domain/entities/desk_file.dart';
import 'package:zerodoc/features/home/presentation/widgets/file_source_bottom_sheet.dart';
import 'package:zerodoc/shared/providers/file_service_provider.dart';
import 'package:zerodoc/shared/widgets/app_snackbar.dart';
import 'package:zerodoc/shared/widgets/file_drop_zone.dart';
import 'package:zerodoc/shared/widgets/tool_screen_shell.dart';

/// Rotate & Reorder: picks a file then opens the Workbench directly.
class RotatePage extends ConsumerWidget {
  const RotatePage({super.key});

  Future<void> _pickAndOpen(BuildContext context, WidgetRef ref) async {
    await FileSourceBottomSheet.show(
      context,
      onPickFromDevice: () async {
        final fileService = ref.read(fileServiceProvider);
        final picked = await fileService.pickPdf();
        if (picked == null) return;

        if (!context.mounted) return;
        await context.push(
          '/workbench',
          extra: {
            'filePath': picked.path,
            'fileName': picked.uri.pathSegments.last,
          },
        );
      },
      onPickFromDesk: () async {
        final selected = await context.push<List<DeskFile>>('/desk-selection');
        if (selected == null || selected.isEmpty) return;
        final deskFile = selected.first;

        if (!context.mounted) return;
        await context.push(
          '/workbench',
          extra: {
            'filePath': deskFile.path,
            'fileName': deskFile.name,
            'deskFile': deskFile,
          },
        );
      },
    );
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
