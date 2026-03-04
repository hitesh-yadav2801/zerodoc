import 'dart:io';
import 'dart:math' as math;

import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:zerodoc/core/utils/app_logger.dart';

class FileService {
  Future<List<File>> pickMultiplePdfs() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: true,
      );

      if (result == null || result.files.isEmpty) return [];

      return result.files
          .where((f) => f.path != null)
          .map((f) => File(f.path!))
          .toList();
    } on Exception catch (e, st) {
      log.e('Failed to pick multiple PDFs', error: e, stackTrace: st);
      return [];
    }
  }

  Future<File?> pickPdf() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result == null || result.files.isEmpty) return null;

      final platformFile = result.files.first;
      if (platformFile.path == null) return null;

      return File(platformFile.path!);
    } on Exception catch (e, st) {
      log.e('Failed to pick PDF', error: e, stackTrace: st);
      return null;
    }
  }

  Future<List<File>> pickImages() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true,
      );

      if (result == null || result.files.isEmpty) return [];

      return result.files
          .where((f) => f.path != null)
          .map((f) => File(f.path!))
          .toList();
    } on Exception catch (e, st) {
      log.e('Failed to pick images', error: e, stackTrace: st);
      return [];
    }
  }

  Future<File> copyToLocal(File source) async {
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = source.uri.pathSegments.last;
    final destination = '${appDir.path}/$fileName';

    if (File(destination).existsSync()) {
      final nameWithoutExt = fileName.replaceAll(RegExp(r'\.pdf$'), '');
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final uniqueName = '${nameWithoutExt}_$timestamp.pdf';
      return source.copy('${appDir.path}/$uniqueName');
    }

    return source.copy(destination);
  }

  Future<void> deleteLocal(String path) async {
    try {
      final file = File(path);
      if (file.existsSync()) {
        file.deleteSync();
      }
    } on Exception catch (e, st) {
      log.e('Failed to delete local file', error: e, stackTrace: st);
    }
  }

  static String formatFileSize(int bytes) {
    if (bytes <= 0) return '0 B';

    const suffixes = ['B', 'KB', 'MB', 'GB'];
    final i = (math.log(bytes) / math.ln2 / 10).floor().clamp(
      0,
      suffixes.length - 1,
    );
    final size = bytes / math.pow(1024, i);

    return '${size.toStringAsFixed(i == 0 ? 0 : 1)} ${suffixes[i]}';
  }
}
