import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'clock_record.g.dart';

@HiveType(typeId: 0)
class ClockRecord extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime clockInTime;

  @HiveField(2)
  final DateTime? clockOutTime;

  @HiveField(3)
  final double? offDuration;

  // 請假時數欄位 (單位：小時)
  @HiveField(4)
  final double? leaveDuration;

  const ClockRecord({
    required this.id,
    required this.clockInTime,
    this.clockOutTime,
    this.offDuration,
    this.leaveDuration,
  });

  ClockRecord copyWith({
    DateTime? clockInTime,
    DateTime? clockOutTime,
    double? offDuration,
    double? leaveDuration,
  }) {
    return ClockRecord(
      id: id,
      clockInTime: clockInTime ?? this.clockInTime,
      clockOutTime: clockOutTime ?? this.clockOutTime,
      offDuration: offDuration ?? this.offDuration,
      leaveDuration: leaveDuration ?? this.leaveDuration,
    );
  }

  @override
  List<Object?> get props => [
        id,
        clockInTime,
        clockOutTime,
        offDuration,
        leaveDuration,
      ];
}
