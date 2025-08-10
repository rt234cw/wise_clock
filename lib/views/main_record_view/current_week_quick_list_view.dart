import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:wise_clock/bloc/bloc_barrel.dart';
import 'package:wise_clock/generated/l10n.dart';
import 'package:wise_clock/hive/clock_record.dart';

import '../../providers/locale_provider.dart';

class CurrentWeekQuickTableView extends StatelessWidget {
  const CurrentWeekQuickTableView({super.key});

  // 輔助函式：格式化時間，如果為 null 則返回 '---
  String _formatTime(DateTime? time) {
    if (time == null) return '---';
    return DateFormat('HH:mm').format(time);
  }

  // 輔助函式：計算單日工時與標準8小時的差異
  Duration _calculateDailyDifference(ClockRecord record) {
    const standardBreakDuration = Duration(hours: 1);
    const standardWorkDuration = Duration(hours: 8);

    Duration totalRecognizedDuration;

    if (record.leaveDuration == 8.0) {
      totalRecognizedDuration = const Duration(hours: 8);
    } else {
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
      totalRecognizedDuration = (dailyNetWorkDuration + leaveDuration);
    }

    final difference = totalRecognizedDuration - standardWorkDuration;
    return difference;
  }

  // 輔助函式：將 Duration 格式化為 "+/- X分"
  String _formatDifferenceInMinutes(Duration difference) {
    final totalMinutes = difference.inMinutes;

    if (totalMinutes == 0) {
      return '0 ${S.current.abbreMinute}';
    } else if (totalMinutes > 0) {
      return '+$totalMinutes';
    } else {
      return '$totalMinutes';
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>().locale?.toString();
    return BlocBuilder<DashboardBloc, DashboardState>(
      buildWhen: (prev, curr) => prev.thisWeekRecords != curr.thisWeekRecords,
      builder: (context, state) {
        // 加入星期一到五的篩選
        final recordsToShow = state.thisWeekRecords.where((record) {
          final weekday = record.clockInTime.weekday;
          final hasActivity = record.clockOutTime != null || (record.leaveDuration ?? 0) > 0;

          // 條件：必須是週一到週五，並且有活動紀錄
          return weekday >= DateTime.monday && weekday <= DateTime.friday && hasActivity;
        }).toList();

        recordsToShow.sort((a, b) => a.clockInTime.compareTo(b.clockInTime));

        if (recordsToShow.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(S.current.noCompletedRecords),
            ),
          );
        }

        return SizedBox(
          height: 200,
          width: double.infinity,
          child: DataTable2(
            fixedTopRows: 1,
            headingRowHeight: 40,
            dataRowHeight: 36,
            dividerThickness: 0, // 移除分隔線
            columnSpacing: 12,

            columns: [
              DataColumn(label: Text(S.current.day, style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text(S.current.workIn, style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text(S.current.out, style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text(S.current.leave, style: TextStyle(fontWeight: FontWeight.bold)), numeric: true),
              DataColumn(label: Text("+/-", style: TextStyle(fontWeight: FontWeight.bold)), numeric: true),
            ],
            rows: recordsToShow.map((record) {
              final dailyDifference = _calculateDailyDifference(record);
              final timeValue = _formatDifferenceInMinutes(dailyDifference);

              return DataRow(
                cells: [
                  DataCell(Text(DateFormat.E(locale).format(record.clockInTime))),
                  DataCell(Text(_formatTime(record.clockInTime))),
                  DataCell(Text(_formatTime(record.clockOutTime))),
                  DataCell(Text("${record.leaveDuration?.toInt() ?? 0} ${S.current.abbreHour}")),
                  DataCell(
                    Text(
                      timeValue,
                      style: TextStyle(
                        color: dailyDifference.isNegative ? Colors.red : Colors.green,
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
