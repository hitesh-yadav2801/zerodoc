import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zerodoc/core/errors/failure.dart';
import 'package:zerodoc/features/home/data/datasources/desk_local_datasource.dart';
import 'package:zerodoc/features/home/data/repositories/desk_repository_impl.dart';
import 'package:zerodoc/features/home/domain/entities/desk_file.dart';
import 'package:zerodoc/features/home/domain/repositories/desk_repository.dart';
import 'package:zerodoc/shared/providers/file_service_provider.dart';
import 'package:zerodoc/shared/providers/pdf_service_provider.dart';
import 'package:zerodoc/shared/providers/shared_preferences_provider.dart';

final deskRepositoryProvider = Provider<DeskRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  final pdfService = ref.watch(pdfServiceProvider);
  final fileService = ref.watch(fileServiceProvider);

  return DeskRepositoryImpl(
    datasource: DeskLocalDatasource(prefs),
    pdfService: pdfService,
    fileService: fileService,
  );
});

final deskProvider =
    AsyncNotifierProvider<DeskNotifier, List<DeskFile>>(DeskNotifier.new);

class DeskNotifier extends AsyncNotifier<List<DeskFile>> {
  DeskRepository get _repository => ref.read(deskRepositoryProvider);

  @override
  Future<List<DeskFile>> build() async {
    final result = await _repository.getDeskFiles();
    return result.fold(
      (failure) => throw Exception(failure.message),
      (files) => files,
    );
  }

  Future<Failure?> importFile() async {
    final fileService = ref.read(fileServiceProvider);
    final picked = await fileService.pickPdf();
    if (picked == null) return null;

    final result = await _repository.addFile(picked);
    return result.fold(
      (failure) => failure,
      (deskFile) {
        final current = state.value ?? [];
        state = AsyncData([deskFile, ...current]);
        return null;
      },
    );
  }

  Future<DeskFile?> removeFile(String id) async {
    final current = state.value ?? [];
    final file = current.where((f) => f.id == id).firstOrNull;
    if (file == null) return null;

    state = AsyncData(current.where((f) => f.id != id).toList());

    final result = await _repository.removeFile(id);
    return result.fold(
      (failure) {
        state = AsyncData(current);
        return null;
      },
      (_) => file,
    );
  }

  Future<void> undoRemove(DeskFile file) async {
    final sourceFile = File(file.path);
    final result = await _repository.addFile(sourceFile);
    result.fold(
      (_) {},
      (restored) {
        final current = state.value ?? [];
        state = AsyncData([restored, ...current]);
      },
    );
  }

  Future<Failure?> addFileDirectly(File file) async {
    final result = await _repository.addFile(file);
    return result.fold(
      (failure) => failure,
      (deskFile) {
        final current = state.value ?? [];
        state = AsyncData([deskFile, ...current]);
        return null;
      },
    );
  }
}
