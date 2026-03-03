import 'dart:typed_data';
import 'dart:ui';

import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:zerodoc/core/utils/app_logger.dart';
import 'package:zerodoc/features/workbench/domain/entities/page_state.dart';

class PdfEditService {
  Future<Uint8List> applyChanges(
    Uint8List pdfBytes,
    List<PageState> pages,
  ) async {
    final source = PdfDocument(inputBytes: pdfBytes);
    final result = PdfDocument();

    for (final page in pages) {
      final template = source.pages[page.originalIndex].createTemplate();
      final sourcePage = source.pages[page.originalIndex];
      final sourceSize = sourcePage.size;

      final isRotated = page.rotation == 90 || page.rotation == 270;
      final newWidth = isRotated ? sourceSize.height : sourceSize.width;
      final newHeight = isRotated ? sourceSize.width : sourceSize.height;

      result.pageSettings
        ..size = Size(newWidth, newHeight)
        ..margins.all = 0;
      final newPage = result.pages.add();
      final graphics = newPage.graphics
        ..save();

      switch (page.rotation) {
        case 90:
          graphics
            ..translateTransform(newWidth, 0)
            ..rotateTransform(90);
        case 180:
          graphics
            ..translateTransform(newWidth, newHeight)
            ..rotateTransform(180);
        case 270:
          graphics
            ..translateTransform(0, newHeight)
            ..rotateTransform(270);
        default:
          break;
      }

      graphics
        ..drawPdfTemplate(
          template,
          Offset.zero,
          Size(sourceSize.width, sourceSize.height),
        )
        ..restore();
    }

    final bytes = Uint8List.fromList(await result.save());
    result.dispose();
    source.dispose();
    return bytes;
  }

  Future<Uint8List> extractPages(
    Uint8List pdfBytes,
    List<int> pageIndices,
  ) async {
    final source = PdfDocument(inputBytes: pdfBytes);
    final result = PdfDocument();

    for (final index in pageIndices) {
      final template = source.pages[index].createTemplate();
      final sourceSize = source.pages[index].size;
      result.pageSettings
        ..size = sourceSize
        ..margins.all = 0;
      final newPage = result.pages.add();
      newPage.graphics.drawPdfTemplate(
        template,
        Offset.zero,
        sourceSize,
      );
    }

    final bytes = Uint8List.fromList(await result.save());
    result.dispose();
    source.dispose();
    return bytes;
  }

  Future<Uint8List> mergeFiles(List<Uint8List> pdfBytesList) async {
    final result = PdfDocument();

    for (final pdfBytes in pdfBytesList) {
      final source = PdfDocument(inputBytes: pdfBytes);
      for (var i = 0; i < source.pages.count; i++) {
        final template = source.pages[i].createTemplate();
        final sourceSize = source.pages[i].size;
        result.pageSettings
          ..size = sourceSize
          ..margins.all = 0;
        final newPage = result.pages.add();
        newPage.graphics.drawPdfTemplate(template, Offset.zero, sourceSize);
      }
      source.dispose();
    }

    final bytes = Uint8List.fromList(await result.save());
    result.dispose();
    return bytes;
  }

  /// Creates a new PDF where each page is a rasterized JPEG image.
  Future<Uint8List> compressViaRasterize(
    String filePath,
    List<Uint8List> pageImages,
    List<Size> pageSizes,
  ) async {
    final result = PdfDocument();

    for (var i = 0; i < pageImages.length; i++) {
      final pageSize = pageSizes[i];
      result.pageSettings
        ..size = pageSize
        ..margins.all = 0;
      final page = result.pages.add();
      final image = PdfBitmap(pageImages[i]);
      page.graphics.drawImage(image, Offset.zero & pageSize);
    }

    final bytes = Uint8List.fromList(await result.save());
    result.dispose();
    return bytes;
  }

  Future<int> getPageCount(Uint8List pdfBytes) async {
    try {
      final doc = PdfDocument(inputBytes: pdfBytes);
      final count = doc.pages.count;
      doc.dispose();
      return count;
    } on Exception catch (e, st) {
      log.e('Failed to get page count from bytes', error: e, stackTrace: st);
      return 0;
    }
  }
}
