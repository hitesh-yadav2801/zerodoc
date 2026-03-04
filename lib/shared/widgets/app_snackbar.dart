import 'dart:async';

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
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onDismissed,
  }) {
    final c = AppColors.of(context);
    final dotColor = isError
        ? c.terracotta
        : isSuccess
        ? c.sage
        : null;

    final messenger = ScaffoldMessenger.of(context)..hideCurrentSnackBar();
    final controller = messenger.showSnackBar(
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
        duration: duration,
        action: actionLabel != null && onAction != null
            ? SnackBarAction(
                label: actionLabel,
                textColor: c.sage,
                onPressed: onAction,
              )
            : null,
      ),
    );

    unawaited(
      controller.closed.then((_) {
        onDismissed?.call();
      }),
    );
  }
}
