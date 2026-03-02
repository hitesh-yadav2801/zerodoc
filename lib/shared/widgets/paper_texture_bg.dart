import 'package:flutter/material.dart';

/// Wraps a child with a subtle paper-grain texture overlay.
///
/// Uses a noise PNG at very low opacity to simulate paper texture.
/// The texture asset should be placed at `assets/textures/paper_grain.png`.
/// Until the asset is added, this widget renders the child without texture.
class PaperTextureBg extends StatelessWidget {
  const PaperTextureBg({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned.fill(
          child: IgnorePointer(
            child: Opacity(
              opacity: 0.03,
              child: Image.asset(
                'assets/textures/paper_grain.png',
                repeat: ImageRepeat.repeat,
                fit: BoxFit.none,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
