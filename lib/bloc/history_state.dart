// lib/bloc/history_state.dart

import 'package:equatable/equatable.dart';
import 'package:wise_clock/hive/clock_record.dart';

enum HistoryStatus { initial, loading, success, failure }

class HistoryState extends Equatable {
  final HistoryStatus status;
  // 當前日曆聚焦的月份
  final DateTime focusedMonth;
  // 使用者選中的日期
  final DateTime? selectedDay;
  // 已載入的、當前月份的所有打卡紀錄
  final List<ClockRecord> recordsForMonth;

  const HistoryState({
    this.status = HistoryStatus.initial,
    required this.focusedMonth,
    this.selectedDay,
    this.recordsForMonth = const [],
  });

  // 從當月紀錄中，篩選出選中日期的那一筆
  ClockRecord? get selectedDayRecord {
    if (selectedDay == null) return null;
    try {
      // isSameDay 來自 table_calendar 套件
      return recordsForMonth.firstWhere((record) =>
          record.clockInTime.year == selectedDay!.year &&
          record.clockInTime.month == selectedDay!.month &&
          record.clockInTime.day == selectedDay!.day);
    } catch (e) {
      return null;
    }
  }

  HistoryState copyWith({
    HistoryStatus? status,
    DateTime? focusedMonth,
    DateTime? selectedDay,
    List<ClockRecord>? recordsForMonth,
  }) {
    return HistoryState(
      status: status ?? this.status,
      focusedMonth: focusedMonth ?? this.focusedMonth,
      // 允許 selectedDay 被設為 null
      selectedDay: selectedDay,
      recordsForMonth: recordsForMonth ?? this.recordsForMonth,
    );
  }

  @override
  List<Object?> get props => [status, focusedMonth, selectedDay, recordsForMonth];
}
