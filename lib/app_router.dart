import 'package:go_router/go_router.dart';
import 'package:wise_clock/features/settings/presentation/view/settings_view.dart';

import 'features/history/presentation/view/history_view.dart';
import 'features/shell/presentation/view/landing_view.dart';
import 'features/clock_in/presentation/view/dashboard_view.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    ShellRoute(
      builder: (context, state, child) => LandingView(
        child: child,
      ),
      routes: [
        GoRoute(
          name: "landing",
          path: "/",
          pageBuilder: (_, state) => NoTransitionPage(
            key: state.pageKey,
            child: DashboardView(),
          ),
        ),
        GoRoute(
          name: "history",
          path: "/history",
          pageBuilder: (_, state) => NoTransitionPage(
            key: state.pageKey,
            child: HistoryView(),
          ),
        ),
        GoRoute(
          name: "profile",
          path: "/profile",
          pageBuilder: (_, state) => NoTransitionPage(
            key: state.pageKey,
            child: SettingsView(),
          ),
        ),
      ],
    ),
  ],
);
