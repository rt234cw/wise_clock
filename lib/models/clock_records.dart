import 'package:equatable/equatable.dart';

sealed class ClockRecords extends Equatable {
  const ClockRecords();

  @override
  List<Object?> get props => [];
}

final class OnDutyClockRecords extends ClockRecords {
  final String id;
  final DateTime clockIn;

  const OnDutyClockRecords({
    required this.id,
    required this.clockIn,
  });

  factory OnDutyClockRecords.fromJson(Map<String, dynamic> json) {
    return OnDutyClockRecords(
      id: json['id'] as String,
      clockIn: DateTime.parse(json['clockIn'] as String),
    );
  }
}

final class OffDutyClockRecords extends ClockRecords {
  final String id;
  final DateTime clockOut;

  const OffDutyClockRecords({
    required this.id,
    required this.clockOut,
  });

  factory OffDutyClockRecords.fromJson(Map<String, dynamic> json) {
    return OffDutyClockRecords(
      id: json['id'] as String,
      clockOut: DateTime.parse(json['clockOut'] as String),
    );
  }
}
