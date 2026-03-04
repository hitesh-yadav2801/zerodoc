import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zerodoc/core/constants/app_spacing.dart';
import 'package:zerodoc/core/constants/app_strings.dart';
import 'package:zerodoc/core/theme/app_colors.dart';
import 'package:zerodoc/core/theme/app_typography.dart';
import 'package:zerodoc/shared/providers/theme_mode_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = AppColors.of(context);
    final themeMode = ref.watch(themeModeProvider);

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
                  value: true,
                  onChanged: (_) {},
                ),
                const Divider(indent: 16, endIndent: 16),
                _DisclosureRow(
                  title: 'Default compression',
                  value: 'Medium',
                  onTap: () {},
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
                  value: '1.0.0',
                  showArrow: false,
                  onTap: () {},
                ),
                const Divider(indent: 16, endIndent: 16),
                _DisclosureRow(
                  title: 'Privacy Policy',
                  onTap: () {},
                ),
                const Divider(indent: 16, endIndent: 16),
                _DisclosureRow(
                  title: 'Open Source Licenses',
                  onTap: () {
                    showLicensePage(
                      context: context,
                      applicationName: AppStrings.appName,
                      applicationVersion: '1.0.0',
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xxxl),

          Center(
            child: TextButton(
              onPressed: () {},
              child: Text(
                'Clear processed files',
                style: AppTypography.label(color: c.terracotta),
              ),
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

  void _showThemePicker(
    BuildContext context,
    WidgetRef ref,
    ThemeMode current,
  ) {
    final c = AppColors.of(context);
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
    );
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
