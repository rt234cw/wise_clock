import 'package:hive_flutter/hive_flutter.dart';
import 'package:wise_clock/hive/clock_adapter.dart';

import '../daily_clock_log.dart';
import '../models/clock_records.dart';

class HiveService {
  Future<void> initializeHive() async {
    await Hive.initFlutter();

    Hive
      ..registerAdapter(DurationAdapter()) // id 1
      ..registerAdapter(OnDutyClockAdapter()) // id 0
      ..registerAdapter(OffDutyClockAdapter()) // id 2
      ..registerAdapter(DailyClockLogAdapter()); // id 3 ← 新增

    await Hive.openBox<OnDutyClockRecords>('clockRecords');
    await Hive.openBox<DailyClockLog>('dailyLogs');
  }

  Box<OnDutyClockRecords> get getClockRecordsBox {
    return Hive.box<OnDutyClockRecords>('clockRecords');
  }
}
