import 'package:equatable/equatable.dart';

class DelayedResult<T> extends Equatable {
  final T? value;
  final Object? error;
  final bool isInProgress;

  const DelayedResult._({
    this.value,
    this.error,
    required this.isInProgress,
  });

  /// factory 建構子對外暴露四種狀態
  factory DelayedResult.idle() => const DelayedResult._(isInProgress: false);

  factory DelayedResult.loading() => const DelayedResult._(isInProgress: true);

  factory DelayedResult.success(T value) => DelayedResult._(value: value, isInProgress: false);

  factory DelayedResult.failure(Object error) => DelayedResult._(error: error, isInProgress: false);

  bool get isSuccessful => value != null && error == null && !isInProgress;

  bool get isError => error != null;

  bool get isIdle => value == null && error == null && !isInProgress;

  DelayedResult<T> copyWith({
    T? value,
    Object? error,
    bool? isInProgress,
  }) {
    return DelayedResult._(
      value: value ?? this.value,
      error: error ?? this.error,
      isInProgress: isInProgress ?? this.isInProgress,
    );
  }

  @override
  List<Object?> get props => [value, error, isInProgress];
}
