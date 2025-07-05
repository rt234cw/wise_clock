// lib/bloc/dashboard_bloc.dart

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:wise_clock/bloc/clock_record_state.dart';
import 'package:wise_clock/delayed_result.dart';
import 'package:wise_clock/model/dashboard_repository.dart';
import 'package:wise_clock/hive/clock_record.dart';
import 'dashboard_event.dart';

final _uuid = Uuid();

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
          // ✨ 修正 super constructor，加入 status
          DashboardState(
            status: DataStatus.initial,
            delayedResult: DelayedResult.idle(),
          ),
        ) {
    _recordsSub = _repo.watchAllRecords().listen((allRecords) {
      add(_RecordsUpdated(allRecords));
    });

    on<_RecordsUpdated>(_onRecordsUpdated);
    on<ClockInTimeSubmitted>(_onClockInTimeSubmitted);
    // ✨ 補上缺少的事件處理器
    on<ClockOutTimeSubmitted>(_onClockOutTimeSubmitted);
    on<OffDurationSubmitted>(_onOffDurationSubmitted);
    on<LeaveDurationSubmitted>(_onLeaveDurationSubmitted);
  }

  void _onRecordsUpdated(_RecordsUpdated event, Emitter<DashboardState> emit) {
    final thisWeekRecords = _filterThisWeekRecords(event.records);
    // ✨ 確保 emit 時包含 status
    emit(state.copyWith(
      status: DataStatus.success,
      thisWeekRecords: thisWeekRecords,
    ));
  }

  Future<void> _onClockInTimeSubmitted(
    ClockInTimeSubmitted event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(delayedResult: DelayedResult.loading()));
    try {
      // ✨ 修正：使用 event.time -> event.clockInTime
      final existingRecord = await _repo.findRecordForDate(event.clockInTime);

      if (existingRecord != null) {
        // ✨ 修正：使用 event.time -> event.clockInTime
        final updatedRecord = existingRecord.copyWith(clockInTime: event.clockInTime);
        await _repo.updateRecord(updatedRecord);
      } else {
        final newRecord = ClockRecord(
          id: _uuid.v4(),
          // ✨ 修正：使用 event.time -> event.clockInTime
          clockInTime: event.clockInTime,
        );
        await _repo.createRecord(newRecord);
      }
      emit(state.copyWith(delayedResult: DelayedResult.success(null)));
    } catch (e) {
      // ✨ 修正：使用 DelayedResult.failure
      emit(state.copyWith(delayedResult: DelayedResult.failure(e.toString())));
    }
  }

  Future<void> _onClockOutTimeSubmitted(
    ClockOutTimeSubmitted event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(delayedResult: DelayedResult.loading()));

    try {
      // ✨ 關鍵修正：採用兩步查找邏輯

      // 1. 先嘗試尋找最新一筆未打卡的紀錄 (處理第一次打卡和夜班)
      var recordToUpdate = await _repo.findLatestOpenRecord();

      // 2. 如果找不到（表示今天已經打過下班卡了），就改為尋找今天的紀錄 (處理編輯)
      recordToUpdate ??= await _repo.findRecordForDate(event.clockOutTime);

      // 3. 檢查最終是否找到了目標
      if (recordToUpdate != null) {
        // 業務規則驗證：確保下班時間不能早於上班時間
        if (event.clockOutTime.isBefore(recordToUpdate.clockInTime)) {
          emit(state.copyWith(delayedResult: DelayedResult.failure("下班時間不能早於上班時間")));
          return;
        }

        // 4. 更新並儲存紀錄
        final updatedRecord = recordToUpdate.copyWith(clockOutTime: event.clockOutTime);
        await _repo.updateRecord(updatedRecord);

        emit(state.copyWith(delayedResult: DelayedResult.success(null)));
      } else {
        // 如果兩種方式都找不到，才回報錯誤
        emit(state.copyWith(delayedResult: DelayedResult.failure('找不到對應的打卡紀錄進行更新')));
      }
    } catch (e) {
      emit(state.copyWith(delayedResult: DelayedResult.failure(e.toString())));
    }
  }

  // ✨ 補上完整的 _onOffDurationSubmitted 實作
  Future<void> _onOffDurationSubmitted(
    OffDurationSubmitted event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(delayedResult: DelayedResult.loading()));
    try {
      final todayRecord = await _repo.findRecordForDate(DateTime.now());
      if (todayRecord != null) {
        final updated = todayRecord.copyWith(offDuration: event.hours);
        await _repo.updateRecord(updated);
        emit(state.copyWith(delayedResult: DelayedResult.success(null)));
      } else {
        emit(state.copyWith(delayedResult: DelayedResult.failure('找不到今天的紀錄以更新休息時間')));
      }
    } catch (e) {
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

  // ✨ 新增處理請假事件的方法
  Future<void> _onLeaveDurationSubmitted(
    LeaveDurationSubmitted event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(delayedResult: DelayedResult.loading()));
    try {
      final date = DateTime.now();
      final existingRecord = await _repo.findRecordForDate(date);
      final bool isCancelingLeave = event.hours == 0;
      final bool isFullDayLeave = event.hours == 8.0;

      if (existingRecord != null) {
        // --- 情況一：今天已有紀錄 ---
        if (isCancelingLeave && existingRecord.clockOutTime == null && existingRecord.offDuration == null) {
          await _repo.deleteRecord(existingRecord.id);
        } else if (isFullDayLeave) {
          // ✨ 關鍵：請假 8 小時，用固定的上下班時間覆蓋原有紀錄
          final updated = existingRecord.copyWith(
            clockInTime: DateTime(date.year, date.month, date.day, 8, 0),
            clockOutTime: DateTime(date.year, date.month, date.day, 17, 0),
            leaveDuration: 8.0,
            offDuration: 1.0, // 預設 1 小時休息
          );
          await _repo.updateRecord(updated);
        } else {
          // 對於非整天請假，只更新請假時數，並保留原有的上下班時間
          final updated = existingRecord.copyWith(leaveDuration: event.hours);
          await _repo.updateRecord(updated);
        }
      } else {
        // --- 情況二：今天沒有紀錄 ---
        if (isCancelingLeave) {
          emit(state.copyWith(delayedResult: DelayedResult.success(null)));
          return;
        }

        if (isFullDayLeave) {
          // ✨ 關鍵：創建一筆完整的、有特殊標記的「整天請假」紀錄
          final newRecord = ClockRecord(
            id: _uuid.v4(),
            clockInTime: DateTime(date.year, date.month, date.day, 8, 0),
            clockOutTime: DateTime(date.year, date.month, date.day, 17, 0),
            leaveDuration: 8.0,
            offDuration: 1.0,
          );
          await _repo.createRecord(newRecord);
        } else {
          // 對於非整天、無紀錄的請假，創建「純請假」紀錄
          final newRecord = ClockRecord(
            id: _uuid.v4(),
            clockInTime: DateTime(date.year, date.month, date.day),
            leaveDuration: event.hours,
          );
          await _repo.createRecord(newRecord);
        }
      }

      emit(state.copyWith(delayedResult: DelayedResult.success(null)));
    } catch (e) {
      emit(state.copyWith(delayedResult: DelayedResult.failure(e.toString())));
    }
  }

  @override
  Future<void> close() {
    _recordsSub.cancel();
    return super.close();
  }
}
