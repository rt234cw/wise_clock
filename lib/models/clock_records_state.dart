import 'package:equatable/equatable.dart';
import 'package:wise_clock/daily_clock_log.dart';
import '../delayed_result.dart';

class ClockRecordsState extends Equatable {
  /// 今天（或當前選定日期）的打卡日誌，可為 null 代表尚未打卡
  final DailyClockLog? currentLog;

  /// 全部日誌（給列表畫面用）
  final List<DailyClockLog> allLogs;

  /// 用來控制 loading / error UI 的泛型封裝
  final DelayedResult<void> loadingResult;

  final bool isEditingClockIn;

  const ClockRecordsState({
    this.currentLog,
    this.allLogs = const [],
    this.loadingResult = const DelayedResult.idle(),
    this.isEditingClockIn = false,
  });

  ClockRecordsState copyWith({
    DailyClockLog? currentLog,
    List<DailyClockLog>? allLogs,
    DelayedResult<void>? loadingResult,
    bool? isEditingClockIn,
  }) {
    return ClockRecordsState(
      currentLog: currentLog ?? this.currentLog,
      allLogs: allLogs ?? this.allLogs,
      loadingResult: loadingResult ?? this.loadingResult,
      isEditingClockIn: isEditingClockIn ?? this.isEditingClockIn,
    );
  }

  @override
  List<Object?> get props => [currentLog, allLogs, loadingResult, isEditingClockIn];
}
