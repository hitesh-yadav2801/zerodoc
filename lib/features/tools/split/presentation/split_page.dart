import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:zerodoc/shared/widgets/app_snackbar.dart';
import 'package:zerodoc/shared/widgets/file_drop_zone.dart';
import 'package:zerodoc/shared/widgets/imported_file_card.dart';
import 'package:zerodoc/shared/widgets/tool_screen_shell.dart';

class SplitPage extends ConsumerStatefulWidget {
  const SplitPage({
    super.key,
    this.initialFilePath,
    this.initialFileName,
  });

  final String? initialFilePath;
  final String? initialFileName;

  @override
  ConsumerState<SplitPage> createState() => _SplitPageState();
}

class _SplitPageState extends ConsumerState<SplitPage> {
  File? _file;
  String? _fileName;
  List<Uint8List?> _thumbnails = [];
  final _selected = <int>{};
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialFilePath != null && widget.initialFileName != null) {
      _loadInitialFile();
    }
  }

  Future<void> _loadInitialFile() async {
    final pdfService = ref.read(pdfServiceProvider);
    final thumbs = await pdfService.renderAllPages(widget.initialFilePath!, width: 150);
    if (!mounted) return;
    setState(() {
      _file = File(widget.initialFilePath!);
      _fileName = widget.initialFileName;
      _thumbnails = thumbs;
      _selected.clear();
    });
  }

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
      _selected.clear();
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

  Future<void> _split() async {
    if (_file == null || _selected.isEmpty) return;
    setState(() => _isProcessing = true);

    try {
      final pdfEditService = ref.read(pdfEditServiceProvider);
      final pdfBytes = await _file!.readAsBytes();
      final sortedIndices = _selected.toList()..sort();
      final outputBytes =
          await pdfEditService.extractPages(pdfBytes, sortedIndices);

      final dir = await getApplicationDocumentsDirectory();
      const uuid = Uuid();
      final baseName = _fileName?.replaceAll(RegExp(r'\.pdf$'), '') ?? 'split';
      final outputName = '${baseName}_split_${uuid.v4().substring(0, 8)}.pdf';
      final outputFile = File('${dir.path}/$outputName');
      await outputFile.writeAsBytes(outputBytes);

      if (!mounted) return;

      await context.push('/result', extra: {
        'outputPath': outputFile.path,
        'fileName': outputName,
        'showOpenInWorkbench': true,
      });
    } on Exception catch (e) {
      if (mounted) {
        AppSnackBar.show(context, message: 'Split failed: $e', isError: true);
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ToolScreenShell(
      title: 'Split PDF',
      fileSection: _buildFileSection(),
      optionsSection:
          _thumbnails.isNotEmpty ? _buildPageGrid() : null,
      actionLabel: 'Split (${_selected.length} pages)',
      onAction: _selected.isNotEmpty ? _split : null,
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
    final c = AppColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Select pages to extract',
              style: AppTypography.label(color: c.ink),
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
                style: AppTypography.label(color: c.slate),
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
                  color: c.paperWhite,
                  borderRadius:
                      BorderRadius.circular(AppSpacing.thumbnailRadius),
                  border: isSelected
                      ? Border.all(color: c.slate, width: 2.5)
                      : null,
                  boxShadow: [
                    BoxShadow(
                      color: c.shadowSm,
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
                        Center(
                          child: Icon(Icons.broken_image_rounded,
                              color: c.inkMuted),
                        ),
                      Positioned(
                        right: 4,
                        bottom: 4,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: c.paperBg,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '${index + 1}',
                            style: AppTypography.pageBadge(
                                color: c.inkMuted),
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
