// lib/bloc/record_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:wise_clock/bloc/record_event.dart';
import 'package:wise_clock/bloc/record_state.dart';
import 'package:wise_clock/delayed_result.dart';
import 'package:wise_clock/hive/clock_record.dart';
import 'package:wise_clock/model/dashboard_repository.dart';

class RecordBloc extends Bloc<RecordEvent, RecordState> {
  final DashboardRepository _repo;
  final _uuid = Uuid();

  // ✨ 關鍵修正 1：在 super() 中使用正確的參數名稱 `submissionStatus`
  RecordBloc(this._repo) : super(RecordState(submissionStatus: DelayedResult.idle())) {
    on<ClockInTimeSubmitted>(_onClockInTimeSubmitted);
    on<ClockOutTimeSubmitted>(_onClockOutTimeSubmitted);
    on<LeaveDurationSubmitted>(_onLeaveDurationSubmitted);
    on<RecordDeleted>(_onRecordDeleted);
  }

  Future<void> _onClockInTimeSubmitted(
    ClockInTimeSubmitted event,
    Emitter<RecordState> emit,
  ) async {
    // ✨ 關鍵修正 2：所有 copyWith 都使用 submissionStatus
    emit(state.copyWith(submissionStatus: DelayedResult.loading()));
    try {
      final existingRecord = await _repo.findRecordForDate(event.time);

      if (existingRecord != null) {
        final updatedRecord = existingRecord.copyWith(clockInTime: event.time);
        await _repo.updateRecord(updatedRecord);
      } else {
        final newRecord = ClockRecord(
          id: _uuid.v4(),
          clockInTime: event.time,
        );
        await _repo.createRecord(newRecord);
      }
      emit(state.copyWith(submissionStatus: DelayedResult.success(null)));
    } catch (e) {
      emit(state.copyWith(submissionStatus: DelayedResult.failure(e.toString())));
    }
  }

  Future<void> _onClockOutTimeSubmitted(
    ClockOutTimeSubmitted event,
    Emitter<RecordState> emit,
  ) async {
    emit(state.copyWith(submissionStatus: DelayedResult.loading()));
    try {
      var recordToUpdate = await _repo.findLatestOpenRecord();
      recordToUpdate ??= await _repo.findRecordForDate(event.time);

      if (recordToUpdate != null) {
        if (event.time.isBefore(recordToUpdate.clockInTime)) {
          emit(state.copyWith(submissionStatus: DelayedResult.failure("下班時間不能早於上班時間")));
          return;
        }
        final updatedRecord = recordToUpdate.copyWith(clockOutTime: event.time);
        await _repo.updateRecord(updatedRecord);
        emit(state.copyWith(submissionStatus: DelayedResult.success(null)));
      } else {
        emit(state.copyWith(submissionStatus: DelayedResult.failure('找不到對應的打卡紀錄進行更新')));
      }
    } catch (e) {
      emit(state.copyWith(submissionStatus: DelayedResult.failure(e.toString())));
    }
  }

  Future<void> _onLeaveDurationSubmitted(
    LeaveDurationSubmitted event,
    Emitter<RecordState> emit,
  ) async {
    emit(state.copyWith(submissionStatus: DelayedResult.loading()));
    try {
      final date = DateTime.now();
      final existingRecord = await _repo.findRecordForDate(date);
      final bool isCancelingLeave = event.hours == 0;
      final bool isFullDayLeave = event.hours == 8.0;

      if (existingRecord != null) {
        if (isCancelingLeave && existingRecord.clockOutTime == null && existingRecord.offDuration == null) {
          await _repo.deleteRecord(existingRecord.id);
        } else if (isFullDayLeave) {
          final updated = existingRecord.copyWith(
            clockInTime: DateTime(date.year, date.month, date.day, 8, 0),
            clockOutTime: DateTime(date.year, date.month, date.day, 17, 0),
            leaveDuration: 8.0,
            offDuration: 1.0,
          );
          await _repo.updateRecord(updated);
        } else {
          final updated = existingRecord.copyWith(leaveDuration: event.hours);
          await _repo.updateRecord(updated);
        }
      } else {
        if (isCancelingLeave) {
          emit(state.copyWith(submissionStatus: DelayedResult.success(null)));
          return;
        }
        if (isFullDayLeave) {
          final newRecord = ClockRecord(
            id: _uuid.v4(),
            clockInTime: DateTime(date.year, date.month, date.day, 8, 0),
            clockOutTime: DateTime(date.year, date.month, date.day, 17, 0),
            leaveDuration: 8.0,
            offDuration: 1.0,
          );
          await _repo.createRecord(newRecord);
        } else {
          final newRecord = ClockRecord(
            id: _uuid.v4(),
            clockInTime: DateTime(date.year, date.month, date.day),
            leaveDuration: event.hours,
          );
          await _repo.createRecord(newRecord);
        }
      }
      emit(state.copyWith(submissionStatus: DelayedResult.success(null)));
    } catch (e) {
      emit(state.copyWith(submissionStatus: DelayedResult.failure(e.toString())));
    }
  }

  Future<void> _onRecordDeleted(
    RecordDeleted event,
    Emitter<RecordState> emit,
  ) async {
    emit(state.copyWith(submissionStatus: DelayedResult.loading()));
    try {
      await _repo.deleteRecord(event.id);
      emit(state.copyWith(submissionStatus: DelayedResult.success(null)));
    } catch (e) {
      emit(state.copyWith(submissionStatus: DelayedResult.failure(e.toString())));
    }
  }
}
