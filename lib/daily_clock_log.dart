import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// 每一天只會有一筆 DailyClockLog
@HiveType(typeId: 0)
class DailyClockLog extends Equatable {
  @HiveField(0)
  final String id; // UUID，僅第一次產生
  @HiveField(1)
  final DateTime date; // 只保留 y-m-d（00:00）
  @HiveField(2)
  final DateTime? clockIn; // 可覆寫
  @HiveField(3)
  final DateTime? clockOut; // 可覆寫

  const DailyClockLog({
    required this.id,
    required this.date,
    this.clockIn,
    this.clockOut,
  });

  DailyClockLog copyWith({
    DateTime? clockIn,
    DateTime? clockOut,
  }) =>
      DailyClockLog(
        id: id,
        date: date,
        clockIn: clockIn ?? this.clockIn,
        clockOut: clockOut ?? this.clockOut,
      );

  @override
  List<Object?> get props => [id, date, clockIn, clockOut];
}
