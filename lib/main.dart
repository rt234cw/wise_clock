import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:wise_clock/app_router.dart';
import 'package:wise_clock/bloc/dashboard_bloc.dart';
import 'package:wise_clock/bloc/history_bloc.dart';
import 'package:wise_clock/bloc/record_bloc.dart';
import 'package:wise_clock/model/dashboard_repository.dart';
import 'package:wise_clock/providers/locale_provider.dart';
import 'package:wise_clock/views/app_theme.dart';
import 'generated/l10n.dart';
import 'hive/hive_service.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'providers/settings_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final hiveService = HiveService();
  await hiveService.initializeHive();

  final box = hiveService.clockInRecordsBox;
  final dashboardModel = DashboardRepository(box: box);

  await initializeDateFormatting('zh_TW');
  await initializeDateFormatting('en_US');
  final localeProvider = LocaleProvider();
  await localeProvider.loadLocale();

  final settingsProvider = SettingsProvider();
  await settingsProvider.loadSettings();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: localeProvider),
        ChangeNotifierProvider.value(value: settingsProvider),
        // 先用 Provider 提供 Repository
        // 這樣整個 App 的任何地方，都能透過 context.read<DashboardRepository>() 取得它
        Provider<DashboardRepository>.value(
          value: dashboardModel,
        ),

        // 再用 BlocProvider 提供 BLoC
        // 在 create 時，它可以安全地從 context 中讀取已經被提供了的 Repository
        BlocProvider<DashboardBloc>(
          create: (context) => DashboardBloc(
            context.read<DashboardRepository>(),
          ),
        ),
        BlocProvider<HistoryBloc>(create: (context) => HistoryBloc(context.read<DashboardRepository>())),
        //  將共用的 RecordBloc 也提供給整個 App
        BlocProvider<RecordBloc>(create: (context) => RecordBloc(context.read<DashboardRepository>())),
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
    final locale = context.watch<LocaleProvider>().locale;

    return MaterialApp.router(
      locale: locale,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      themeMode: ThemeMode.dark,
      darkTheme: MyTheme.darkTheme,
      routerConfig: router,
    );
  }
}
