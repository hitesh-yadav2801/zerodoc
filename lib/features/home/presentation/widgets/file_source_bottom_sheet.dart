import 'package:flutter/material.dart';
import 'package:zerodoc/core/constants/app_spacing.dart';
import 'package:zerodoc/core/theme/app_colors.dart';
import 'package:zerodoc/core/theme/app_typography.dart';

/// Modal bottom sheet allowing users to choose the source of their imported PDF.
class FileSourceBottomSheet extends StatelessWidget {
  const FileSourceBottomSheet({
    required this.onPickFromDevice,
    required this.onPickFromDesk,
    super.key,
  });

  final VoidCallback onPickFromDevice;
  final VoidCallback onPickFromDesk;

  static Future<void> show(
    BuildContext context, {
    required VoidCallback onPickFromDevice,
    required VoidCallback onPickFromDesk,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.of(context).paperCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => FileSourceBottomSheet(
        onPickFromDevice: onPickFromDevice,
        onPickFromDesk: onPickFromDesk,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: c.inkMuted.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Import PDF',
              style: AppTypography.sectionHeader(color: c.ink),
            ),
            const SizedBox(height: 16),
            _SourceOption(
              icon: Icons.folder_open_rounded,
              title: 'Browse Device',
              subtitle: 'Select a file from your device storage',
              onTap: () {
                Navigator.pop(context);
                onPickFromDevice();
              },
            ),
            const SizedBox(height: 8),
            _SourceOption(
              icon: Icons.grid_view_rounded,
              title: 'Choose from Desk',
              subtitle: 'Select previously processed files',
              onTap: () {
                Navigator.pop(context);
                onPickFromDesk();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SourceOption extends StatelessWidget {
  const _SourceOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: c.inkMuted.withValues(alpha: 0.1)),
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: c.slate.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: c.slate),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTypography.body(color: c.ink)),
                  Text(
                    subtitle,
                    style: AppTypography.caption(color: c.inkMuted),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: c.inkMuted),
          ],
        ),
      ),
    );
  }
}
