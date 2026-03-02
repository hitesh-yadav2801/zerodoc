import 'package:flutter/material.dart';
import 'package:zerodoc/core/constants/app_spacing.dart';
import 'package:zerodoc/core/theme/app_colors.dart';
import 'package:zerodoc/core/theme/app_typography.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: AppSpacing.pagePadding.copyWith(top: 24, bottom: 8),
            sliver: SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _greeting,
                    style: AppTypography.pageTitle(
                      color: AppColors.ink,
                    ),
                  ),
                  FloatingActionButton.small(
                    heroTag: 'home_fab',
                    onPressed: () {
                      // TODO: open file picker
                    },
                    child: const Icon(Icons.add_rounded),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: AppSpacing.pagePadding.copyWith(top: 24),
            sliver: SliverToBoxAdapter(
              child: Text(
                'On the Desk',
                style: AppTypography.sectionHeader(
                  color: AppColors.ink,
                ),
              ),
            ),
          ),
          // Empty state
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 100),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.description_outlined,
                      size: 64,
                      color: AppColors.inkMuted.withValues(alpha: 0.4),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'Nothing on the desk yet.',
                      style: AppTypography.body(
                        color: AppColors.inkMuted,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Tap + to import a document.',
                      style: AppTypography.caption(
                        color: AppColors.inkMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
