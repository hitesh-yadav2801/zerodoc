import 'dart:io';
import 'dart:typed_data';

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
import 'package:zerodoc/shared/providers/pdf_service_provider.dart';
import 'package:zerodoc/shared/services/file_service.dart';
import 'package:zerodoc/shared/widgets/app_snackbar.dart';
import 'package:zerodoc/shared/widgets/file_drop_zone.dart';
import 'package:zerodoc/shared/widgets/imported_file_card.dart';
import 'package:zerodoc/shared/widgets/tool_screen_shell.dart';

enum CompressionLevel { low, medium, high }

class CompressPage extends ConsumerStatefulWidget {
  const CompressPage({super.key});

  @override
  ConsumerState<CompressPage> createState() => _CompressPageState();
}

class _CompressPageState extends ConsumerState<CompressPage> {
  File? _file;
  String? _fileName;
  int? _pageCount;
  int? _sizeBytes;
  CompressionLevel _level = CompressionLevel.medium;
  bool _isProcessing = false;

  int get _jpegQuality => switch (_level) {
        CompressionLevel.low => 80,
        CompressionLevel.medium => 50,
        CompressionLevel.high => 25,
      };

  Future<void> _pickFile() async {
    final fileService = ref.read(fileServiceProvider);
    final picked = await fileService.pickPdf();
    if (picked == null) return;

    final pdfService = ref.read(pdfServiceProvider);
    final count = await pdfService.getPageCount(picked.path);
    final stat = picked.statSync();

    setState(() {
      _file = picked;
      _fileName = picked.uri.pathSegments.last;
      _pageCount = count;
      _sizeBytes = stat.size;
    });
  }

  void _removeFile() {
    setState(() {
      _file = null;
      _fileName = null;
      _pageCount = null;
      _sizeBytes = null;
    });
  }

  Future<void> _compress() async {
    if (_file == null) return;
    setState(() => _isProcessing = true);

    try {
      final pdfService = ref.read(pdfServiceProvider);
      final pdfEditService = ref.read(pdfEditServiceProvider);

      final rendered = await pdfService.renderAllPagesForCompress(
        _file!.path,
        quality: _jpegQuality,
      );

      final images = <Uint8List>[];
      final sizes = <Size>[];
      for (final (bytes, size) in rendered) {
        if (bytes != null) {
          images.add(bytes);
          sizes.add(size);
        }
      }

      if (images.isEmpty) throw Exception('No pages could be rendered');

      final outputBytes = await pdfEditService.compressViaRasterize(
        _file!.path,
        images,
        sizes,
      );

      final dir = await getApplicationDocumentsDirectory();
      const uuid = Uuid();
      final baseName = _fileName?.replaceAll(RegExp(r'\.pdf$'), '') ?? 'file';
      final outputName =
          '${baseName}_compressed_${uuid.v4().substring(0, 8)}.pdf';
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
          message: 'Compression failed: $e',
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
      title: 'Compress PDF',
      fileSection: _buildFileSection(),
      optionsSection: _file != null ? _buildOptions() : null,
      actionLabel: 'Compress',
      onAction: _file != null ? _compress : null,
      isActionEnabled: _file != null,
      isLoading: _isProcessing,
    );
  }

  Widget _buildFileSection() {
    if (_file != null) {
      return ImportedFileCard(
        fileName: _fileName ?? '',
        pageCount: _pageCount,
        sizeBytes: _sizeBytes,
        onRemove: _removeFile,
      );
    }
    return FileDropZone(onTap: _pickFile);
  }

  Widget _buildOptions() {
    final c = AppColors.of(context);
    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: c.paperCard,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Compression Level',
            style: AppTypography.label(color: c.ink),
          ),
          const SizedBox(height: 12),
          SegmentedButton<CompressionLevel>(
            segments: const [
              ButtonSegment(
                value: CompressionLevel.low,
                label: Text('Low'),
              ),
              ButtonSegment(
                value: CompressionLevel.medium,
                label: Text('Medium'),
              ),
              ButtonSegment(
                value: CompressionLevel.high,
                label: Text('High'),
              ),
            ],
            selected: {_level},
            onSelectionChanged: (v) => setState(() => _level = v.first),
            style: ButtonStyle(
              foregroundColor: WidgetStateProperty.resolveWith(
                (states) => states.contains(WidgetState.selected)
                    ? Colors.white
                    : c.ink,
              ),
              backgroundColor: WidgetStateProperty.resolveWith(
                (states) => states.contains(WidgetState.selected)
                    ? c.slate
                    : c.paperCard,
              ),
            ),
          ),
          if (_sizeBytes != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                'Original size: ${FileService.formatFileSize(_sizeBytes!)}',
                style: AppTypography.caption(color: c.inkMuted),
              ),
            ),
        ],
      ),
    );
  }

}
