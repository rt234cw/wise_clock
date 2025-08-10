import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_clock/bloc/history_event.dart';
import 'package:wise_clock/bloc/history_state.dart';
import 'package:wise_clock/hive/clock_record.dart';
import 'package:wise_clock/model/dashboard_repository.dart';

import '../views/history_view/history_view.dart';

// 需要一個私有事件，來處理從資料庫來的更新
class _HistoryRecordsUpdated extends HistoryEvent {
  final List<ClockRecord> records;
  const _HistoryRecordsUpdated(this.records);

  @override
  List<Object> get props => [records];
}

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final DashboardRepository _repo;
  late final StreamSubscription<List<ClockRecord>> _recordsSub;

  //  初始化 BLoC，設定初始的聚焦月份為今天
  HistoryBloc(this._repo) : super(HistoryState(focusedMonth: DateTime.now())) {
    // 監聽 Repository 的響應式資料流
    _recordsSub = _repo.watchAllRecords().listen((allRecords) {
      // 當資料庫有任何變動，就發出一個內部的 _HistoryRecordsUpdated 事件
      add(_HistoryRecordsUpdated(allRecords));
    });

    // 為所有事件註冊處理器
    on<_HistoryRecordsUpdated>(_onRecordsUpdated);
    on<MonthChanged>(_onMonthChanged);
    on<DaySelected>(_onDaySelected);
  }

  // 當從資料庫收到更新時
  void _onRecordsUpdated(_HistoryRecordsUpdated event, Emitter<HistoryState> emit) {
    // 根據當前 state 中聚焦的月份，重新篩選資料
    final recordsForMonth = _filterRecordsForMonth(event.records, state.focusedMonth);
    bool selectedDayStillExists = false;
    if (state.selectedDay != null) {
      selectedDayStillExists = event.records.any((r) => isSameDay(r.clockInTime, state.selectedDay));
    }

    emit(state.copyWith(
      status: HistoryStatus.success,
      recordsForMonth: recordsForMonth,
      // 如果選中的日期被刪除了，就清除選擇；否則，保持不變
      clearSelectedDay: !selectedDayStillExists,
    ));
  }

  // 當使用者在 UI 上滑動月份時
  void _onMonthChanged(MonthChanged event, Emitter<HistoryState> emit) {
    // 更新聚焦月份，並根據 BLoC 當前持有的所有紀錄來篩選
    // 因為 Stream 會提供最新資料，我們這裡可以直接從 state 讀取，或者等待下一次 _RecordsUpdated
    // 為了更即時的反應，我們直接在這裡重新篩選一次
    final currentRecords = _repo.getAllRecordsNow(); // Repository 需要一個獲取當前所有紀錄的同步方法
    final recordsForMonth = _filterRecordsForMonth(currentRecords, event.focusedMonth);

    emit(state.copyWith(
      focusedMonth: event.focusedMonth,
      recordsForMonth: recordsForMonth,
      clearSelectedDay: true,
    ));
  }

  // 當使用者在 UI 上點擊某一天時
  void _onDaySelected(DaySelected event, Emitter<HistoryState> emit) {
    // 只更新選中的日期，並將其設為聚焦日
    emit(state.copyWith(selectedDay: event.selectedDay, focusedMonth: event.selectedDay));
  }

  // 輔助函式：從所有紀錄中篩選出指定月份的紀錄
  List<ClockRecord> _filterRecordsForMonth(List<ClockRecord> allRecords, DateTime month) {
    return allRecords.where((r) => r.clockInTime.year == month.year && r.clockInTime.month == month.month).toList();
  }

  @override
  Future<void> close() {
    _recordsSub.cancel();
    return super.close();
  }
}
