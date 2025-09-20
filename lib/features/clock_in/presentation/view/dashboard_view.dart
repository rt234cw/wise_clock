import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_clock/core/bloc/record_bloc.dart';
import 'package:wise_clock/core/bloc/record_event.dart';
import 'package:wise_clock/core/data/models/clock_record.dart';
import 'package:wise_clock/features/clock_in/bloc/dashboard_state.dart';
import 'package:wise_clock/features/clock_in/bloc/dashboard_bloc.dart';
import 'package:wise_clock/features/clock_in/presentation/models/editing_target.dart';
import 'package:wise_clock/features/clock_in/presentation/widget/clock_action_card.dart';
import 'package:wise_clock/features/clock_in/presentation/widget/current_week_quick_list_view.dart';
import 'package:wise_clock/features/clock_in/presentation/widget/leave_card.dart';

import '../../../../generated/l10n.dart';
import '../widget/week_diff_time_card.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  EditingTarget _editingTarget = EditingTarget.none;

  final bool _isEditingTodayRecord = false;
  // 用來暫存使用者在 TimeWheel 上的選擇
  DateTime? _tempClockIn;
  DateTime? _tempClockOut;

  Timer? _timer;
  Duration _elapsedTime = Duration.zero;

  @override
  void initState() {
    super.initState();
    // 檢查初始狀態，如果 App 打開時就已經是「上班中」，則直接啟動計時器
    final initialState = context.read<DashboardBloc>().state;
    final todayRecord = initialState.todayRecord;
    if (todayRecord != null && todayRecord.clockOutTime == null) {
      _startTimer(todayRecord.clockInTime);
    }
  }

  void _startTimer(DateTime clockInTime) {
    // 確保舊的計時器被取消，防止記憶體洩漏
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _elapsedTime = DateTime.now().difference(clockInTime);
        });
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  // ✨ 格式化 Duration 為 hh:mm:ss
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  @override
  void dispose() {
    _timer?.cancel(); // 在 Widget 銷毀時，務必取消計時器
    super.dispose();
  }

  void _setEditingTarget(EditingTarget newTarget) {
    setState(() {
      _editingTarget = (_editingTarget == newTarget) ? EditingTarget.none : newTarget;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return BlocConsumer<DashboardBloc, DashboardState>(
      listener: (context, state) {
        final todayRecord = state.todayRecord;
        // 監聽 BLoC 狀態變化，用來控制計時器的啟動與停止
        if (todayRecord != null && todayRecord.clockOutTime == null) {
          _startTimer(todayRecord.clockInTime);
        } else {
          _stopTimer();
        }
      },
      builder: (context, dataState) {
        if (dataState.status == DataStatus.loading || dataState.status == DataStatus.initial) {
          return const Center(child: CircularProgressIndicator());
        }
        if (dataState.status == DataStatus.failure) {
          return Center(child: Text(S.current.dataLoadingFailed));
        }

        final todayRecord = dataState.todayRecord;

        return SingleChildScrollView(
          child: Column(
            children: [
              _circularMainButton(todayRecord),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: _dashBoardContent(context, todayRecord, colorScheme),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _circularMainButton(ClockRecord? todayRecord) {
    final recordBloc = context.read<RecordBloc>();

    Widget child;
    VoidCallback? onPressed;

    final bool isWorking = todayRecord != null && todayRecord.clockOutTime == null;

    if (todayRecord == null) {
      // --- 狀態一：尚未打卡 ---
      child = Text(S.of(context).clockInTime, style: Theme.of(context).textTheme.titleLarge);
      onPressed = () {
        recordBloc.add(ClockInTimeSubmitted(DateTime.now()));
      };
    } else if (todayRecord.clockOutTime == null) {
      // --- 狀態二：上班中 (計時器) ---
      child = Text(
        _formatDuration(_elapsedTime),
        style: Theme.of(context).textTheme.headlineMedium,
      );
      onPressed = () {
        recordBloc.add(ClockOutTimeSubmitted(DateTime.now()));
      };
    } else {
      // --- 狀態三：已下班 ---
      // ✨ 使用您之前撰寫的、更精確的工時計算邏輯
      final grossDuration = todayRecord.clockOutTime!.difference(todayRecord.clockInTime);
      const fourHours = Duration(hours: 4);
      const fiveHours = Duration(hours: 5);
      const oneHourBreak = Duration(hours: 1);
      Duration workDuration; // 將變數名稱改為 workDuration

      if (grossDuration > fiveHours) {
        workDuration = grossDuration - oneHourBreak;
      } else if (grossDuration > fourHours) {
        workDuration = fourHours;
      } else {
        workDuration = grossDuration;
      }
      child = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("已下班", style: Theme.of(context).textTheme.titleMedium),
          Text(
            "工時: ${_formatDuration(workDuration)}",
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      );
      onPressed = null; // 已下班，按鈕不可點擊
    }

    return GestureDetector(
      onTap: onPressed,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
              width: 145,
              height: 145,
              decoration: ShapeDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [const Color(0xFF424242), const Color(0xFF424242).withValues(alpha: 0.2)],
                  ),
                  shape: const CircleBorder())),
          Container(
              width: 140,
              height: 140,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFFFFD58B), Color(0xFFFFEED0)]))),
          Container(
            width: 135,
            height: 135,
            decoration: isWorking
                ? const BoxDecoration(
                    // 「上班中」狀態使用黃色漸層
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFFFC358), Color(0xFFFFEED0)],
                    ),
                  )
                : const BoxDecoration(
                    // 其他狀態使用深灰色純色
                    shape: BoxShape.circle,
                    color: Color(0xFF424242),
                  ),
            child: Center(child: child), // ✨ 將動態的 child 放入最上層的圓形中
          ),
        ],
      ),
    );
  }

  Widget _dashBoardContent(BuildContext context, ClockRecord? todayRecord, ColorScheme colorScheme) {
    final recordBloc = context.read<RecordBloc>();
    bool isEditing = false;

    return StatefulBuilder(builder: (context, setState) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "今日打卡",
                style: Theme.of(context).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.bold),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    isEditing = !isEditing;
                  });
                },
                child: Text(S.current.update),
              )
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: <Widget>[
              // 上班打卡 Widget
              Expanded(
                child: ClockActionCard(
                  cardType: EditingTarget.clockIn,
                  // isEditing: _editingTarget == EditingTarget.clockIn,
                  isEditing: isEditing,
                  clockInTime: todayRecord?.clockInTime,
                  clockOutTime: todayRecord?.clockOutTime,
                  leaveDuration: todayRecord?.leaveDuration,
                  onToggleEdit: _setEditingTarget,
                ),
              ),
              const SizedBox(width: 8),
              //  下班打卡 Widget
              Expanded(
                child: ClockActionCard(
                  cardType: EditingTarget.clockOut,
                  // isEditing: _editingTarget == EditingTarget.clockOut,
                  isEditing: isEditing,
                  clockInTime: todayRecord?.clockInTime,
                  clockOutTime: todayRecord?.clockOutTime,
                  leaveDuration: todayRecord?.leaveDuration,
                  onToggleEdit: _setEditingTarget,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            S.current.leaveHours,
            style: Theme.of(context).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const LeaveCard(),
          const SizedBox(height: 8),
          WeeklyAccumulatedTimeCard(),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: colorScheme.onSurface.withValues(alpha: 0.15)),
              color: colorScheme.onSurface.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(10),
            ),
            child: CurrentWeekQuickTableView(),
          ),
        ],
      );
    });
  }
}
