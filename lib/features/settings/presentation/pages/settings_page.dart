import 'package:flutter/material.dart';
import 'package:zerodoc/core/constants/app_spacing.dart';
import 'package:zerodoc/core/constants/app_strings.dart';
import 'package:zerodoc/core/theme/app_colors.dart';
import 'package:zerodoc/core/theme/app_typography.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: AppSpacing.pagePadding.copyWith(top: 24),
        children: [
          Text(
            'Settings',
            style: AppTypography.pageTitle(color: AppColors.ink),
          ),
          const SizedBox(height: AppSpacing.xxl),

          // Privacy card
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.sageTint,
              borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.shield_outlined,
                  color: AppColors.sage,
                  size: AppSpacing.iconSm,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Offline mode active.',
                        style: AppTypography.label(color: AppColors.ink),
                      ),
                      Text(
                        'No data leaves this device.',
                        style: AppTypography.caption(
                          color: AppColors.inkMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),

          // Preferences section
          Text(
            'Preferences',
            style: AppTypography.label(color: AppColors.inkMuted),
          ),
          const SizedBox(height: AppSpacing.md),
          Card(
            child: Column(
              children: [
                _ToggleRow(
                  title: 'Keep originals after processing',
                  value: true,
                  onChanged: (_) {
                    // TODO: wire to preferences provider
                  },
                ),
                const Divider(indent: 16, endIndent: 16),
                _DisclosureRow(
                  title: 'Default compression',
                  value: 'Medium',
                  onTap: () {
                    // TODO: open compression picker sheet
                  },
                ),
                const Divider(indent: 16, endIndent: 16),
                _DisclosureRow(
                  title: 'App theme',
                  value: 'System',
                  onTap: () {
                    // TODO: open theme picker sheet
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),

          // About section
          Text(
            'About',
            style: AppTypography.label(color: AppColors.inkMuted),
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
                  onTap: () {
                    // TODO: navigate to privacy policy
                  },
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
              onPressed: () {
                // TODO: clear processed files
              },
              child: Text(
                'Clear processed files',
                style: AppTypography.label(color: AppColors.terracotta),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xxxl),

          // App branding footer
          Center(
            child: Column(
              children: [
                Text(
                  AppStrings.appName,
                  style: AppTypography.sectionHeader(
                    color: AppColors.slate,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  AppStrings.slogan,
                  style: AppTypography.caption(
                    color: AppColors.inkMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xxxl),
        ],
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
    return SizedBox(
      height: 56,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: AppTypography.body(color: AppColors.ink),
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
                  style: AppTypography.body(color: AppColors.ink),
                ),
              ),
              if (value != null)
                Text(
                  value!,
                  style: AppTypography.body(color: AppColors.inkMuted),
                ),
              if (showArrow) ...[
                const SizedBox(width: 4),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.inkMuted,
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
