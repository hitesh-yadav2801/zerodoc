abstract final class ToolRoutes {
  static const merge = 'merge';
  static const split = 'split';
  static const reorder = 'reorder';
  static const rotate = 'rotate';
  static const compress = 'compress';
  static const grayscale = 'grayscale';
  static const encrypt = 'encrypt';
  static const unlock = 'unlock';
  static const sanitize = 'sanitize';
  static const imgToPdf = 'img-to-pdf';
  static const pdfToImg = 'pdf-to-img';
  static const ocr = 'ocr';
  static const sign = 'sign';
  static const watermark = 'watermark';
  static const pageNumbers = 'page-numbers';

  static String path(String toolId) => '/tool/$toolId';

  static String displayName(String toolId) {
    return switch (toolId) {
      merge => 'Merge PDFs',
      split => 'Split PDF',
      reorder => 'Reorder Pages',
      rotate => 'Rotate Pages',
      compress => 'Compress PDF',
      grayscale => 'Grayscale',
      encrypt => 'Encrypt PDF',
      unlock => 'Unlock PDF',
      sanitize => 'Sanitize Metadata',
      imgToPdf => 'Image to PDF',
      pdfToImg => 'PDF to Image',
      ocr => 'OCR',
      sign => 'Sign',
      watermark => 'Watermark',
      pageNumbers => 'Page Numbers',
      _ => toolId,
    };
  }
}
