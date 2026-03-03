import 'package:flutter/material.dart';
import 'package:zerodoc/core/constants/app_spacing.dart';
import 'package:zerodoc/core/theme/app_colors.dart';
import 'package:zerodoc/core/theme/app_typography.dart';
import 'package:zerodoc/shared/widgets/bottom_sheet_handle.dart';
import 'package:zerodoc/shared/widgets/ghost_button.dart';
import 'package:zerodoc/shared/widgets/primary_button.dart';

class RenameBottomSheet extends StatefulWidget {
  const RenameBottomSheet({
    required this.currentName,
    required this.onRename,
    super.key,
  });

  final String currentName;
  final ValueChanged<String> onRename;

  @override
  State<RenameBottomSheet> createState() => _RenameBottomSheetState();
}

class _RenameBottomSheetState extends State<RenameBottomSheet> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final nameWithoutExt =
        widget.currentName.replaceAll(RegExp(r'\.pdf$'), '');
    _controller = TextEditingController(text: nameWithoutExt);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.xl,
        right: AppSpacing.xl,
        top: AppSpacing.md,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.xl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const BottomSheetHandle(),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'Rename',
            style: AppTypography.sectionHeader(color: AppColors.ink),
          ),
          const SizedBox(height: AppSpacing.lg),
          TextField(
            controller: _controller,
            autofocus: true,
            style: AppTypography.body(color: AppColors.ink),
            decoration: const InputDecoration(
              hintText: 'File name',
              suffixText: '.pdf',
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          PrimaryButton(
            label: 'Rename',
            onPressed: () {
              final name = _controller.text.trim();
              if (name.isNotEmpty) {
                widget.onRename('$name.pdf');
                Navigator.of(context).pop();
              }
            },
          ),
          const SizedBox(height: AppSpacing.sm),
          GhostButton(
            label: 'Cancel',
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
