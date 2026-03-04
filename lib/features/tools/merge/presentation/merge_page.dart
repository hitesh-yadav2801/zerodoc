import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:zerodoc/core/theme/app_colors.dart';
import 'package:zerodoc/core/theme/app_typography.dart';
import 'package:zerodoc/features/home/domain/entities/desk_file.dart';
import 'package:zerodoc/features/home/presentation/widgets/file_source_bottom_sheet.dart';
import 'package:zerodoc/features/tools/domain/models/picked_file.dart';
import 'package:zerodoc/features/tools/presentation/utils/desk_integration_helper.dart';
import 'package:zerodoc/shared/providers/file_service_provider.dart';
import 'package:zerodoc/shared/providers/pdf_edit_service_provider.dart';
import 'package:zerodoc/shared/providers/pdf_service_provider.dart';
import 'package:zerodoc/shared/widgets/app_snackbar.dart';
import 'package:zerodoc/shared/widgets/file_drop_zone.dart';
import 'package:zerodoc/shared/widgets/imported_file_card.dart';
import 'package:zerodoc/shared/widgets/tool_screen_shell.dart';

class MergePage extends ConsumerStatefulWidget {
  const MergePage({super.key});

  @override
  ConsumerState<MergePage> createState() => _MergePageState();
}

class _MergePageState extends ConsumerState<MergePage> {
  final _files = <PickedFile>[];
  bool _isProcessing = false;

  Future<void> _pickFile() async {
    await FileSourceBottomSheet.show(
      context,
      onPickFromDevice: _pickFromDevice,
      onPickFromDesk: _pickFromDesk,
    );
  }

  Future<void> _pickFromDevice() async {
    final fileService = ref.read(fileServiceProvider);
    final pickedFiles = await fileService.pickMultiplePdfs();
    if (pickedFiles.isEmpty) return;

    final pdfService = ref.read(pdfServiceProvider);

    for (final file in pickedFiles) {
      final pageCount = await pdfService.getPageCount(file.path);
      setState(() {
        _files.add(
          PickedFile(
            file: file,
            name: file.uri.pathSegments.last,
            pageCount: pageCount,
          ),
        );
      });
    }
  }

  Future<void> _pickFromDesk() async {
    final selected = await context.push<List<DeskFile>>(
      '/desk-selection',
      extra: {'allowMultiple': true},
    );

    if (selected == null || selected.isEmpty) return;

    setState(() {
      for (final deskFile in selected) {
        _files.add(
          PickedFile(
            file: File(deskFile.path),
            name: deskFile.name,
            deskFile: deskFile,
            pageCount: deskFile.pageCount,
          ),
        );
      }
    });
  }

  void _removeFile(int index) {
    setState(() => _files.removeAt(index));
  }

  Future<void> _merge() async {
    if (_files.length < 2) return;
    setState(() => _isProcessing = true);

    try {
      final pdfEditService = ref.read(pdfEditServiceProvider);
      final bytesList = <Uint8List>[];
      for (final f in _files) {
        bytesList.add(await f.file.readAsBytes());
      }

      final outputBytes = await pdfEditService.mergeFiles(bytesList);

      final dir = await getApplicationDocumentsDirectory();
      const uuid = Uuid();
      final outputName = 'merged_${uuid.v4().substring(0, 8)}.pdf';
      final outputFile = File('${dir.path}/$outputName');
      await outputFile.writeAsBytes(outputBytes);

      await DeskIntegrationHelper.handleOutput(
        ref: ref,
        outputFile: outputFile,
        inputs: _files,
      );

      if (!mounted) return;

      await context.push(
        '/result',
        extra: {
          'outputPath': outputFile.path,
          'fileName': outputName,
          'showOpenInWorkbench': true,
        },
      );
    } on Exception catch (e) {
      if (mounted) {
        AppSnackBar.show(context, message: 'Merge failed: $e', isError: true);
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ToolScreenShell(
      title: 'Merge PDFs',
      fileSection: _buildFileSection(),
      actionLabel: 'Merge',
      onAction: _files.length >= 2 ? _merge : null,
      isActionEnabled: _files.length >= 2,
      isLoading: _isProcessing,
    );
  }

  Widget _buildFileSection() {
    final c = AppColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < _files.length; i++) ...[
          ImportedFileCard(
            fileName: _files[i].name,
            pageCount: _files[i].pageCount,
            onRemove: () => _removeFile(i),
          ),
          const SizedBox(height: 8),
        ],
        FileDropZone(
          onTap: _pickFile,
          label: _files.isEmpty ? 'Tap to import PDF' : '+ Add another PDF',
        ),
        if (_files.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              '${_files.length} file${_files.length == 1 ? '' : 's'} selected',
              style: AppTypography.caption(color: c.inkMuted),
            ),
          ),
      ],
    );
  }
}
