import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zerodoc/core/theme/app_colors.dart';
import 'package:zerodoc/core/theme/app_shadows.dart';

class WorkbenchActionBar extends StatelessWidget {
  const WorkbenchActionBar({
    required this.onRotateLeft,
    required this.onRotateRight,
    required this.onExtract,
    required this.onDelete,
    required this.visible,
    super.key,
  });

  final VoidCallback onRotateLeft;
  final VoidCallback onRotateRight;
  final VoidCallback onExtract;
  final VoidCallback onDelete;
  final bool visible;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return AnimatedSlide(
      offset: visible ? Offset.zero : const Offset(0, 2),
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      child: AnimatedOpacity(
        opacity: visible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: IgnorePointer(
          ignoring: !visible,
          child: Container(
            margin: const EdgeInsets.only(bottom: 24, left: 32, right: 32),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: c.ink,
              borderRadius: BorderRadius.circular(100),
              boxShadow: AppShadows.lg(context),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ActionButton(
                  icon: Icons.rotate_left_rounded,
                  tooltip: 'Rotate Left',
                  onTap: onRotateLeft,
                ),
                _ActionButton(
                  icon: Icons.rotate_right_rounded,
                  tooltip: 'Rotate Right',
                  onTap: onRotateRight,
                ),
                _ActionButton(
                  icon: Icons.content_cut_rounded,
                  tooltip: 'Extract',
                  onTap: onExtract,
                ),
                _ActionButton(
                  icon: Icons.delete_rounded,
                  tooltip: 'Delete',
                  onTap: onDelete,
                  color: c.terracotta,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.color,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: IconButton(
        onPressed: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        icon: Icon(icon, color: color ?? Colors.white, size: 24),
      ),
    );
  }
}
