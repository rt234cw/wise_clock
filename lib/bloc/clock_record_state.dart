// lib/bloc/clock_record_state.dart

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:wise_clock/delayed_result.dart';
import 'package:wise_clock/hive/clock_record.dart';

// ✨ 新增：代表整個頁面資料的當前狀態
enum DataStatus { initial, loading, success, failure }

final class DashboardState extends Equatable {
  // ✨ 新增 status 欄位
  final DataStatus status;
  final List<ClockRecord> thisWeekRecords;
  final DelayedResult<void> delayedResult;

  const DashboardState({
    this.status = DataStatus.initial,
    this.thisWeekRecords = const [],
    required this.delayedResult,
  });

  ClockRecord? get todayRecord {
    if (thisWeekRecords.isEmpty) return null;
    final now = DateTime.now();
    return thisWeekRecords.firstWhereOrNull((record) => isSameDay(record.clockInTime, now));
  }

  DashboardState copyWith({
    DataStatus? status,
    List<ClockRecord>? thisWeekRecords,
    DelayedResult<void>? delayedResult,
  }) {
    return DashboardState(
      status: status ?? this.status,
      thisWeekRecords: thisWeekRecords ?? this.thisWeekRecords,
      delayedResult: delayedResult ?? this.delayedResult,
    );
  }

  @override
  List<Object?> get props => [
        status, // ✨ 加入 props
        thisWeekRecords,
        delayedResult,
      ];
}
