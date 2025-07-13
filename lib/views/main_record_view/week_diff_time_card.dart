// lib/views/main_record_view/week_diff_time_card.dart

import 'package:flutter/material.dart';
import 'package:wise_clock/views/share_ui_components/shared_container.dart';
import '../../bloc/bloc_barrel.dart';
import '../../color_scheme/color_code.dart';
import 'package:wise_clock/hive/clock_record.dart';

class WeekDiffTimeCard extends StatelessWidget {
  const WeekDiffTimeCard({super.key});

  @override
  Widget build(BuildContext context) {
    // 標準一週總工時
    const standardWeekWorkDuration = Duration(hours: 40);
    // 標準休息時間為 1 小時
    const standardBreakDuration = Duration(hours: 1);

    return SharedContainer(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "本週時數",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        BlocBuilder<DashboardBloc, DashboardState>(
          buildWhen: (previous, current) => previous.thisWeekRecords != current.thisWeekRecords,
          builder: (context, state) {
            // ✨ 關鍵修正：在計算前，先篩選出週一到週五的紀錄
            final weekdayRecords = state.thisWeekRecords.where((record) {
              final weekday = record.clockInTime.weekday;
              return weekday >= DateTime.monday && weekday <= DateTime.friday;
            }).toList();

            // 1. 宣告一個變數來累加本週的總認定工時
            Duration totalRecognizedDuration = Duration.zero;

            // 2. ✨ 遍歷篩選後的列表 (weekdayRecords)
            for (final ClockRecord record in weekdayRecords) {
              Duration dailyTotal;

              // 3. 檢查是否為「整天請假」的特殊情況
              if (record.leaveDuration == 8.0) {
                // 如果是，直接將當日認定工時視為 8 小時
                dailyTotal = const Duration(hours: 8);
              } else {
                // 4. 否則，執行正常的詳細計算
                Duration dailyNetWorkDuration = Duration.zero;

                if (record.clockOutTime != null) {
                  final grossDuration = record.clockOutTime!.difference(record.clockInTime);
                  Duration breakToSubtract;
                  if (record.offDuration != null) {
                    breakToSubtract = Duration(seconds: (record.offDuration! * 3600).round());
                  } else {
                    breakToSubtract = (grossDuration.inHours >= 6) ? standardBreakDuration : Duration.zero;
                  }
                  dailyNetWorkDuration = grossDuration - breakToSubtract;
                }

                final leaveInHours = record.leaveDuration ?? 0.0;
                final leaveDuration = Duration(seconds: (leaveInHours * 3600).round());
                dailyTotal = dailyNetWorkDuration + leaveDuration;
              }

              totalRecognizedDuration += dailyTotal.isNegative ? Duration.zero : dailyTotal;
            }

            // --- 接下來的計算和顯示邏輯 ---
            final difference = totalRecognizedDuration - standardWeekWorkDuration;

            final absSeconds = difference.inSeconds.abs();
            final hours = absSeconds ~/ 3600;
            final minutes = (absSeconds % 3600) ~/ 60;

            String formattedTime = '';
            if (hours > 0) {
              formattedTime += '$hours時';
            }
            formattedTime += '${minutes.toString().padLeft(2, '0')}分';

            Color displayColor = Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey;
            String prefix = '正好';

            if (difference.inSeconds > 0) {
              displayColor = ColorCode.green;
              prefix = '超時';
            } else if (difference.inSeconds < 0) {
              displayColor = ColorCode.red;
              prefix = '短缺';
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
