import 'package:flutter/material.dart';
import 'package:zerodoc/core/theme/app_colors.dart';
import 'package:zerodoc/core/theme/app_typography.dart';

abstract final class AppSnackBar {
  static void show(
    BuildContext context, {
    required String message,
    bool isError = false,
    bool isSuccess = false,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    final dotColor = isError
        ? AppColors.terracotta
        : isSuccess
            ? AppColors.sage
            : null;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              if (dotColor != null) ...[
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: Text(
                  message,
                  style: AppTypography.label(color: Colors.white),
                ),
              ),
            ],
          ),
          duration: const Duration(seconds: 3),
          action: actionLabel != null && onAction != null
              ? SnackBarAction(
                  label: actionLabel,
                  textColor: AppColors.sage,
                  onPressed: onAction,
                )
              : null,
        ),
      );
  }
}
