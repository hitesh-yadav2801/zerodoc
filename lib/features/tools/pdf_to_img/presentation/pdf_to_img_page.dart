import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';
import 'package:zerodoc/core/constants/app_spacing.dart';
import 'package:zerodoc/core/theme/app_colors.dart';
import 'package:zerodoc/core/theme/app_typography.dart';
import 'package:zerodoc/shared/providers/file_service_provider.dart';
import 'package:zerodoc/shared/providers/pdf_service_provider.dart';
import 'package:zerodoc/shared/widgets/app_snackbar.dart';
import 'package:zerodoc/shared/widgets/file_drop_zone.dart';
import 'package:zerodoc/shared/widgets/imported_file_card.dart';
import 'package:zerodoc/shared/widgets/tool_screen_shell.dart';

class PdfToImgPage extends ConsumerStatefulWidget {
  const PdfToImgPage({super.key});

  @override
  ConsumerState<PdfToImgPage> createState() => _PdfToImgPageState();
}

class _PdfToImgPageState extends ConsumerState<PdfToImgPage> {
  File? _file;
  String? _fileName;
  List<Uint8List?> _thumbnails = [];
  final _selected = <int>{};
  bool _isProcessing = false;

  Future<void> _pickFile() async {
    final fileService = ref.read(fileServiceProvider);
    final picked = await fileService.pickPdf();
    if (picked == null) return;

    final pdfService = ref.read(pdfServiceProvider);
    final thumbs = await pdfService.renderAllPages(picked.path, width: 150);

    setState(() {
      _file = picked;
      _fileName = picked.uri.pathSegments.last;
      _thumbnails = thumbs;
      _selected
        ..clear()
        ..addAll(List.generate(thumbs.length, (i) => i));
    });
  }

  void _removeFile() {
    setState(() {
      _file = null;
      _fileName = null;
      _thumbnails = [];
      _selected.clear();
    });
  }

  void _togglePage(int index) {
    HapticFeedback.lightImpact();
    setState(() {
      if (_selected.contains(index)) {
        _selected.remove(index);
      } else {
        _selected.add(index);
      }
    });
  }

  Future<void> _export() async {
    if (_file == null || _selected.isEmpty) return;
    setState(() => _isProcessing = true);

    try {
      final pdfService = ref.read(pdfServiceProvider);
      final dir = await getApplicationDocumentsDirectory();
      const uuid = Uuid();
      final baseName = _fileName?.replaceAll(RegExp(r'\.pdf$'), '') ?? 'page';
      final outputDir = Directory('${dir.path}/${baseName}_images_${uuid.v4().substring(0, 8)}');
      await outputDir.create();

      final sortedIndices = _selected.toList()..sort();
      final xFiles = <XFile>[];

      for (final index in sortedIndices) {
        final imageBytes = await pdfService.renderPage(
          _file!.path,
          pageIndex: index,
          width: 1200,
        );
        if (imageBytes != null) {
          final imgFile = File('${outputDir.path}/page_${index + 1}.png');
          await imgFile.writeAsBytes(imageBytes);
          xFiles.add(XFile(imgFile.path));
        }
      }

      if (!mounted) return;

      if (xFiles.isEmpty) {
        AppSnackBar.show(context, message: 'No images exported', isError: true);
        return;
      }

      await SharePlus.instance.share(
        ShareParams(files: xFiles, text: 'Pages from $_fileName'),
      );

      if (mounted) {
        AppSnackBar.show(
          context,
          message: '${xFiles.length} images exported',
          isSuccess: true,
        );
      }
    } on Exception catch (e) {
      if (mounted) {
        AppSnackBar.show(
          context,
          message: 'Export failed: $e',
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
      title: 'PDF to Image',
      fileSection: _buildFileSection(),
      optionsSection: _thumbnails.isNotEmpty ? _buildPageGrid() : null,
      actionLabel: 'Export ${_selected.length} images',
      onAction: _selected.isNotEmpty ? _export : null,
      isActionEnabled: _selected.isNotEmpty,
      isLoading: _isProcessing,
    );
  }

  Widget _buildFileSection() {
    if (_file != null) {
      return ImportedFileCard(
        fileName: _fileName ?? '',
        pageCount: _thumbnails.length,
        onRemove: _removeFile,
      );
    }
    return FileDropZone(onTap: _pickFile);
  }

  Widget _buildPageGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Select pages to export',
              style: AppTypography.label(color: AppColors.ink),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  if (_selected.length == _thumbnails.length) {
                    _selected.clear();
                  } else {
                    _selected.addAll(
                      List.generate(_thumbnails.length, (i) => i),
                    );
                  }
                });
              },
              child: Text(
                _selected.length == _thumbnails.length
                    ? 'Deselect All'
                    : 'Select All',
                style: AppTypography.label(color: AppColors.slate),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 0.75,
          ),
          itemCount: _thumbnails.length,
          itemBuilder: (context, index) {
            final isSelected = _selected.contains(index);
            return GestureDetector(
              onTap: () => _togglePage(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: AppColors.paperWhite,
                  borderRadius:
                      BorderRadius.circular(AppSpacing.thumbnailRadius),
                  border: isSelected
                      ? Border.all(color: AppColors.slate, width: 2.5)
                      : null,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadowSm,
                      blurRadius: isSelected ? 12 : 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    isSelected
                        ? AppSpacing.thumbnailRadius - 2
                        : AppSpacing.thumbnailRadius,
                  ),
                  child: Stack(
                    children: [
                      if (_thumbnails[index] != null)
                        Positioned.fill(
                          child: Image.memory(
                            _thumbnails[index]!,
                            fit: BoxFit.contain,
                          ),
                        )
                      else
                        const Center(
                          child: Icon(Icons.broken_image_rounded,
                              color: AppColors.inkMuted),
                        ),
                      Positioned(
                        right: 4,
                        bottom: 4,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: const BoxDecoration(
                            color: AppColors.paperBg,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '${index + 1}',
                            style: AppTypography.pageBadge(
                                color: AppColors.inkMuted),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
