// lib/bloc/history_event.dart

import 'package:equatable/equatable.dart';

abstract class HistoryEvent extends Equatable {
  const HistoryEvent();

  @override
  List<Object?> get props => [];
}

// 當使用者切換日曆月份時觸發
class MonthChanged extends HistoryEvent {
  final DateTime focusedMonth;
  const MonthChanged(this.focusedMonth);

  @override
  List<Object?> get props => [focusedMonth];
}

// 當使用者點擊日曆上的某一天時觸發
class DaySelected extends HistoryEvent {
  final DateTime selectedDay;
  const DaySelected(this.selectedDay);

  @override
  List<Object?> get props => [selectedDay];
}
