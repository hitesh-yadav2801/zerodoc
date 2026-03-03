import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:zerodoc/core/theme/app_colors.dart';
import 'package:zerodoc/core/utils/app_logger.dart';
import 'package:zerodoc/features/result/presentation/widgets/success_card.dart';
import 'package:zerodoc/shared/widgets/app_snackbar.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({
    required this.outputPath,
    required this.fileName,
    this.showOpenInWorkbench = false,
    super.key,
  });

  final String outputPath;
  final String fileName;
  final bool showOpenInWorkbench;

  Future<void> _onSave(BuildContext context) async {
    try {
      final result = await FilePicker.platform.saveFile(
        dialogTitle: 'Save PDF',
        fileName: fileName,
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && context.mounted) {
        await File(outputPath).copy(result);
        if (context.mounted) {
          AppSnackBar.show(context, message: 'Saved!', isSuccess: true);
        }
      }
    } on Exception catch (e) {
      log.e('Save failed', error: e);
      if (context.mounted) {
        AppSnackBar.show(context, message: 'Save failed', isError: true);
      }
    }
  }

  Future<void> _onShare(BuildContext context) async {
    try {
      await Share.shareXFiles([XFile(outputPath)]);
    } on Exception catch (e) {
      log.e('Share failed', error: e);
      if (context.mounted) {
        AppSnackBar.show(context, message: 'Share failed', isError: true);
      }
    }
  }

  void _onOpenInWorkbench(BuildContext context) {
    context.push(
      '/workbench',
      extra: {'filePath': outputPath, 'fileName': fileName},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paperBg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(
                      Icons.close_rounded,
                      color: AppColors.ink,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: SuccessCard(
                  fileName: fileName,
                  onSave: () => _onSave(context),
                  onShare: () => _onShare(context),
                  onOpenInWorkbench:
                      showOpenInWorkbench ? () => _onOpenInWorkbench(context) : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
