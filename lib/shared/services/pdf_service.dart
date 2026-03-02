import 'dart:typed_data';

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
}
