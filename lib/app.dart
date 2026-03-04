import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zerodoc/core/router/app_router.dart';
import 'package:zerodoc/core/theme/app_theme.dart';
import 'package:zerodoc/shared/providers/theme_mode_provider.dart';
import 'package:zerodoc/shared/services/intent_handler.dart';

class ZeroDocApp extends ConsumerStatefulWidget {
  const ZeroDocApp({super.key});

  @override
  ConsumerState<ZeroDocApp> createState() => _ZeroDocAppState();
}

class _ZeroDocAppState extends ConsumerState<ZeroDocApp> {
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
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'ZeroDoc',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: AppRouter.router,
    );
  }
}
