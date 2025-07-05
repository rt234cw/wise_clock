import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_clock/views/share_ui_components/shared_container.dart';

import '../../bloc/dashboard_bloc.dart';
import '../../bloc/clock_record_state.dart';

class TodayDiffTimeCard extends StatelessWidget {
  const TodayDiffTimeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SharedContainer(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "今日時數",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            if (state.todayRecord?.clockInTime != null && state.todayRecord?.clockOutTime != null) {
              final onTime = state.todayRecord!.clockInTime;
              print('onTime: $onTime');

              final offTime = state.todayRecord!.clockOutTime!;
              print('offTime: $offTime');

              final actualWorkDuration = offTime.difference(onTime);

              // 標準工作時間（9小時）
              final standardWorkDuration = Duration(hours: 9);

              // 計算差異（實際 - 標準）
              final difference = actualWorkDuration - standardWorkDuration;

              // 計算總分鐘數（包含小時轉換成的分鐘）
              final totalMinutes = difference.inMinutes.abs();
              // 計算秒數（不含分鐘部分）
              final seconds = difference.inSeconds.abs() % 60;

              // 格式化文字，補零確保兩位數顯示
              final formattedTime = '${totalMinutes.toString().padLeft(2, '0')}分${seconds.toString().padLeft(2, '0')}秒';

              if (difference.isNegative) {
                return FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '不足 $formattedTime',
                    maxLines: 1,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.red[400],
                        ),
                  ),
                );
              } else {
                return FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '超出 $formattedTime',
                    maxLines: 1,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.green[400],
                        ),
                  ),
                );
              }
            } else {
              return Text('尚未完成打卡');
            }
          },
        )
      ],
    ));
  }
}
