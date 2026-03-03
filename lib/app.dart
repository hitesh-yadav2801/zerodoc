import 'package:flutter/material.dart';
import 'package:zerodoc/core/router/app_router.dart';
import 'package:zerodoc/core/theme/app_theme.dart';
import 'package:zerodoc/shared/services/intent_handler.dart';

class ZeroDocApp extends StatefulWidget {
  const ZeroDocApp({super.key});

  @override
  State<ZeroDocApp> createState() => _ZeroDocAppState();
}

class _ZeroDocAppState extends State<ZeroDocApp> {
  final _intentHandler = IntentHandler();

  @override
  void initState() {
    super.initState();
    _intentHandler.init();
  }

  @override
  void dispose() {
    _intentHandler.dispose();
    super.dispose();
  }

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
