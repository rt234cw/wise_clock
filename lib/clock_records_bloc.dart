import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_clock/clock_records_repository.dart';
import 'package:wise_clock/models/clock_records_event.dart';
import 'package:wise_clock/models/clock_records_state.dart';
import 'delayed_result.dart';

class ClockRecordsBloc extends Bloc<ClockRecordsEvent, ClockRecordsState> {
  final ClockRecordsRepository _repo;

  ClockRecordsBloc(this._repo) : super(const ClockRecordsState()) {
    on<ClockInPressed>(_onClockIn);
    on<ClockInEdited>(_onClockInEdited);
    on<ClockInEditStarted>((e, emit) => emit(state.copyWith(isEditingClockIn: true)));
    on<ClockInEditCanceled>((e, emit) => emit(state.copyWith(isEditingClockIn: false)));
    on<ClockOutPressed>(_onClockOut);
    on<FetchClockLogs>(_onFetch);
  }

  Future<void> _onClockIn(ClockInPressed e, Emitter<ClockRecordsState> emit) async {
    final log = await _repo.upsertClockIn(e.clockIn);
    emit(state.copyWith(
      currentLog: log,
      loadingResult: const DelayedResult.idle(),
    ));
  }

  Future<void> _onClockInEdited(ClockInEdited e, Emitter<ClockRecordsState> emit) async {
    emit(state.copyWith(loadingResult: const DelayedResult.inProgress()));
    final log = await _repo.upsertClockIn(e.newClckIn); // 重新覆寫 clockIn
    emit(state.copyWith(
      currentLog: log,
      loadingResult: const DelayedResult.idle(),
      isEditingClockIn: false,
    ));
  }

  Future<void> _onClockOut(ClockOutPressed e, Emitter<ClockRecordsState> emit) async {
    final log = await _repo.upsertClockOut(e.clockOut);
    emit(state.copyWith(
      currentLog: log,
      loadingResult: const DelayedResult.idle(),
    ));
  }

  Future<void> _onFetch(FetchClockLogs e, Emitter<ClockRecordsState> emit) async {
    final logs = await _repo.fetchLogs();
    emit(state.copyWith(
      allLogs: logs,
      loadingResult: const DelayedResult.idle(),
    ));
  }
}
