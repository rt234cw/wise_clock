import 'package:flutter/material.dart';
import 'package:wise_clock/views/share_ui_components/shared_container.dart';
import '../../bloc/bloc_barrel.dart';
import '../../color_scheme/color_code.dart';

class WeekDiffTimeCard extends StatefulWidget {
  const WeekDiffTimeCard({super.key});

  @override
  State<WeekDiffTimeCard> createState() => _WeekDiffTimeCardState();
}

class _WeekDiffTimeCardState extends State<WeekDiffTimeCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SharedContainer(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "本週時數",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            final overInSeconds = state.thisWeekOverSeconds;
            // 取絕對值計算分鐘和剩餘秒數
            final absSeconds = overInSeconds.abs();
            final minutes = absSeconds ~/ 60; // 整除取分鐘數
            final seconds = absSeconds % 60; // 取餘數得到秒數

            final formattedTime = '${minutes.toString().padLeft(1, '0')}分${seconds.toString().padLeft(2, '0')}秒';
            // 根據正負值返回不同文字和顏色
            if (overInSeconds > 0) {
              return FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  '超時 $formattedTime',
                  maxLines: 1,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: ColorCode.green,
                      ),
                ),
              );
            } else if (overInSeconds < 0) {
              return FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  '短缺 $formattedTime',
                  maxLines: 1,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: ColorCode.red,
                      ),
                ),
              );
            } else {
              return FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  '正好 00:00',
                  maxLines: 1,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              );
            }
          },
        )
      ],
    ));
  }
}
