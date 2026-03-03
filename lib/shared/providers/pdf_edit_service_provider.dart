import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zerodoc/shared/services/pdf_edit_service.dart';

final pdfEditServiceProvider = Provider<PdfEditService>((ref) {
  return PdfEditService();
});
