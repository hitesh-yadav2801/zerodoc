import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';

@immutable
class WorkbenchState {
  const WorkbenchState({
    required this.filePath,
    required this.fileName,
  });

  final String filePath;
  final String fileName;

  WorkbenchState copyWith({
    String? filePath,
    String? fileName,
  }) {
    return WorkbenchState(
      filePath: filePath ?? this.filePath,
      fileName: fileName ?? this.fileName,
    );
  }
}

final AsyncNotifierProviderFamily<WorkbenchNotifier, WorkbenchState,
        ({String filePath, String fileName})> workbenchProvider =
    AsyncNotifierProvider.family<WorkbenchNotifier, WorkbenchState,
        ({String filePath, String fileName})>(
  WorkbenchNotifier.new,
);

class WorkbenchNotifier extends AsyncNotifier<WorkbenchState> {
  WorkbenchNotifier(this._arg);

  final ({String filePath, String fileName}) _arg;

  @override
  Future<WorkbenchState> build() async {
    // We only need basic file information for this streamlined viewer.
    return WorkbenchState(
      filePath: _arg.filePath,
      fileName: _arg.fileName,
    );
  }

  void rename(String newName) {
    final current = state.value;
    if (current == null) return;

    final sanitized = newName.trim();
    if (sanitized.isEmpty) return;

    final name = sanitized.endsWith('.pdf') ? sanitized : '$sanitized.pdf';
    state = AsyncData(current.copyWith(fileName: name));
  }
}
