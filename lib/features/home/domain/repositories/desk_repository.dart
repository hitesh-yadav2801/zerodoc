import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:zerodoc/core/errors/failure.dart';
import 'package:zerodoc/features/home/domain/entities/desk_file.dart';

abstract class DeskRepository {
  Future<Either<Failure, List<DeskFile>>> getDeskFiles();
  Future<Either<Failure, DeskFile>> addFile(File file);
  Future<Either<Failure, Unit>> removeFile(String id);
}
