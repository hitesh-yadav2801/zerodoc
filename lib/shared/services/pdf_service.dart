import 'dart:typed_data';
import 'dart:ui';

import 'package:pdfx/pdfx.dart';
import 'package:zerodoc/core/utils/app_logger.dart';

class PdfService {
  Future<int> getPageCount(String filePath) async {
    final document = await PdfDocument.openFile(filePath);
    final count = document.pagesCount;
    await document.close();
    return count;
  }

  Future<Uint8List?> renderPage(
    String filePath, {
    int pageIndex = 0,
    double width = 200,
  }) async {
    try {
      final document = await PdfDocument.openFile(filePath);
      if (pageIndex < 0 || pageIndex >= document.pagesCount) {
        await document.close();
        return null;
      }

      final page = await document.getPage(pageIndex + 1);
      final pageImage = await page.render(
        width: width,
        height: width * (page.height / page.width),
        format: PdfPageImageFormat.png,
      );
      await page.close();
      await document.close();

      return pageImage?.bytes;
    } on Exception catch (e, st) {
      log.e('Failed to render PDF page', error: e, stackTrace: st);
      return null;
    }
  }

  Future<List<Uint8List?>> renderAllPages(
    String filePath, {
    double width = 200,
  }) async {
    try {
      final document = await PdfDocument.openFile(filePath);
      final thumbnails = <Uint8List?>[];

      for (var i = 1; i <= document.pagesCount; i++) {
        try {
          final page = await document.getPage(i);
          final pageImage = await page.render(
            width: width,
            height: width * (page.height / page.width),
            format: PdfPageImageFormat.png,
          );
          await page.close();
          thumbnails.add(pageImage?.bytes);
        } on Exception catch (e) {
          log.w('Failed to render page $i: $e');
          thumbnails.add(null);
        }
      }

      await document.close();
      return thumbnails;
    } on Exception catch (e, st) {
      log.e('Failed to render all pages', error: e, stackTrace: st);
      return [];
    }
  }

  /// Renders all pages as JPEG at the given [quality] (1-100).
  /// Returns a list of (imageBytes, pageSize) pairs.
  Future<List<(Uint8List?, Size)>> renderAllPagesForCompress(
    String filePath, {
    int quality = 60,
  }) async {
    try {
      final document = await PdfDocument.openFile(filePath);
      final results = <(Uint8List?, Size)>[];

      for (var i = 1; i <= document.pagesCount; i++) {
        try {
          final page = await document.getPage(i);
          final pageSize = Size(page.width, page.height);
          final pageImage = await page.render(
            width: page.width,
            height: page.height,
            quality: quality,
          );
          await page.close();
          results.add((pageImage?.bytes, pageSize));
        } on Exception catch (e) {
          log.w('Failed to render page $i for compress: $e');
          results.add((null, Size.zero));
        }
      }

      await document.close();
      return results;
    } on Exception catch (e, st) {
      log.e('Failed to render pages for compress', error: e, stackTrace: st);
      return [];
    }
  }
}
