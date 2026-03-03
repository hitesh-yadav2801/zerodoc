import 'package:flutter/material.dart';
import 'package:zerodoc/core/theme/app_colors.dart';
import 'package:zerodoc/core/theme/app_typography.dart';

class ProcessingView extends StatelessWidget {
  const ProcessingView({this.message = 'Processing...', super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(
              color: AppColors.slate,
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            message,
            style: AppTypography.body(color: AppColors.inkMuted),
          ),
        ],
      ),
    );
  }
}
