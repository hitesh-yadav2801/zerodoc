import 'package:flutter/foundation.dart';

@immutable
class DeskFile {
  const DeskFile({
    required this.id,
    required this.name,
    required this.path,
    required this.pageCount,
    required this.sizeBytes,
    required this.addedAt,
  });

  final String id;
  final String name;
  final String path;
  final int pageCount;
  final int sizeBytes;
  final DateTime addedAt;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeskFile &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'DeskFile(id: $id, name: $name)';
}
