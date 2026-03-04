/// Compression quality levels for the PDF compress tool.
enum CompressionLevel {
  /// Low compression — high quality output (JPEG quality ~80).
  low,

  /// Medium compression — balanced quality/size (JPEG quality ~50).
  medium,

  /// High compression — smallest output (JPEG quality ~25).
  high,
}
