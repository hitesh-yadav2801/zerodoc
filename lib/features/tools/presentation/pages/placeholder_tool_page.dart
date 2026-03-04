import 'package:flutter/material.dart';
import 'package:zerodoc/core/constants/tool_routes.dart';
import 'package:zerodoc/core/theme/app_colors.dart';
import 'package:zerodoc/core/theme/app_typography.dart';
import 'package:zerodoc/shared/widgets/file_drop_zone.dart';
import 'package:zerodoc/shared/widgets/tool_screen_shell.dart';

class PlaceholderToolPage extends StatelessWidget {
  const PlaceholderToolPage({required this.toolId, super.key});

  final String toolId;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return ToolScreenShell(
      title: ToolRoutes.displayName(toolId),
      fileSection: const FileDropZone(onTap: _noop),
      optionsSection: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: Text(
            'Coming soon',
            style: AppTypography.body(color: c.inkMuted),
          ),
        ),
      ),
      actionLabel: ToolRoutes.displayName(toolId),
      onAction: null,
    );
  }

  static void _noop() {}
}
