import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wise_clock/bloc/dashboard_bloc.dart';
import 'package:wise_clock/bloc/dashboard_event.dart';

import 'package:wise_clock/model/dashboard_repository.dart';
import 'package:wise_clock/views/app_theme.dart';
import 'package:wise_clock/views/history_view/history_view.dart';
import 'package:wise_clock/views/landing_view.dart';
import 'hive/hive_service.dart';
import 'views/main_record_view/clock_records_view.dart';

final GoRouter _router = GoRouter(
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
            child: ClockRecordsView(),
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
      ],
    ),
  ],
);
// final hiveService = HiveService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final hiveService = HiveService();
  await hiveService.initializeHive();
  final box = hiveService.clockInRecordsBox;
  final dashboardModel = DashboardRepository(box: box);

  runApp(
    BlocProvider(create: (context) => DashboardBloc(dashboardModel)..add(TimeboardDataRequested()), child: MyApp()),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      themeMode: ThemeMode.light,
      theme: MyTheme.theme,
      // darkTheme: AppTheme.dark,
      routerConfig: _router,
    );
  }
}
