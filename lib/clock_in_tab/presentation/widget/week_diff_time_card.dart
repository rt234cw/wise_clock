import 'package:flutter/material.dart';
import 'package:wise_clock/generated/l10n.dart';
import 'package:wise_clock/views/share_ui_components/shared_container.dart';
import '../../bloc/bloc_barrel.dart';

import 'package:wise_clock/hive/clock_record.dart';

class WeeklyAccumulatedTimeCard extends StatelessWidget {
  const WeeklyAccumulatedTimeCard({super.key});

  @override
  Widget build(BuildContext context) {
    // 標準休息時間為 1 小時
    const standardBreakDuration = Duration(hours: 1);

    return SharedContainer(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.current.accumulatedHours,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        BlocBuilder<DashboardBloc, DashboardState>(
          buildWhen: (previous, current) => previous.thisWeekRecords != current.thisWeekRecords,
          builder: (context, state) {
            // 篩選出本週一到五，實際有打卡紀錄的日子
            final weekdayRecords = state.thisWeekRecords.where((record) {
              final weekday = record.clockInTime.weekday;
              return record.clockOutTime != null && weekday >= DateTime.monday && weekday <= DateTime.friday;
            }).toList();

            // 計算動態的「應有」標準工時
            // 應有工作天數 = 實際有打卡的天數
            final int workingDaysWithRecords = weekdayRecords.length;
            // 應有的標準總工時 = 有打卡的天數 * 8 小時 (因為9小時含1小時休息)
            final standardWorkDurationForRecordedDays = Duration(hours: workingDaysWithRecords * 8);

            // 計算「實際」累積的認定工時 (只計算那些有打卡的日子)
            Duration totalRecognizedDuration = Duration.zero;

            for (final ClockRecord record in weekdayRecords) {
              Duration dailyTotal;
              if (record.leaveDuration == 8.0) {
                dailyTotal = const Duration(hours: 8);
              } else {
                Duration dailyNetWorkDuration = Duration.zero;

                final grossDuration = record.clockOutTime!.difference(record.clockInTime);
                const fourHours = Duration(hours: 4);
                const fiveHours = Duration(hours: 5);

                // 大於五小時，就要扣除一小時的休息時間
                if (grossDuration > fiveHours) {
                  dailyNetWorkDuration = grossDuration - standardBreakDuration;
                }
                //大於四小時，小於五小時，工時等於4小時
                else if (grossDuration > fourHours) {
                  dailyNetWorkDuration = fourHours;
                }

                // 小於四小時，不計算休息時間
                else {
                  dailyNetWorkDuration = grossDuration;
                }

                final leaveInHours = record.leaveDuration ?? 0.0;
                final leaveDuration = Duration(seconds: (leaveInHours * 3600).round());
                dailyTotal = dailyNetWorkDuration + leaveDuration;
              }
              totalRecognizedDuration += dailyTotal.isNegative ? Duration.zero : dailyTotal;
            }

            // 計算差異並顯示
            final difference = totalRecognizedDuration - standardWorkDurationForRecordedDays;
            final absSeconds = difference.inSeconds.abs();
            final hours = absSeconds ~/ 3600;
            final minutes = (absSeconds % 3600) ~/ 60;

            String formattedTime = '';
            if (hours > 0) {
              formattedTime += '$hours ${S.current.hoursUnit(hours)}';
            }
            formattedTime +=
                '${minutes.toString().padLeft(2, minutes == 0 ? '' : '0')} ${S.current.minutesUnit(minutes == 0 ? 1 : minutes)}';

            Color displayColor = Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey;
            String prefix = S.current.balanced;

            if (difference.inSeconds > 0) {
              displayColor = Colors.greenAccent;
              prefix = S.current.overtime;
            } else if (difference.inSeconds < 0) {
              displayColor = Colors.redAccent;
              prefix = S.current.shortage;
            }

            return FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                '$prefix $formattedTime',
                maxLines: 1,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: displayColor,
                    ),
              ),
            );
          },
        )
      ],
    ));
  }
}
