import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';
import 'package:zerodoc/core/errors/failure.dart';
import 'package:zerodoc/core/utils/app_logger.dart';
import 'package:zerodoc/features/home/data/datasources/desk_local_datasource.dart';
import 'package:zerodoc/features/home/data/models/desk_file_model.dart';
import 'package:zerodoc/features/home/domain/entities/desk_file.dart';
import 'package:zerodoc/features/home/domain/repositories/desk_repository.dart';
import 'package:zerodoc/shared/services/file_service.dart';
import 'package:zerodoc/shared/services/pdf_service.dart';

class DeskRepositoryImpl implements DeskRepository {
  DeskRepositoryImpl({
    required this.datasource,
    required this.pdfService,
    required this.fileService,
  });

  final DeskLocalDatasource datasource;
  final PdfService pdfService;
  final FileService fileService;

  static const _uuid = Uuid();

  @override
  Future<Either<Failure, List<DeskFile>>> getDeskFiles() async {
    try {
      final models = datasource.getAll();

      final validModels = <DeskFileModel>[];
      for (final model in models) {
        if (File(model.path).existsSync()) {
          validModels.add(model);
        } else {
          log.w('Stale desk file removed: ${model.name}');
        }
      }

      if (validModels.length != models.length) {
        await datasource.save(validModels);
      }

      final entities = validModels.map((m) => m.toEntity()).toList()
        ..sort((a, b) => b.addedAt.compareTo(a.addedAt));

      return Right(entities);
    } on Exception catch (e, st) {
      log.e('Failed to load desk files', error: e, stackTrace: st);
      return const Left(Failure('Could not load your files.'));
    }
  }

  @override
  Future<Either<Failure, DeskFile>> addFile(File file) async {
    try {
      final localFile = await fileService.copyToLocal(file);
      final pageCount = await pdfService.getPageCount(localFile.path);
      final stat = localFile.statSync();

      final entity = DeskFile(
        id: _uuid.v4(),
        name: localFile.uri.pathSegments.last,
        path: localFile.path,
        pageCount: pageCount,
        sizeBytes: stat.size,
        addedAt: DateTime.now(),
      );

      final current = datasource.getAll()
        ..add(DeskFileModel.fromEntity(entity));
      await datasource.save(current);

      return Right(entity);
    } on Exception catch (e, st) {
      log.e('Failed to add file to desk', error: e, stackTrace: st);
      return const Left(Failure('Could not import this file.'));
    }
  }

  @override
  Future<Either<Failure, Unit>> removeFile(String id) async {
    try {
      final current = datasource.getAll();
      final index = current.indexWhere((m) => m.id == id);

      if (index == -1) {
        return const Left(Failure('File not found.'));
      }

      final removed = current.removeAt(index);
      await datasource.save(current);
      await fileService.deleteLocal(removed.path);

      return const Right(unit);
    } on Exception catch (e, st) {
      log.e('Failed to remove file from desk', error: e, stackTrace: st);
      return const Left(Failure('Could not remove this file.'));
    }
  }

  @override
  Future<Either<Failure, Unit>> clearAll() async {
    try {
      final models = datasource.getAll();
      for (final model in models) {
        await fileService.deleteLocal(model.path);
      }
      await datasource.save([]);
      return const Right(unit);
    } on Exception catch (e, st) {
      log.e('Failed to clear all desk files', error: e, stackTrace: st);
      return const Left(Failure('Could not clear processed files.'));
    }
  }
}
