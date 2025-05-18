import 'package:flutter/material.dart';

import 'clock_records_list_item.dart';

class OnDutyClockRecordListItemView extends StatelessWidget {
  final OnDutyClockRecordsListItem item;

  const OnDutyClockRecordListItemView({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.clockIn.toString()),
    );
  }
}
