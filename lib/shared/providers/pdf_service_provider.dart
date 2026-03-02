import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zerodoc/shared/services/pdf_service.dart';

final pdfServiceProvider = Provider<PdfService>((ref) {
  return PdfService();
});
