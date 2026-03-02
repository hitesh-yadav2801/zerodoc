import 'package:flutter/material.dart';
import 'package:zerodoc/core/router/app_router.dart';
import 'package:zerodoc/core/theme/app_theme.dart';

class ZeroDocApp extends StatelessWidget {
  const ZeroDocApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'ZeroDoc',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: AppRouter.router,
    );
  }
}
