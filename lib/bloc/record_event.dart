// lib/bloc/record_event.dart

import 'package:equatable/equatable.dart';

abstract class RecordEvent extends Equatable {
  const RecordEvent();
  @override
  List<Object?> get props => [];
}

// 新增或編輯上班時間
class ClockInTimeSubmitted extends RecordEvent {
  final DateTime time;
  const ClockInTimeSubmitted(this.time);
  @override
  List<Object> get props => [time];
}

// 新增或編輯下班時間
class ClockOutTimeSubmitted extends RecordEvent {
  final DateTime time;
  const ClockOutTimeSubmitted(this.time);
  @override
  List<Object> get props => [time];
}

// 新增或編輯請假時數
class LeaveDurationSubmitted extends RecordEvent {
  final double hours;
  const LeaveDurationSubmitted(this.hours);
  @override
  List<Object> get props => [hours];
}
