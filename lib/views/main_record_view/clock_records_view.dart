// lib/views/main_record_view/clock_records_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_clock/bloc/clock_record_state.dart';
import 'package:wise_clock/bloc/dashboard_bloc.dart';
import 'package:wise_clock/model/editing_target.dart';
import 'package:wise_clock/views/main_record_view/clock_action_card.dart';
import 'package:wise_clock/views/main_record_view/leave_card.dart';
import 'today_diff_time_card.dart';
import 'week_diff_time_card.dart';

class ClockRecordsView extends StatefulWidget {
  const ClockRecordsView({super.key});

  @override
  State<ClockRecordsView> createState() => _ClockRecordsViewState();
}

class _ClockRecordsViewState extends State<ClockRecordsView> {
  EditingTarget _editingTarget = EditingTarget.none;

  void _setEditingTarget(EditingTarget newTarget) {
    setState(() {
      _editingTarget = (_editingTarget == newTarget) ? EditingTarget.none : newTarget;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, dataState) {
        if (dataState.status == DataStatus.loading || dataState.status == DataStatus.initial) {
          return const Center(child: CircularProgressIndicator());
        }
        if (dataState.status == DataStatus.failure) {
          return const Center(child: Text('讀取資料失敗'));
        }

        final todayRecord = dataState.todayRecord;

        return Column(
          children: [
            // ✨ 上班打卡 Widget
            ClockActionCard(
              cardType: EditingTarget.clockIn,
              isEditing: _editingTarget == EditingTarget.clockIn,
              clockInTime: todayRecord?.clockInTime,
              clockOutTime: todayRecord?.clockOutTime,
              // ✨ 關鍵修正：將 leaveDuration 傳遞下去
              leaveDuration: todayRecord?.leaveDuration,
              onToggleEdit: _setEditingTarget,
            ),
            const SizedBox(height: 8),
            // ✨ 下班打卡 Widget
            ClockActionCard(
              cardType: EditingTarget.clockOut,
              isEditing: _editingTarget == EditingTarget.clockOut,
              clockInTime: todayRecord?.clockInTime,
              clockOutTime: todayRecord?.clockOutTime,
              // ✨ 關鍵修正：將 leaveDuration 傳遞下去
              leaveDuration: todayRecord?.leaveDuration,
              onToggleEdit: _setEditingTarget,
            ),
            const SizedBox(height: 8),
            const LeaveCard(),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: TodayDiffTimeCard()),
                const SizedBox(width: 8),
                Expanded(child: WeekDiffTimeCard()),
              ],
            ),
            const Spacer(),
          ],
        );
      },
    );
  }
}
