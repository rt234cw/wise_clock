import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:wise_clock/bloc/clock_record_state.dart';
import 'package:wise_clock/delayed_result.dart';
import 'package:wise_clock/model/dashboard_repository.dart';
import '../hive/clock_record.dart';
import 'dashboard_event.dart';

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
          DashboardState(delayedResult: DelayedResult.idle()),
        ) {
    // 1. 監聽 Repository 的資料流
    _recordsSub = _repo.watchAllRecords().listen((allRecords) {
      add(_RecordsUpdated(allRecords));
    });
    // 3. 為這個私有事件註冊一個處理器
    on<_RecordsUpdated>((event, emit) {
      // ✅ 合法呼叫：emit 現在是在 EventHandler 內部，符合 lint 規則
      final thisWeekRecords = _filterThisWeekRecords(event.records);
      emit(state.copyWith(thisWeekRecords: thisWeekRecords));
    });

    on<ClockInTimeSubmitted>(_onClockInTimeSubmitted);
  }
  Future<void> _onClockInTimeSubmitted(
    ClockInTimeSubmitted event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(delayedResult: DelayedResult.loading()));

    try {
      // 業務邏輯：尋找是否已存在對應日期的紀錄
      // 我們使用 event.time 的日期部分來查詢，以支援補打卡功能
      final existingRecord = await _repo.findRecordForDate(event.clockInTime);

      if (existingRecord != null) {
        // --- 情況一：判定為「編輯」 ---
        // 如果找到了紀錄，表示使用者正在編輯已有的打卡時間

        // 使用 copyWith 創建一個更新了上班時間的新實例
        final updatedRecord = existingRecord.copyWith(clockInTime: event.clockInTime);

        // 呼叫 Repository 的更新方法
        await _repo.updateRecord(updatedRecord);
      } else {
        // --- 情況二：判定為「新增」 ---
        // 如果找不到紀錄，表示這是當天的第一次打卡

        // 創建一筆全新的紀錄，並生成一個新的 UUID
        final newRecord = ClockRecord(
          id: Uuid().v4(), // 使用 uuid 套件生成唯一 ID
          clockInTime: event.clockInTime,
        );

        // 呼叫 Repository 的創建方法
        await _repo.createRecord(newRecord);
      }

      // ✨ 操作成功後，發射一個 success 的一次性結果
      // UI 層的 BlocListener 可以監聽這個結果來顯示 SnackBar 等提示
      emit(state.copyWith(delayedResult: DelayedResult.success(null)));
    } catch (e) {
      // 如果在過程中發生任何錯誤，發射一個 error 的一次性結果
      emit(state.copyWith(delayedResult: DelayedResult.failure(e.toString())));
    }
  }

  List<ClockRecord> _filterThisWeekRecords(List<ClockRecord> allRecords) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    return allRecords.where((record) {
      final recordDay = DateTime(record.clockInTime.year, record.clockInTime.month, record.clockInTime.day);
      final startDay = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
      final endDay = DateTime(endOfWeek.year, endOfWeek.month, endOfWeek.day);
      return !recordDay.isBefore(startDay) && !recordDay.isAfter(endDay);
    }).toList();
  }
}
