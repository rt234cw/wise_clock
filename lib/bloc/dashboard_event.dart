import 'package:equatable/equatable.dart';
import 'package:wise_clock/model/dashboard_repository.dart';

import '../hive/clock_record.dart';

/// 這裡就是UI層的邏輯，也就是User的Intent（意圖）   -> Intent
/// 用戶從UI層告訴Bloc（業務邏輯層）我現在要做這件事情 -> ViewModel
/// Bloc會把任務分派給Model                       -> Model
/// 我的Model為[DashboardRepository]

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();
}

// 從Hive中讀取當週的打卡記錄
// final class TimeboardDataRequested extends DashboardEvent {
//   @override
//   List<Object?> get props => [];
// }

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

// ✨ 新增：提交請假時數的事件
final class LeaveDurationSubmitted extends DashboardEvent {
  final double hours;
  const LeaveDurationSubmitted(this.hours);
  @override
  List<Object> get props => [hours];
}
