import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:zerodoc/core/constants/app_spacing.dart';
import 'package:zerodoc/core/constants/compression_level.dart';
import 'package:zerodoc/core/theme/app_colors.dart';
import 'package:zerodoc/core/theme/app_typography.dart';
import 'package:zerodoc/features/home/domain/entities/desk_file.dart';
import 'package:zerodoc/features/home/presentation/widgets/file_source_bottom_sheet.dart';
import 'package:zerodoc/features/tools/domain/models/picked_file.dart';
import 'package:zerodoc/features/tools/presentation/utils/desk_integration_helper.dart';
import 'package:zerodoc/shared/providers/default_compression_provider.dart';
import 'package:zerodoc/shared/providers/file_service_provider.dart';
import 'package:zerodoc/shared/services/file_service.dart';
import 'package:zerodoc/shared/providers/pdf_edit_service_provider.dart';
import 'package:zerodoc/shared/providers/pdf_service_provider.dart';
import 'package:zerodoc/shared/widgets/app_snackbar.dart';
import 'package:zerodoc/shared/widgets/file_drop_zone.dart';
import 'package:zerodoc/shared/widgets/imported_file_card.dart';
import 'package:zerodoc/shared/widgets/tool_screen_shell.dart';

class CompressPage extends ConsumerStatefulWidget {
  const CompressPage({super.key});

  @override
  ConsumerState<CompressPage> createState() => _CompressPageState();
}

class _CompressPageState extends ConsumerState<CompressPage> {
  PickedFile? _file;
  late CompressionLevel _level;
  bool _isProcessing = false;

  int get _jpegQuality => switch (_level) {
    CompressionLevel.low => 80,
    CompressionLevel.medium => 50,
    CompressionLevel.high => 25,
  };

  @override
  void initState() {
    super.initState();
    _level = ref.read(defaultCompressionProvider);
  }

  Future<void> _pickFile() async {
    await FileSourceBottomSheet.show(
      context,
      onPickFromDevice: _pickFromDevice,
      onPickFromDesk: _pickFromDesk,
    );
  }

  Future<void> _pickFromDevice() async {
    final fileService = ref.read(fileServiceProvider);
    final picked = await fileService.pickPdf();
    if (picked == null) return;

    final pdfService = ref.read(pdfServiceProvider);
    final count = await pdfService.getPageCount(picked.path);

    setState(() {
      _file = PickedFile(
        file: picked,
        name: picked.uri.pathSegments.last,
        pageCount: count,
      );
    });
  }

  Future<void> _pickFromDesk() async {
    final selected = await context.push<List<DeskFile>>(
      '/desk-selection',
      // allowMultiple defaults to false
    );

    if (selected == null || selected.isEmpty) return;

    final deskFile = selected.first;

    setState(() {
      _file = PickedFile(
        file: File(deskFile.path),
        name: deskFile.name,
        deskFile: deskFile,
        pageCount: deskFile.pageCount,
      );
    });
  }

  void _removeFile() {
    setState(() {
      _file = null;
    });
  }

  Future<void> _compress() async {
    if (_file == null) return;
    setState(() => _isProcessing = true);

    try {
      final pdfService = ref.read(pdfServiceProvider);
      final pdfEditService = ref.read(pdfEditServiceProvider);

      final rendered = await pdfService.renderAllPagesForCompress(
        _file!.file.path,
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
        _file!.file.path,
        images,
        sizes,
      );

      final dir = await getApplicationDocumentsDirectory();
      const uuid = Uuid();
      final baseName = _file?.name.replaceAll(RegExp(r'\.pdf$'), '') ?? 'file';
      final outputName =
          '${baseName}_compressed_${uuid.v4().substring(0, 8)}.pdf';
      final outputFile = File('${dir.path}/$outputName');
      await outputFile.writeAsBytes(outputBytes);

      await DeskIntegrationHelper.handleOutput(
        ref: ref,
        outputFile: outputFile,
        inputs: [_file!],
      );

      if (!mounted) return;

      await context.push(
        '/result',
        extra: {
          'outputPath': outputFile.path,
          'fileName': outputName,
          'showOpenInWorkbench': false,
        },
      );
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
        fileName: _file!.name,
        pageCount: _file!.pageCount,
        sizeBytes: _file!.file.lengthSync(),
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
          if (_file != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                'Original size: ${FileService.formatFileSize(_file!.file.lengthSync())}',
                style: AppTypography.caption(color: c.inkMuted),
              ),
            ),
        ],
      ),
    );
  }
}
