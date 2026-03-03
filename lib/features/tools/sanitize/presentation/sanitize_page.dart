import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:zerodoc/core/constants/app_spacing.dart';
import 'package:zerodoc/core/theme/app_colors.dart';
import 'package:zerodoc/core/theme/app_typography.dart';
import 'package:zerodoc/shared/providers/file_service_provider.dart';
import 'package:zerodoc/shared/providers/pdf_edit_service_provider.dart';
import 'package:zerodoc/shared/widgets/app_snackbar.dart';
import 'package:zerodoc/shared/widgets/file_drop_zone.dart';
import 'package:zerodoc/shared/widgets/imported_file_card.dart';
import 'package:zerodoc/shared/widgets/tool_screen_shell.dart';

class SanitizePage extends ConsumerStatefulWidget {
  const SanitizePage({super.key});

  @override
  ConsumerState<SanitizePage> createState() => _SanitizePageState();
}

class _SanitizePageState extends ConsumerState<SanitizePage> {
  File? _file;
  String? _fileName;
  bool _isProcessing = false;

  Future<void> _pickFile() async {
    final fileService = ref.read(fileServiceProvider);
    final picked = await fileService.pickPdf();
    if (picked == null) return;

    setState(() {
      _file = picked;
      _fileName = picked.uri.pathSegments.last;
    });
  }

  void _removeFile() {
    setState(() {
      _file = null;
      _fileName = null;
    });
  }

  Future<void> _sanitize() async {
    if (_file == null) return;
    setState(() => _isProcessing = true);

    try {
      final pdfEditService = ref.read(pdfEditServiceProvider);
      final pdfBytes = await _file!.readAsBytes();
      final outputBytes = await pdfEditService.sanitizeMetadata(pdfBytes);

      final dir = await getApplicationDocumentsDirectory();
      const uuid = Uuid();
      final baseName = _fileName?.replaceAll(RegExp(r'\.pdf$'), '') ?? 'file';
      final outputName =
          '${baseName}_sanitized_${uuid.v4().substring(0, 8)}.pdf';
      final outputFile = File('${dir.path}/$outputName');
      await outputFile.writeAsBytes(outputBytes);

      if (!mounted) return;

      await context.push('/result', extra: {
        'outputPath': outputFile.path,
        'fileName': outputName,
        'showOpenInWorkbench': false,
      });
    } on Exception catch (e) {
      if (mounted) {
        AppSnackBar.show(
          context,
          message: 'Sanitization failed: $e',
          isError: true,
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ToolScreenShell(
      title: 'Sanitize Metadata',
      fileSection: _buildFileSection(),
      optionsSection: _file != null ? _buildInfo() : null,
      actionLabel: 'Sanitize',
      onAction: _file != null ? _sanitize : null,
      isActionEnabled: _file != null,
      isLoading: _isProcessing,
    );
  }

  Widget _buildFileSection() {
    if (_file != null) {
      return ImportedFileCard(
        fileName: _fileName ?? '',
        onRemove: _removeFile,
      );
    }
    return FileDropZone(onTap: _pickFile);
  }

  Widget _buildInfo() {
    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.paperCard,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What gets removed',
            style: AppTypography.label(color: AppColors.ink),
          ),
          const SizedBox(height: 12),
          _infoRow(Icons.person_rounded, 'Author'),
          _infoRow(Icons.title_rounded, 'Title & Subject'),
          _infoRow(Icons.tag_rounded, 'Keywords'),
          _infoRow(Icons.code_rounded, 'Creator & Producer'),
          _infoRow(Icons.calendar_today_rounded, 'Creation & Modification dates'),
          const SizedBox(height: 12),
          Text(
            'The PDF content itself is not modified.',
            style: AppTypography.caption(color: AppColors.inkMuted),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.slate),
          const SizedBox(width: 10),
          Text(label, style: AppTypography.body(color: AppColors.ink)),
        ],
      ),
    );
  }
}
