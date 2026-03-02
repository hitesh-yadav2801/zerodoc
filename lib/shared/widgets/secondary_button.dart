import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zerodoc/core/constants/app_durations.dart';
import 'package:zerodoc/core/theme/app_typography.dart';

class SecondaryButton extends StatefulWidget {
  const SecondaryButton({
    required this.label,
    required this.onPressed,
    this.isEnabled = true,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isEnabled;

  @override
  State<SecondaryButton> createState() => _SecondaryButtonState();
}

class _SecondaryButtonState extends State<SecondaryButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown:
          widget.isEnabled ? (_) => setState(() => _pressed = true) : null,
      onTapUp: widget.isEnabled
          ? (_) {
              setState(() => _pressed = false);
              HapticFeedback.lightImpact();
              widget.onPressed?.call();
            }
          : null,
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: AppDurations.cardPress,
        curve: Curves.easeOut,
        child: AnimatedOpacity(
          opacity: widget.isEnabled ? 1.0 : 0.4,
          duration: AppDurations.quickFade,
          child: OutlinedButton(
            onPressed: widget.isEnabled ? widget.onPressed : null,
            child: Text(widget.label, style: AppTypography.button()),
          ),
        ),
      ),
    );
  }
}
