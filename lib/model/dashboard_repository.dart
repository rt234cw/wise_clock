import 'package:collection/collection.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rxdart/rxdart.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:wise_clock/hive/clock_record.dart';

final class DashboardRepository {
  final Box<ClockRecord> _box;
  const DashboardRepository({required Box<ClockRecord> box}) : _box = box;

  Stream<List<ClockRecord>> watchAllRecords() {
    // _box.watch() 返回一個 Stream<BoxEvent>。
    // 每當 Box 中的資料發生變化（新增、更新、刪除），它就會發出一個 BoxEvent。
    return _box.watch().map((event) {
      // 當任何事件發生時，我們都重新從 Box 中獲取所有值並轉換為列表。
      // event.value 可以是 ClockRecord (新增/更新) 或 null (刪除)
      // event.key 是被操作的 key
      // event.deleted 是一個布林值
      // 但為了簡單起見，我們直接返回整個 Box 的當前狀態。
      return _box.values.toList();
    }).startWith(_box.values.toList());
  }

  Future<ClockRecord?> findRecordForDate(DateTime date) async {
    return _box.values.firstWhereOrNull((record) => isSameDay(record.clockInTime, date));
  }

  Future<void> createRecord(ClockRecord record) async {
    // 假設 record.id 是唯一的 (例如 UUID)
    await _box.put(record.id, record);
  }

  Future<void> updateRecord(ClockRecord record) async {
    // put 方法如果 key 已存在，則會覆蓋
    await _box.put(record.id, record);
  }

  Future<void> deleteRecord(String id) async {
    await _box.delete(id);
  }

  /// 尋找最新一筆未打下班卡的紀錄
  Future<ClockRecord?> findLatestOpenRecord() async {
    final openRecords = _box.values.where((r) => r.clockOutTime == null).toList();
    if (openRecords.isEmpty) return null;
    // 按上班時間倒序排序，最新的在最前面
    openRecords.sort((a, b) => b.clockInTime.compareTo(a.clockInTime));
    return openRecords.first;
  }

  List<ClockRecord> getAllRecordsNow() {
    return _box.values.toList();
  }

  Future<void> deleteAllRecords() async {
    await _box.clear();
  }
}
