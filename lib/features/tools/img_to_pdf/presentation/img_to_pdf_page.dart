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
import 'package:zerodoc/shared/widgets/app_snackbar.dart';
import 'package:zerodoc/shared/widgets/tool_screen_shell.dart';

class ImgToPdfPage extends ConsumerStatefulWidget {
  const ImgToPdfPage({super.key});

  @override
  ConsumerState<ImgToPdfPage> createState() => _ImgToPdfPageState();
}

class _ImgToPdfPageState extends ConsumerState<ImgToPdfPage> {
  final _images = <File>[];
  bool _isProcessing = false;

  Future<void> _pickImages() async {
    final fileService = ref.read(fileServiceProvider);
    final picked = await fileService.pickImages();
    if (picked.isEmpty) return;

    setState(() => _images.addAll(picked));
  }

  void _removeImage(int index) {
    setState(() => _images.removeAt(index));
  }

  Future<void> _convert() async {
    if (_images.isEmpty) return;
    setState(() => _isProcessing = true);

    try {
      final pdfEditService = ref.read(pdfEditServiceProvider);
      final imageBytesList = <Uint8List>[];
      for (final img in _images) {
        imageBytesList.add(await img.readAsBytes());
      }

      final outputBytes = await pdfEditService.imagesToPdf(imageBytesList);

      final dir = await getApplicationDocumentsDirectory();
      const uuid = Uuid();
      final outputName = 'images_${uuid.v4().substring(0, 8)}.pdf';
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
        AppSnackBar.show(
          context,
          message: 'Conversion failed: $e',
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
      title: 'Image to PDF',
      fileSection: _buildFileSection(),
      actionLabel: 'Create PDF',
      onAction: _images.isNotEmpty ? _convert : null,
      isActionEnabled: _images.isNotEmpty,
      isLoading: _isProcessing,
    );
  }

  Widget _buildFileSection() {
    final c = AppColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_images.isNotEmpty) ...[
          SizedBox(
            height: 100,
            child: ReorderableListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _images.length,
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  var adj = newIndex;
                  if (oldIndex < adj) adj--;
                  final item = _images.removeAt(oldIndex);
                  _images.insert(adj, item);
                });
              },
              itemBuilder: (context, index) {
                return Padding(
                  key: ValueKey(_images[index].path),
                  padding: const EdgeInsets.only(right: 8),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(
                          AppSpacing.thumbnailRadius,
                        ),
                        child: Image.file(
                          _images[index],
                          width: 80,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 2,
                        right: 2,
                        child: GestureDetector(
                          onTap: () => _removeImage(index),
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: c.ink,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              size: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${_images.length} image${_images.length == 1 ? '' : 's'} — drag to reorder',
            style: AppTypography.caption(color: c.inkMuted),
          ),
          const SizedBox(height: 12),
        ],
        GestureDetector(
          onTap: _pickImages,
          child: Container(
            width: double.infinity,
            height: 80,
            decoration: BoxDecoration(
              color: c.paperCard,
              borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
              border: Border.all(
                color: c.ink.withValues(alpha: 0.15),
              ),
            ),
            child: Center(
              child: Text(
                _images.isEmpty ? 'Tap to import images' : '+ Add more images',
                style: AppTypography.body(color: c.inkMuted),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
