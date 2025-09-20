import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:wise_clock/shared/utils/delayed_result.dart';
import 'package:wise_clock/core/data/models/clock_record.dart';

// 整個頁面資料的當前狀態
enum DataStatus { initial, loading, success, failure }

final class DashboardState extends Equatable {
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
        status,
        thisWeekRecords,
        delayedResult,
      ];
}
