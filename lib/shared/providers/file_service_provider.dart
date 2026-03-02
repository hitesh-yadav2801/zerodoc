import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zerodoc/shared/services/file_service.dart';

final fileServiceProvider = Provider<FileService>((ref) {
  return FileService();
});
