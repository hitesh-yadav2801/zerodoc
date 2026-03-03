import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zerodoc/core/constants/tool_routes.dart';
import 'package:zerodoc/core/router/app_shell.dart';
import 'package:zerodoc/features/home/presentation/pages/home_page.dart';
import 'package:zerodoc/features/result/presentation/pages/result_page.dart';
import 'package:zerodoc/features/settings/presentation/pages/settings_page.dart';
import 'package:zerodoc/features/splash/presentation/pages/splash_page.dart';
import 'package:zerodoc/features/tools/merge/presentation/merge_page.dart';
import 'package:zerodoc/features/tools/presentation/pages/placeholder_tool_page.dart';
import 'package:zerodoc/features/tools/presentation/pages/tools_page.dart';
import 'package:zerodoc/features/workbench/presentation/pages/workbench_page.dart';

abstract final class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static Widget _resolveToolPage(String toolId) {
    return switch (toolId) {
      ToolRoutes.merge => const MergePage(),
      _ => PlaceholderToolPage(toolId: toolId),
    };
  }

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
      GoRoute(
        path: '/workbench',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) {
          final extra = state.extra! as Map<String, String>;
          return MaterialPage(
            child: WorkbenchPage(
              filePath: extra['filePath']!,
              fileName: extra['fileName']!,
            ),
          );
        },
      ),
      GoRoute(
        path: '/result',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) {
          final extra = state.extra! as Map<String, dynamic>;
          return MaterialPage(
            child: ResultPage(
              outputPath: extra['outputPath']! as String,
              fileName: extra['fileName']! as String,
              showOpenInWorkbench:
                  extra['showOpenInWorkbench'] as bool? ?? false,
            ),
          );
        },
      ),
      GoRoute(
        path: '/tool/:toolId',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) {
          final toolId = state.pathParameters['toolId']!;
          return MaterialPage(child: _resolveToolPage(toolId));
        },
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
