import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_clock/bloc/clock_record_state.dart';
import 'package:wise_clock/bloc/dashboard_bloc.dart';
import 'package:wise_clock/model/editing_target.dart';
import 'package:wise_clock/views/main_record_view/clock_action_card.dart';
import 'package:wise_clock/views/main_record_view/current_week_quick_list_view.dart';
import 'package:wise_clock/views/main_record_view/leave_card.dart';

import '../../generated/l10n.dart';
import 'week_diff_time_card.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  EditingTarget _editingTarget = EditingTarget.none;

  void _setEditingTarget(EditingTarget newTarget) {
    setState(() {
      _editingTarget = (_editingTarget == newTarget) ? EditingTarget.none : newTarget;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, dataState) {
        if (dataState.status == DataStatus.loading || dataState.status == DataStatus.initial) {
          return const Center(child: CircularProgressIndicator());
        }
        if (dataState.status == DataStatus.failure) {
          return Center(child: Text(S.current.dataLoadingFailed));
        }

        final todayRecord = dataState.todayRecord;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 上班打卡 Widget
            ClockActionCard(
              cardType: EditingTarget.clockIn,
              isEditing: _editingTarget == EditingTarget.clockIn,
              clockInTime: todayRecord?.clockInTime,
              clockOutTime: todayRecord?.clockOutTime,
              leaveDuration: todayRecord?.leaveDuration,
              onToggleEdit: _setEditingTarget,
            ),
            const SizedBox(height: 8),
            //  下班打卡 Widget
            ClockActionCard(
              cardType: EditingTarget.clockOut,
              isEditing: _editingTarget == EditingTarget.clockOut,
              clockInTime: todayRecord?.clockInTime,
              clockOutTime: todayRecord?.clockOutTime,
              leaveDuration: todayRecord?.leaveDuration,
              onToggleEdit: _setEditingTarget,
            ),
            const SizedBox(height: 8),
            const LeaveCard(),
            const SizedBox(height: 8),
            WeeklyAccumulatedTimeCard(),
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: colorScheme.onSurface.withValues(alpha: 0.15)),
                  color: colorScheme.onSurface.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: CurrentWeekQuickTableView(),
              ),
            ),
          ],
        );
      },
    );
  }
}
