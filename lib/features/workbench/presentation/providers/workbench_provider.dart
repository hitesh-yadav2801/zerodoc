import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zerodoc/core/errors/failure.dart';
import 'package:zerodoc/features/home/presentation/providers/desk_provider.dart';
import 'package:zerodoc/features/workbench/domain/entities/page_state.dart';
import 'package:zerodoc/shared/providers/pdf_edit_service_provider.dart';
import 'package:zerodoc/shared/providers/pdf_service_provider.dart';

@immutable
class WorkbenchState {
  const WorkbenchState({
    required this.filePath,
    required this.fileName,
    required this.pages,
    this.isReorderMode = false,
  });

  final String filePath;
  final String fileName;
  final List<PageState> pages;
  final bool isReorderMode;

  bool get hasSelection => pages.any((p) => p.isSelected);
  List<int> get selectedIndices =>
      pages.asMap().entries.where((e) => e.value.isSelected).map((e) => e.key).toList();

  WorkbenchState copyWith({
    String? filePath,
    String? fileName,
    List<PageState>? pages,
    bool? isReorderMode,
  }) {
    return WorkbenchState(
      filePath: filePath ?? this.filePath,
      fileName: fileName ?? this.fileName,
      pages: pages ?? this.pages,
      isReorderMode: isReorderMode ?? this.isReorderMode,
    );
  }
}

final workbenchProvider = AsyncNotifierProvider.family<
    WorkbenchNotifier, WorkbenchState, ({String filePath, String fileName})>(
  WorkbenchNotifier.new,
);

class WorkbenchNotifier extends FamilyAsyncNotifier<WorkbenchState,
    ({String filePath, String fileName})> {
  @override
  Future<WorkbenchState> build(
    ({String filePath, String fileName}) arg,
  ) async {
    final pdfService = ref.read(pdfServiceProvider);
    final thumbnails = await pdfService.renderAllPages(arg.filePath);

    final pages = List.generate(
      thumbnails.length,
      (i) => PageState(originalIndex: i, thumbnail: thumbnails[i]),
    );

    return WorkbenchState(
      filePath: arg.filePath,
      fileName: arg.fileName,
      pages: pages,
    );
  }

  void toggleSelection(int index) {
    final current = state.valueOrNull;
    if (current == null) return;

    final updatedPages = List<PageState>.from(current.pages);
    updatedPages[index] =
        updatedPages[index].copyWith(isSelected: !updatedPages[index].isSelected);

    state = AsyncData(current.copyWith(pages: updatedPages));
  }

  void selectAll() {
    final current = state.valueOrNull;
    if (current == null) return;

    state = AsyncData(
      current.copyWith(
        pages: current.pages.map((p) => p.copyWith(isSelected: true)).toList(),
      ),
    );
  }

  void deselectAll() {
    final current = state.valueOrNull;
    if (current == null) return;

    state = AsyncData(
      current.copyWith(
        pages: current.pages.map((p) => p.copyWith(isSelected: false)).toList(),
        isReorderMode: false,
      ),
    );
  }

  Future<void> rotateSelected(int degrees) async {
    final current = state.valueOrNull;
    if (current == null) return;

    final pdfService = ref.read(pdfServiceProvider);
    final updatedPages = List<PageState>.from(current.pages);

    for (var i = 0; i < updatedPages.length; i++) {
      if (updatedPages[i].isSelected) {
        final rotated = updatedPages[i].rotateBy(degrees);
        final newThumb = await pdfService.renderPage(
          current.filePath,
          pageIndex: rotated.originalIndex,
        );
        updatedPages[i] = rotated.copyWith(thumbnail: newThumb);
      }
    }

    state = AsyncData(current.copyWith(pages: updatedPages));
  }

  void deleteSelected() {
    final current = state.valueOrNull;
    if (current == null) return;

    final remaining = current.pages.where((p) => !p.isSelected).toList();
    if (remaining.isEmpty) return;

    state = AsyncData(current.copyWith(pages: remaining));
  }

  void reorder(int oldIndex, int newIndex) {
    final current = state.valueOrNull;
    if (current == null) return;

    final pages = List<PageState>.from(current.pages);
    var adjustedNew = newIndex;
    if (oldIndex < adjustedNew) adjustedNew--;
    final item = pages.removeAt(oldIndex);
    pages.insert(adjustedNew, item);

    state = AsyncData(current.copyWith(pages: pages));
  }

  void toggleReorderMode() {
    final current = state.valueOrNull;
    if (current == null) return;

    final entering = !current.isReorderMode;
    state = AsyncData(
      current.copyWith(
        isReorderMode: entering,
        pages: entering
            ? current.pages.map((p) => p.copyWith(isSelected: false)).toList()
            : current.pages,
      ),
    );
  }

  void rename(String newName) {
    final current = state.valueOrNull;
    if (current == null) return;

    final sanitized = newName.trim();
    if (sanitized.isEmpty) return;

    final name = sanitized.endsWith('.pdf') ? sanitized : '$sanitized.pdf';
    state = AsyncData(current.copyWith(fileName: name));
  }

  /// Returns `(null, outputPath)` on success, or `(failure, null)` on error.
  Future<(Failure?, String?)> saveAsNewCopy() async {
    final current = state.valueOrNull;
    if (current == null) return (const Failure('No data to save.'), null);

    try {
      final pdfEditService = ref.read(pdfEditServiceProvider);
      final originalBytes = await File(current.filePath).readAsBytes();
      final outputBytes =
          await pdfEditService.applyChanges(originalBytes, current.pages);

      final tempFile = File(
        '${File(current.filePath).parent.path}/${current.fileName}',
      );
      await tempFile.writeAsBytes(outputBytes);

      await ref.read(deskProvider.notifier).addFileDirectly(tempFile);

      return (null, tempFile.path);
    } on Exception catch (e) {
      return (Failure('Failed to save: $e'), null);
    }
  }

  /// Returns `(null, outputPath)` on success, or `(failure, null)` on error.
  Future<(Failure?, String?)> extractSelected() async {
    final current = state.valueOrNull;
    if (current == null) return (const Failure('No data.'), null);

    final selected = current.pages.where((p) => p.isSelected).toList();
    if (selected.isEmpty) return (const Failure('No pages selected.'), null);

    try {
      final pdfEditService = ref.read(pdfEditServiceProvider);
      final originalBytes = await File(current.filePath).readAsBytes();
      final indices = selected.map((p) => p.originalIndex).toList();
      final outputBytes =
          await pdfEditService.extractPages(originalBytes, indices);

      final baseName =
          current.fileName.replaceAll(RegExp(r'\.pdf$'), '');
      final extractName = '${baseName}_extract.pdf';
      final tempFile = File(
        '${File(current.filePath).parent.path}/$extractName',
      );
      await tempFile.writeAsBytes(outputBytes);

      await ref.read(deskProvider.notifier).addFileDirectly(tempFile);

      return (null, tempFile.path);
    } on Exception catch (e) {
      return (Failure('Failed to extract: $e'), null);
    }
  }
}
