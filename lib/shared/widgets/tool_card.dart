import 'package:flutter/material.dart';
import 'package:zerodoc/core/constants/app_durations.dart';
import 'package:zerodoc/core/constants/app_spacing.dart';
import 'package:zerodoc/core/theme/app_colors.dart';
import 'package:zerodoc/core/theme/app_shadows.dart';
import 'package:zerodoc/core/theme/app_typography.dart';

class ToolCard extends StatefulWidget {
  const ToolCard({
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor,
    super.key,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? iconColor;

  @override
  State<ToolCard> createState() => _ToolCardState();
}

class _ToolCardState extends State<ToolCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1.0,
        duration: AppDurations.cardPress,
        curve: Curves.easeOut,
        child: AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
              color: c.toolCardBg,
              borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
              boxShadow: AppShadows.sm(context),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  widget.icon,
                  size: AppSpacing.iconLg,
                  color: widget.iconColor ?? c.slate,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  widget.label,
                  style: AppTypography.chip(color: c.ink),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
