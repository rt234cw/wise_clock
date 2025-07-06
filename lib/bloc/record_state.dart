// lib/bloc/record_state.dart

import 'package:equatable/equatable.dart';
import 'package:wise_clock/delayed_result.dart';

class RecordState extends Equatable {
  final DelayedResult<void> submissionStatus;

  // ✨ 關鍵修正：不再提供預設值，而是將其設為必要參數
  const RecordState({
    required this.submissionStatus,
  });

  RecordState copyWith({
    DelayedResult<void>? submissionStatus,
  }) {
    return RecordState(
      submissionStatus: submissionStatus ?? this.submissionStatus,
    );
  }

  @override
  List<Object?> get props => [submissionStatus];
}
