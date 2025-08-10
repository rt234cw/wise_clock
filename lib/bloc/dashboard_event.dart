import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();
}

// 新增或編輯上班時間
final class ClockInTimeSubmitted extends DashboardEvent {
  final DateTime clockInTime;
  const ClockInTimeSubmitted({required this.clockInTime});
  @override
  List<Object> get props => [clockInTime];
}

// 新增或編輯下班時間
final class ClockOutTimeSubmitted extends DashboardEvent {
  final DateTime clockOutTime;
  const ClockOutTimeSubmitted({required this.clockOutTime});

  @override
  List<Object> get props => [clockOutTime];
}

// 新增或刪除請假時間
final class OffDurationSubmitted extends DashboardEvent {
  final double hours;
  const OffDurationSubmitted({required this.hours});
  @override
  List<Object> get props => [hours];
}

// 提交請假時數的事件
final class LeaveDurationSubmitted extends DashboardEvent {
  final double hours;
  const LeaveDurationSubmitted(this.hours);
  @override
  List<Object> get props => [hours];
}
