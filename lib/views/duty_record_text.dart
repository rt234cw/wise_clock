import 'package:flutter/material.dart';

class DutyRecordText extends StatelessWidget {
  final String? timeRecord;
  const DutyRecordText({super.key, this.timeRecord});

  @override
  Widget build(BuildContext context) {
    return Text(
      timeRecord ?? "尚未打卡",
      style: TextStyle(
        fontSize: timeRecord == null ? 18 : 24,
        fontWeight: FontWeight.w600,
        color: timeRecord != null ? Colors.black : Colors.grey,
      ),
    );
  }
}
