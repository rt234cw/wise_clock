import 'package:wise_clock/daily_clock_log.dart';

abstract interface class ClockRecordsRepository {
  /// 回傳整月或所有打卡日誌
  Future<List<DailyClockLog>> fetchLogs();

  /// 上班打卡（若当天已存在則覆寫 clockIn）
  Future<DailyClockLog> upsertClockIn(DateTime clockInTime);

  /// 下班打卡（若当天已存在則覆寫 clockOut）
  Future<DailyClockLog> upsertClockOut(DateTime clockOutTime);

  /// 後續若你仍要「整筆刪除」，可用 dateKey 刪
  Future<void> deleteLog(String dateKey);
}
