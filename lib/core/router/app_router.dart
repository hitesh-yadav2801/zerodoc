import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zerodoc/core/router/app_shell.dart';
import 'package:zerodoc/features/home/presentation/pages/home_page.dart';
import 'package:zerodoc/features/settings/presentation/pages/settings_page.dart';
import 'package:zerodoc/features/splash/presentation/pages/splash_page.dart';
import 'package:zerodoc/features/tools/presentation/pages/tools_page.dart';

abstract final class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: SplashPage(),
        ),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: '/home',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomePage(),
            ),
          ),
          GoRoute(
            path: '/tools',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ToolsPage(),
            ),
          ),
          GoRoute(
            path: '/settings',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SettingsPage(),
            ),
          ),
        ],
      ),
    ],
  );
}
