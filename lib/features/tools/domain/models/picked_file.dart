import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:zerodoc/features/home/domain/entities/desk_file.dart';

/// Represents a file selected for processing in a tool.
///
/// It always contains the underlying physical [File] to process.
/// If it was selected from the Workspace/Desk, it will also contain the [DeskFile] entity,
/// which allows us to know its identity for features like "Keep originals".
@immutable
class PickedFile {
  const PickedFile({
    required this.file,
    required this.name,
    this.deskFile,
    this.pageCount,
  });

  /// The physical file to process.
  final File file;

  /// The display name of the file.
  final String name;

  /// The metadata if this file came from the Desk. Null if from the device system.
  final DeskFile? deskFile;

  /// The number of pages if known.
  final int? pageCount;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PickedFile &&
          runtimeType == other.runtimeType &&
          file.path == other.file.path &&
          deskFile?.id == other.deskFile?.id;

  @override
  int get hashCode => Object.hash(file.path, deskFile?.id);
}
