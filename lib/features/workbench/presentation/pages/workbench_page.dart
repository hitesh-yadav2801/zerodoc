import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pdfx/pdfx.dart';
import 'package:zerodoc/core/constants/app_spacing.dart';
import 'package:zerodoc/core/theme/app_colors.dart';
import 'package:zerodoc/core/theme/app_typography.dart';
import 'package:zerodoc/features/workbench/presentation/providers/workbench_provider.dart';
import 'package:zerodoc/features/workbench/presentation/widgets/rename_bottom_sheet.dart';
import 'package:zerodoc/features/workbench/presentation/widgets/tools_bottom_sheet.dart';

class WorkbenchPage extends ConsumerStatefulWidget {
  const WorkbenchPage({
    required this.filePath,
    required this.fileName,
    super.key,
  });

  final String filePath;
  final String fileName;

  @override
  ConsumerState<WorkbenchPage> createState() => _WorkbenchPageState();
}

class _WorkbenchPageState extends ConsumerState<WorkbenchPage> {
  late PdfControllerPinch _pdfController;

  @override
  void initState() {
    super.initState();
    _pdfController = PdfControllerPinch(
      document: PdfDocument.openFile(widget.filePath),
    );
  }

  @override
  void dispose() {
    _pdfController.dispose();
    super.dispose();
  }

  ({String filePath, String fileName}) get _arg =>
      (filePath: widget.filePath, fileName: widget.fileName);

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final state = ref.watch(workbenchProvider(_arg));

    return Scaffold(
      backgroundColor: c.paperBg,
      body: state.when(
        loading: () => Center(
          child: CircularProgressIndicator(color: c.slate),
        ),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 48,
                color: c.terracotta.withValues(alpha: 0.6),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Could not open this file.',
                style: AppTypography.body(color: c.inkMuted),
              ),
              const SizedBox(height: AppSpacing.lg),
              TextButton(
                onPressed: () => context.pop(),
                child: Text(
                  'Go Back',
                  style: AppTypography.label(color: c.slate),
                ),
              ),
            ],
          ),
        ),
        data: (wb) => SafeArea(
          child: Column(
            children: [
              _buildAppBar(context, wb),
              Expanded(
                child: PdfViewPinch(
                  controller: _pdfController,
                  padding: 0,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: state.value != null
          ? FloatingActionButton(
              onPressed: () => _showToolsSheet(context, state.value!),
              backgroundColor: c.sage,
              child: Icon(Icons.build_circle_outlined, color: c.paperBg),
            )
          : null,
    );
  }

  Widget _buildAppBar(
    BuildContext context,
    WorkbenchState wb,
  ) {
    final c = AppColors.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: Icon(Icons.arrow_back_rounded, color: c.ink),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => _showRenameSheet(context, wb.fileName),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      wb.fileName,
                      style: AppTypography.sectionHeader(color: c.ink),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.edit_rounded,
                    size: 16,
                    color: c.inkMuted,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showRenameSheet(
    BuildContext context,
    String currentName,
  ) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.of(context).paperCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => RenameBottomSheet(
        currentName: currentName,
        onRename: (name) =>
            ref.read(workbenchProvider(_arg).notifier).rename(name),
      ),
    );
  }

  void _showToolsSheet(BuildContext context, WorkbenchState wb) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ToolsBottomSheet(
        filePath: wb.filePath,
        fileName: wb.fileName,
      ),
    );
  }
}
