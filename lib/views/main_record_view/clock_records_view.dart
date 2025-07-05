import 'package:flutter/material.dart';
import 'package:wise_clock/views/main_record_view/off_duty_card.dart';
import 'package:wise_clock/views/main_record_view/on_duty_card.dart';
import 'today_diff_time_card.dart';
import 'week_diff_time_card.dart';

class ClockRecordsView extends StatefulWidget {
  final ValueChanged;
  const ClockRecordsView({super.key});

  @override
  State<ClockRecordsView> createState() => _ClockRecordsViewState();
}

class _ClockRecordsViewState extends State<ClockRecordsView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      children: [
        OnDutyCard(),
        OffDutyCard(),
        Row(
          children: [
            Expanded(child: TodayDiffTimeCard()),
            const SizedBox(width: 4),
            Expanded(child: WeekDiffTimeCard()),
          ],
        ),
        Spacer(),
        // OverflowBar(
        //   children: [
        //     ElevatedButton(
        //       onPressed: () async {
        //         await hiveService.clockInRecordsBox.put(
        //             "1",
        //             ClockRecord(
        //                 id: "1",
        //                 clockInTime: DateTime(2025, 5, 19, 9, 31, 27),
        //                 clockOutTime: DateTime(2025, 5, 19, 17, 31, 27)));
        //       },
        //       child: Text("星期一"),
        //     ),
        //     ElevatedButton(
        //       onPressed: () async {
        //         await hiveService.clockInRecordsBox.put(
        //             "2",
        //             ClockRecord(
        //                 id: "2",
        //                 clockInTime: DateTime(2025, 5, 21, 9, 31, 27),
        //                 clockOutTime: DateTime(2025, 5, 21, 19, 31, 28)));
        //       },
        //       child: Text("星期三"),
        //     ),
        //     ElevatedButton(
        //       onPressed: () async {
        //         await hiveService.clockInRecordsBox.put(
        //             "8",
        //             ClockRecord(
        //                 id: "8",
        //                 clockInTime: DateTime(2025, 5, 18, 9, 31, 27),
        //                 clockOutTime: DateTime(2025, 5, 18, 18, 31, 29)));
        //       },
        //       child: Text("星期日"),
        //     ),
        //   ],
        // )
      ],
    );
  }
}
