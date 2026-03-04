import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zerodoc/features/home/presentation/providers/desk_provider.dart';
import 'package:zerodoc/features/tools/domain/models/picked_file.dart';
import 'package:zerodoc/shared/providers/keep_originals_provider.dart';

/// Helper to manage the flow of files passing from the Workspace to Tools
/// and handling output creation + "Keep originals" auto-deletion.
abstract final class DeskIntegrationHelper {
  /// Processes the output of a tool:
  /// 1. Adds the newly generated [outputFile] to the Desk (if provided).
  /// 2. If 'keep originals' is false, deletes the [inputs] that originally came from the Desk.
  static Future<void> handleOutput({
    required WidgetRef ref,
    File? outputFile,
    required List<PickedFile> inputs,
  }) async {
    final deskNotifier = ref.read(deskProvider.notifier);
    final keepOriginals = ref.read(keepOriginalsProvider);

    // 1. Add output
    if (outputFile != null) {
      await deskNotifier.addFileDirectly(outputFile);
    }

    // 2. Clear inputs if needed
    if (!keepOriginals) {
      for (final input in inputs) {
        if (input.deskFile != null) {
          await deskNotifier.removeFile(input.deskFile!.id);
        }
      }
    }
  }
}
