// lib/bloc/dashboard_bloc.dart

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_clock/bloc/clock_record_state.dart';
import 'package:wise_clock/bloc/dashboard_event.dart';
import 'package:wise_clock/delayed_result.dart';
import 'package:wise_clock/hive/clock_record.dart';
import 'package:wise_clock/model/dashboard_repository.dart';

// ✨ 1. 我們需要一個私有事件，將 Stream 的資料整合進 BLoC 的事件循環
class _RecordsUpdated extends DashboardEvent {
  final List<ClockRecord> records;
  const _RecordsUpdated(this.records);

  @override
  List<Object> get props => [records];
}

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRepository _repo;
  late final StreamSubscription<List<ClockRecord>> _recordsSub;

  DashboardBloc(this._repo)
      : super(
          // ✨ BLoC 的初始狀態
          DashboardState(
            status: DataStatus.initial,
            delayedResult: DelayedResult.idle(),
          ),
        ) {
    // ✨ 2. 監聽 Repository 的響應式資料流
    _recordsSub = _repo.watchAllRecords().listen((allRecords) {
      // 當資料庫有任何變動，就發出一個內部的 _RecordsUpdated 事件
      add(_RecordsUpdated(allRecords));
    });

    // ✨ 3. 為這個私有事件註冊處理器
    on<_RecordsUpdated>(_onRecordsUpdated);
  }

  // 處理來自資料庫的更新
  void _onRecordsUpdated(_RecordsUpdated event, Emitter<DashboardState> emit) {
    // 從完整的紀錄列表中，篩選出儀表板頁面需要的「本週紀錄」
    final thisWeekRecords = _filterThisWeekRecords(event.records);

    // 發射一個帶有最新資料的 success 狀態
    emit(state.copyWith(
      status: DataStatus.success,
      thisWeekRecords: thisWeekRecords,
    ));
  }

  // 輔助函式，用來篩選本週的紀錄
  List<ClockRecord> _filterThisWeekRecords(List<ClockRecord> allRecords) {
    final now = DateTime.now();
    // 確保以週一為一週的開始
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    return allRecords.where((record) {
      // 將紀錄時間和邊界時間都轉換為不含時分秒的日期，以確保比較準確
      final recordDay = DateTime(record.clockInTime.year, record.clockInTime.month, record.clockInTime.day);
      final startDay = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
      final endDay = DateTime(endOfWeek.year, endOfWeek.month, endOfWeek.day);
      return !recordDay.isBefore(startDay) && !recordDay.isAfter(endDay);
    }).toList();
  }

  // ✨ 4. 在 BLoC 被銷毀時，務必取消監聽，防止記憶體洩漏
  @override
  Future<void> close() {
    _recordsSub.cancel();
    return super.close();
  }
}
