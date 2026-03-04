import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:zerodoc/core/constants/app_strings.dart';
import 'package:zerodoc/core/router/app_router.dart';
import 'package:zerodoc/core/theme/app_colors.dart';
import 'package:zerodoc/core/theme/app_typography.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();
    Future.delayed(const Duration(milliseconds: 1500), _navigateToHome);
  }

  void _navigateToHome() {
    if (!mounted) return;
    AppRouter.router.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);

    return Scaffold(
      backgroundColor: c.paperBg,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppStrings.appName,
              style: AppTypography.pageTitle(
                color: c.slate,
              ).copyWith(fontSize: 40),
            ),
            const SizedBox(height: 8),
            Text(
              AppStrings.slogan,
              style: AppTypography.label(
                color: c.inkMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
