import 'dart:async';

import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:zerodoc/core/router/app_router.dart';
import 'package:zerodoc/core/utils/app_logger.dart';

class IntentHandler {
  StreamSubscription<List<SharedMediaFile>>? _subscription;

  void init() {
    ReceiveSharingIntent.instance
        .getInitialMedia()
        .then(_handleSharedFiles);

    _subscription = ReceiveSharingIntent.instance
        .getMediaStream()
        .listen(_handleSharedFiles);
  }

  void _handleSharedFiles(List<SharedMediaFile> files) {
    if (files.isEmpty) return;

    final pdfFile = files.firstWhere(
      (f) => f.path.endsWith('.pdf'),
      orElse: () => files.first,
    );

    final filePath = pdfFile.path;
    final fileName = filePath.split('/').last;

    log.i('Received shared PDF: $fileName');

    AppRouter.router.push('/workbench', extra: {
      'filePath': filePath,
      'fileName': fileName,
    });
  }

  void dispose() {
    _subscription?.cancel();
  }
}
