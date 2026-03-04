import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:zerodoc/core/constants/app_spacing.dart';
import 'package:zerodoc/core/theme/app_colors.dart';
import 'package:zerodoc/core/theme/app_typography.dart';
import 'package:zerodoc/shared/providers/file_service_provider.dart';
import 'package:zerodoc/shared/providers/pdf_edit_service_provider.dart';
import 'package:zerodoc/shared/widgets/app_snackbar.dart';
import 'package:zerodoc/shared/widgets/file_drop_zone.dart';
import 'package:zerodoc/shared/widgets/imported_file_card.dart';
import 'package:zerodoc/shared/widgets/tool_screen_shell.dart';

class UnlockPage extends ConsumerStatefulWidget {
  const UnlockPage({super.key});

  @override
  ConsumerState<UnlockPage> createState() => _UnlockPageState();
}

class _UnlockPageState extends ConsumerState<UnlockPage> {
  File? _file;
  String? _fileName;
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isProcessing = false;

  bool get _canUnlock =>
      _file != null && _passwordController.text.isNotEmpty;

  Future<void> _pickFile() async {
    final fileService = ref.read(fileServiceProvider);
    final picked = await fileService.pickPdf();
    if (picked == null) return;

    setState(() {
      _file = picked;
      _fileName = picked.uri.pathSegments.last;
    });
  }

  void _removeFile() {
    setState(() {
      _file = null;
      _fileName = null;
    });
  }

  Future<void> _unlock() async {
    if (!_canUnlock) return;
    setState(() => _isProcessing = true);

    try {
      final pdfEditService = ref.read(pdfEditServiceProvider);
      final pdfBytes = await _file!.readAsBytes();
      final outputBytes = await pdfEditService.unlockPdf(
        pdfBytes,
        _passwordController.text,
      );

      final dir = await getApplicationDocumentsDirectory();
      const uuid = Uuid();
      final baseName = _fileName?.replaceAll(RegExp(r'\.pdf$'), '') ?? 'file';
      final outputName =
          '${baseName}_unlocked_${uuid.v4().substring(0, 8)}.pdf';
      final outputFile = File('${dir.path}/$outputName');
      await outputFile.writeAsBytes(outputBytes);

      if (!mounted) return;

      await context.push('/result', extra: {
        'outputPath': outputFile.path,
        'fileName': outputName,
        'showOpenInWorkbench': true,
      });
    } on Exception catch (e) {
      if (mounted) {
        final message = e.toString().contains('password')
            ? 'Wrong password'
            : 'Unlock failed: $e';
        AppSnackBar.show(context, message: message, isError: true);
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ToolScreenShell(
      title: 'Unlock PDF',
      fileSection: _buildFileSection(),
      optionsSection: _file != null ? _buildOptions() : null,
      actionLabel: 'Unlock',
      onAction: _canUnlock ? _unlock : null,
      isActionEnabled: _canUnlock,
      isLoading: _isProcessing,
    );
  }

  Widget _buildFileSection() {
    if (_file != null) {
      return ImportedFileCard(
        fileName: _fileName ?? '',
        onRemove: _removeFile,
      );
    }
    return FileDropZone(onTap: _pickFile);
  }

  Widget _buildOptions() {
    final c = AppColors.of(context);
    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: c.paperCard,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Enter Password',
            style: AppTypography.label(color: c.ink),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            onChanged: (_) => setState(() {}),
            style: AppTypography.body(color: c.ink),
            decoration: InputDecoration(
              hintText: 'PDF password',
              suffixIcon: IconButton(
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_rounded,
                  color: c.inkMuted,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
