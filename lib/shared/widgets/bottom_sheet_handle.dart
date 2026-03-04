import 'package:flutter/material.dart';
import 'package:zerodoc/core/theme/app_colors.dart';

class BottomSheetHandle extends StatelessWidget {
  const BottomSheetHandle({super.key});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: c.inkMuted,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
