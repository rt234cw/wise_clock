import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:wise_clock/delayed_result.dart';
import 'package:wise_clock/hive/clock_record.dart';

final class DashboardState extends Equatable {
  final List<ClockRecord> thisWeekRecords;
  final DelayedResult<void> delayedResult;

  const DashboardState({
    this.thisWeekRecords = const [],
    required this.delayedResult,
  });

  ClockRecord? get todayRecord {
    if (thisWeekRecords.isEmpty) return null;
    final now = DateTime.now();
    return thisWeekRecords.firstWhereOrNull((record) => isSameDay(record.clockInTime, now));
  }

  DashboardState copyWith({
    List<ClockRecord>? thisWeekRecords,
    DelayedResult<void>? delayedResult,
  }) {
    return DashboardState(
      thisWeekRecords: thisWeekRecords ?? this.thisWeekRecords,
      delayedResult: delayedResult ?? this.delayedResult,
    );
  }

  @override
  List<Object?> get props => [
        thisWeekRecords,
        delayedResult,
      ];
}
