import 'package:zerodoc/features/home/domain/entities/desk_file.dart';

class DeskFileModel {
  const DeskFileModel({
    required this.id,
    required this.name,
    required this.path,
    required this.pageCount,
    required this.sizeBytes,
    required this.addedAt,
  });

  factory DeskFileModel.fromJson(Map<String, dynamic> json) {
    return DeskFileModel(
      id: json['id'] as String,
      name: json['name'] as String,
      path: json['path'] as String,
      pageCount: json['pageCount'] as int,
      sizeBytes: json['sizeBytes'] as int,
      addedAt: DateTime.parse(json['addedAt'] as String),
    );
  }

  factory DeskFileModel.fromEntity(DeskFile entity) {
    return DeskFileModel(
      id: entity.id,
      name: entity.name,
      path: entity.path,
      pageCount: entity.pageCount,
      sizeBytes: entity.sizeBytes,
      addedAt: entity.addedAt,
    );
  }

  final String id;
  final String name;
  final String path;
  final int pageCount;
  final int sizeBytes;
  final DateTime addedAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'path': path,
      'pageCount': pageCount,
      'sizeBytes': sizeBytes,
      'addedAt': addedAt.toIso8601String(),
    };
  }

  DeskFile toEntity() {
    return DeskFile(
      id: id,
      name: name,
      path: path,
      pageCount: pageCount,
      sizeBytes: sizeBytes,
      addedAt: addedAt,
    );
  }
}
