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

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();

    Future.delayed(const Duration(milliseconds: 1800), _navigateToHome);
  }

  void _navigateToHome() {
    if (!mounted) return;
    AppRouter.router.go('/home');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkPaperBg : AppColors.paperBg,
      body: Center(
        child: FadeTransition(
          opacity: _fadeIn,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppStrings.appName,
                style: AppTypography.pageTitle(
                  color: isDark ? AppColors.darkSlate : AppColors.slate,
                ).copyWith(fontSize: 40),
              ),
              const SizedBox(height: 8),
              Text(
                AppStrings.slogan,
                style: AppTypography.label(
                  color:
                      isDark ? AppColors.darkInkMuted : AppColors.inkMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
