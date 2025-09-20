import 'package:equatable/equatable.dart';
import 'package:wise_clock/shared/utils/delayed_result.dart';

class RecordState extends Equatable {
  final DelayedResult<void> submissionStatus;

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
