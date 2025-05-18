import 'package:wise_clock/daily_clock_log.dart';
import 'package:wise_clock/local_clock_records_repository.dart';

import 'clock_records_repository.dart';

class AppClockRecordsRepository implements ClockRecordsRepository {
  final LocalClockRecordsRepository _local;

  AppClockRecordsRepository(this._local);

  @override
  Future<List<DailyClockLog>> fetchLogs() => _local.fetchLogs();

  @override
  Future<DailyClockLog> upsertClockIn(DateTime when) => _local.upsertClockIn(when);

  @override
  Future<DailyClockLog> upsertClockOut(DateTime when) => _local.upsertClockOut(when);

  @override
  Future<void> deleteLog(String dateKey) => _local.deleteLog(dateKey);
}
