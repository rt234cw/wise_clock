import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wise_clock/color_scheme/color_code.dart';
import 'package:wise_clock/views/history_view.dart';
import 'package:wise_clock/views/landing_view.dart';

import 'clock_records_page.dart';
import 'color_scheme/color_scheme.dart';
import 'hive/hive_service.dart';

final hiveService = HiveService();
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
            child: ClockRecordsPage(),
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
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await hiveService.initializeHive();

  runApp(
    MyApp(),
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
      theme: ThemeData(
        inputDecorationTheme: InputDecorationTheme(
            border: InputBorder.none, contentPadding: EdgeInsets.all(4), filled: true, fillColor: ColorCode.bgColor),
        filledButtonTheme: FilledButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(ColorCode.primaryColor),
            foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
            padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
              EdgeInsets.symmetric(horizontal: 16),
            ),
            elevation: WidgetStateProperty.all<double>(2),
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ),
      darkTheme: AppTheme.dark,
      routerConfig: _router,
    );
  }
}
