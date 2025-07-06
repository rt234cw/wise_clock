import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wise_clock/bloc/dashboard_bloc.dart';
import 'package:wise_clock/bloc/history_bloc.dart';
import 'package:wise_clock/bloc/record_bloc.dart';
import 'package:wise_clock/model/dashboard_repository.dart';
import 'package:wise_clock/views/app_theme.dart';
import 'package:wise_clock/views/history_view/history_view.dart';
import 'package:wise_clock/views/landing_view.dart';
import 'hive/hive_service.dart';
import 'views/main_record_view/clock_records_view.dart';
import 'package:intl/date_symbol_data_local.dart';

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
  await initializeDateFormatting('zh_TW');
  await initializeDateFormatting('en_US');

  runApp(
    MultiProvider(
      providers: [
        // ✨ 步驟 A: 先用 Provider 提供 Repository
        // 這樣整個 App 的任何地方，都能透過 context.read<DashboardRepository>() 取得它
        Provider<DashboardRepository>.value(
          value: dashboardModel,
        ),

        // ✨ 步驟 B: 再用 BlocProvider 提供 BLoC
        // 在 create 時，它可以安全地從 context 中讀取已經被提供了的 Repository
        BlocProvider<DashboardBloc>(
          create: (context) => DashboardBloc(
            context.read<DashboardRepository>(),
          ),
        ),
        BlocProvider<HistoryBloc>(create: (context) => HistoryBloc(context.read<DashboardRepository>())),
        // ✨ 將共用的 RecordBloc 也提供給整個 App
        BlocProvider<RecordBloc>(create: (context) => RecordBloc(context.read<DashboardRepository>())),

        // 如果未來有 HistoryBloc，也會在這裡提供
        // BlocProvider<HistoryBloc>(
        //   create: (context) => HistoryBloc(context.read<DashboardRepository>()),
        // ),
      ],
      child: const MyApp(),
    ),
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
