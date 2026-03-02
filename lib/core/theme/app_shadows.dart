import 'package:flutter/material.dart';
import 'package:zerodoc/core/theme/app_colors.dart';

abstract final class AppShadows {
  static List<BoxShadow> get sm => const [
        BoxShadow(
          color: AppColors.shadowSm,
          blurRadius: 8,
          offset: Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get md => const [
        BoxShadow(
          color: AppColors.shadowMd,
          blurRadius: 24,
          offset: Offset(0, 8),
        ),
      ];

  static List<BoxShadow> get lg => const [
        BoxShadow(
          color: AppColors.shadowLg,
          blurRadius: 20,
          offset: Offset(0, 6),
        ),
      ];

  // Dark mode variants
  static List<BoxShadow> get darkSm => const [
        BoxShadow(
          color: AppColors.darkShadowSm,
          blurRadius: 8,
          offset: Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get darkMd => const [
        BoxShadow(
          color: AppColors.darkShadowMd,
          blurRadius: 24,
          offset: Offset(0, 8),
        ),
      ];

  static List<BoxShadow> get darkLg => const [
        BoxShadow(
          color: AppColors.darkShadowLg,
          blurRadius: 20,
          offset: Offset(0, 6),
        ),
      ];
}
