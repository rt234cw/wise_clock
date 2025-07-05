import 'package:equatable/equatable.dart';

class ClockRecord extends Equatable {
  final String id;
  final DateTime clockInTime;
  final DateTime? clockOutTime;
  final double? offDuration;

  const ClockRecord({
    required this.id,
    required this.clockInTime,
    this.clockOutTime,
    this.offDuration,
  });

  ClockRecord copyWith({
    DateTime? clockInTime,
    DateTime? clockOutTime,
    double? offDuration,
  }) {
    return ClockRecord(
      id: id,
      clockInTime: clockInTime ?? this.clockInTime,
      clockOutTime: clockOutTime ?? this.clockOutTime,
      offDuration: offDuration ?? this.offDuration,
    );
  }

  @override
  List<Object?> get props => [id, clockInTime, clockOutTime, offDuration];
}
