import 'package:flutter/material.dart' show DateUtils; // 取 dateOnly
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import 'clock_records_repository.dart';
import 'daily_clock_log.dart';

class LocalClockRecordsRepository implements ClockRecordsRepository {
  final Box<DailyClockLog> _box;
  final _uuid = const Uuid();
  final _fmt = DateFormat('yyyyMMdd'); // yyyyMMdd 當作主鍵

  LocalClockRecordsRepository(this._box);

  /* ──────────────────────────────────────────────────────────── *
   *  共用：把日期轉成字串 key（不含時分秒）                         *
   * ──────────────────────────────────────────────────────────── */
  String _dateKey(DateTime dt) => _fmt.format(dt.toLocal());

  /* ──────────────────────────────────────────────────────────── *
   *  CRUD 實作                                                    *
   * ──────────────────────────────────────────────────────────── */

  // 取得全部日誌
  @override
  Future<List<DailyClockLog>> fetchLogs() async => _box.values.toList();

  // 上班打卡：有就覆寫 clockIn，沒有就新建
  @override
  Future<DailyClockLog> upsertClockIn(DateTime when) async {
    final key = _dateKey(when);
    final existing = _box.get(key);

    final updated = (existing ??
            DailyClockLog(
              id: _uuid.v4(),
              date: DateUtils.dateOnly(when),
            ))
        .copyWith(clockIn: when);

    await _box.put(key, updated);
    return updated;
  }

  // 下班打卡：有就覆寫 clockOut，沒有就新建
  @override
  Future<DailyClockLog> upsertClockOut(DateTime when) async {
    final key = _dateKey(when);
    final existing = _box.get(key);

    final updated = (existing ??
            DailyClockLog(
              id: _uuid.v4(),
              date: DateUtils.dateOnly(when),
            ))
        .copyWith(clockOut: when);

    await _box.put(key, updated);
    return updated;
  }

  // 刪除整天的日誌
  @override
  Future<void> deleteLog(String dateKey) async {
    await _box.delete(dateKey);
  }
}
