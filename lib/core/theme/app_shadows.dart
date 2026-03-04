import 'package:flutter/material.dart';
import 'package:zerodoc/core/theme/app_colors.dart';

abstract final class AppShadows {
  static List<BoxShadow> sm(BuildContext context) {
    final c = AppColors.of(context);
    return [
      BoxShadow(
        color: c.shadowSm,
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ];
  }

  static List<BoxShadow> md(BuildContext context) {
    final c = AppColors.of(context);
    return [
      BoxShadow(
        color: c.shadowMd,
        blurRadius: 24,
        offset: const Offset(0, 8),
      ),
    ];
  }

  static List<BoxShadow> lg(BuildContext context) {
    final c = AppColors.of(context);
    return [
      BoxShadow(
        color: c.shadowLg,
        blurRadius: 20,
        offset: const Offset(0, 6),
      ),
    ];
  }
}
