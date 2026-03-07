import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zerodoc/core/constants/app_spacing.dart';
import 'package:zerodoc/core/constants/app_strings.dart';
import 'package:zerodoc/core/constants/compression_level.dart';
import 'package:zerodoc/core/theme/app_colors.dart';
import 'package:zerodoc/core/theme/app_typography.dart';
import 'package:zerodoc/shared/providers/app_version_provider.dart';
import 'package:zerodoc/shared/providers/default_compression_provider.dart';
import 'package:zerodoc/shared/providers/keep_originals_provider.dart';
import 'package:zerodoc/shared/providers/theme_mode_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = AppColors.of(context);
    final themeMode = ref.watch(themeModeProvider);
    final keepOriginals = ref.watch(keepOriginalsProvider);
    final compression = ref.watch(defaultCompressionProvider);
    final version = ref.watch(appVersionProvider).value ?? '\u2026';

    return SafeArea(
      child: ListView(
        padding: AppSpacing.pagePadding.copyWith(top: 24),
        children: [
          Text(
            'Settings',
            style: AppTypography.pageTitle(color: c.ink),
          ),
          const SizedBox(height: AppSpacing.xxl),

          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: c.sageTint,
              borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.shield_outlined,
                  color: c.sage,
                  size: AppSpacing.iconSm,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Offline mode active.',
                        style: AppTypography.label(color: c.ink),
                      ),
                      Text(
                        'No data leaves this device.',
                        style: AppTypography.caption(color: c.inkMuted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),

          Text(
            'Preferences',
            style: AppTypography.label(color: c.inkMuted),
          ),
          const SizedBox(height: AppSpacing.md),
          Card(
            child: Column(
              children: [
                _ToggleRow(
                  title: 'Keep originals after processing',
                  value: keepOriginals,
                  onChanged: (_) =>
                      ref.read(keepOriginalsProvider.notifier).toggle(),
                ),
                const Divider(indent: 16, endIndent: 16),
                _DisclosureRow(
                  title: 'Default compression',
                  value: _compressionLabel(compression),
                  onTap: () => _showCompressionPicker(
                    context,
                    ref,
                    compression,
                  ),
                ),
                const Divider(indent: 16, endIndent: 16),
                _DisclosureRow(
                  title: 'App theme',
                  value: _themeModeLabel(themeMode),
                  onTap: () => _showThemePicker(context, ref, themeMode),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),

          Text(
            'About',
            style: AppTypography.label(color: c.inkMuted),
          ),
          const SizedBox(height: AppSpacing.md),
          Card(
            child: Column(
              children: [
                _DisclosureRow(
                  title: 'Version',
                  value: version,
                  showArrow: false,
                  onTap: () {},
                ),
                const Divider(indent: 16, endIndent: 16),
                _DisclosureRow(
                  title: 'Privacy Policy',
                  onTap: () => _showPrivacyPolicy(context),
                ),
                const Divider(indent: 16, endIndent: 16),
                _DisclosureRow(
                  title: 'Open Source Licenses',
                  onTap: () {
                    showLicensePage(
                      context: context,
                      applicationName: AppStrings.appName,
                      applicationVersion: version,
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xxxl),

          Center(
            child: Column(
              children: [
                Text(
                  AppStrings.appName,
                  style: AppTypography.sectionHeader(color: c.slate),
                ),
                const SizedBox(height: 2),
                Text(
                  AppStrings.slogan,
                  style: AppTypography.caption(color: c.inkMuted),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xxxl),
        ],
      ),
    );
  }

  static String _themeModeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }

  static String _compressionLabel(CompressionLevel level) {
    switch (level) {
      case CompressionLevel.low:
        return 'Low';
      case CompressionLevel.medium:
        return 'Medium';
      case CompressionLevel.high:
        return 'High';
    }
  }

  static IconData _compressionIcon(CompressionLevel level) {
    switch (level) {
      case CompressionLevel.low:
        return Icons.compress_outlined;
      case CompressionLevel.medium:
        return Icons.speed_rounded;
      case CompressionLevel.high:
        return Icons.bolt_rounded;
    }
  }

  void _showCompressionPicker(
    BuildContext context,
    WidgetRef ref,
    CompressionLevel current,
  ) {
    final c = AppColors.of(context);
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        backgroundColor: c.paperCard,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      builder: (sheetContext) {
        final sc = AppColors.of(sheetContext);
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
                      color: sc.inkMuted.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Default compression',
                  style: AppTypography.sectionHeader(color: sc.ink),
                ),
                const SizedBox(height: 16),
                for (final level in CompressionLevel.values)
                  _ThemeOption(
                    label: _compressionLabel(level),
                    icon: _compressionIcon(level),
                    isSelected: level == current,
                    onTap: () {
                      unawaited(
                        ref.read(defaultCompressionProvider.notifier).setLevel(level),
                      );
                      Navigator.pop(sheetContext);
                    },
                  ),
              ],
            ),
          ),
        );
      },
    ));
  }

  void _showPrivacyPolicy(BuildContext context) {
    final c = AppColors.of(context);
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        backgroundColor: c.paperCard,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) {
        final sc = AppColors.of(sheetContext);
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          minChildSize: 0.4,
          expand: false,
          builder: (context, scrollController) => SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Container(
                      width: 36,
                      height: 4,
                      decoration: BoxDecoration(
                        color: sc.inkMuted.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Text(
                        AppStrings.privacyPolicy,
                        style: AppTypography.body(color: sc.ink),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ));
  }

  void _showThemePicker(
    BuildContext context,
    WidgetRef ref,
    ThemeMode current,
  ) {
    final c = AppColors.of(context);
    unawaited(
      showModalBottomSheet<void>(
        context: context,
      backgroundColor: c.paperCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) {
        final sc = AppColors.of(sheetContext);
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
                      color: sc.inkMuted.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'App theme',
                  style: AppTypography.sectionHeader(color: sc.ink),
                ),
                const SizedBox(height: 16),
                for (final mode in ThemeMode.values)
                  _ThemeOption(
                    label: _themeModeLabel(mode),
                    icon: _themeModeIcon(mode),
                    isSelected: mode == current,
                    onTap: () {
                      ref
                          .read(themeModeProvider.notifier)
                          .setThemeMode(mode);
                      Navigator.pop(sheetContext);
                    },
                  ),
              ],
            ),
          ),
        );
      },
    ));
  }

  static IconData _themeModeIcon(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return Icons.light_mode_rounded;
      case ThemeMode.dark:
        return Icons.dark_mode_rounded;
      case ThemeMode.system:
        return Icons.settings_brightness_rounded;
    }
  }
}

class _ThemeOption extends StatelessWidget {
  const _ThemeOption({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? c.slate : c.inkMuted, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: AppTypography.body(
                  color: isSelected ? c.ink : c.inkMuted,
                ),
              ),
            ),
            if (isSelected)
              Icon(Icons.check_rounded, color: c.slate, size: 22),
          ],
        ),
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return SizedBox(
      height: 56,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: AppTypography.body(color: c.ink),
              ),
            ),
            Switch(value: value, onChanged: onChanged),
          ],
        ),
      ),
    );
  }
}

class _DisclosureRow extends StatelessWidget {
  const _DisclosureRow({
    required this.title,
    required this.onTap,
    this.value,
    this.showArrow = true,
  });

  final String title;
  final String? value;
  final bool showArrow;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 56,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.body(color: c.ink),
                ),
              ),
              if (value != null)
                Text(
                  value!,
                  style: AppTypography.body(color: c.inkMuted),
                ),
              if (showArrow) ...[
                const SizedBox(width: 4),
                Icon(
                  Icons.chevron_right_rounded,
                  color: c.inkMuted,
                  size: 20,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
