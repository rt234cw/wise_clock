import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_clock/core/bloc/record_event.dart';
import 'package:wise_clock/core/data/models/clock_record.dart';

import 'package:wise_clock/shared/widgets/time_wheel.dart';

import '../../core/bloc/record_bloc.dart';
import '../../generated/l10n.dart';

Future<void> showEditRecordDialog({
  required BuildContext context,
  required DateTime selectedDate,
  ClockRecord? existingRecord,
}) async {
  final recordBloc = context.read<RecordBloc>();

  var tempClockInTime = existingRecord != null
      ? (
          hour: existingRecord.clockInTime.hour,
          min: existingRecord.clockInTime.minute,
          sec: existingRecord.clockInTime.second
        )
      : (hour: 8, min: 0, sec: 0);

  var tempClockOutTime = existingRecord?.clockOutTime != null
      ? (
          hour: existingRecord!.clockOutTime!.hour,
          min: existingRecord.clockOutTime!.minute,
          sec: existingRecord.clockOutTime!.second
        )
      : null;

  var tempLeaveHours = existingRecord?.leaveDuration ?? 0.0;

  final confirmed = await showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          return Material(
            type: MaterialType.transparency,
            child: Theme(
              data: Theme.of(context).copyWith(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
              ),
              child: Dialog(
                insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        S.current.editRecord,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      _buildEditRow(
                        context,
                        S.current.clockInTime,
                        TimeWheel(onSetter: (value) => tempClockInTime = value, userReocrd: tempClockInTime),
                      ),
                      _buildEditRow(
                        context,
                        S.current.clockOutTime,
                        TimeWheel(
                            onSetter: (value) => tempClockOutTime = value,
                            userReocrd: tempClockOutTime ?? (hour: 17, min: 0, sec: 0)),
                      ),
                      _buildEditRow(
                          context,
                          S.current.leave,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              DropdownButtonHideUnderline(
                                child: DropdownButton2<double>(
                                  dropdownStyleData: DropdownStyleData(
                                    maxHeight: 200,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Theme.of(context).colorScheme.surface,
                                    ),
                                  ),
                                  value: tempLeaveHours,
                                  items: List.generate(9, (i) => i.toDouble())
                                      .map((h) => DropdownMenuItem(
                                          value: h,
                                          child: Text(h == 0
                                              ? S.current.noLeave
                                              : "${h.toInt()} ${S.current.hoursUnit(h.toInt())}")))
                                      .toList(),
                                  onChanged: (v) => setDialogState(() => tempLeaveHours = v ?? 0.0),
                                ),
                              ),
                            ],
                          )),
                      const SizedBox(height: 32),
                      _buildDialogActions(context),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    },
  );

  if (confirmed == true) {
    // 提交邏輯保持不變，但現在是共用的
    final newClockInTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      tempClockInTime.hour,
      tempClockInTime.min,
      tempClockInTime.sec,
    );
    recordBloc.add(ClockInTimeSubmitted(newClockInTime));

    if (tempClockOutTime != null) {
      final newClockOutTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        tempClockOutTime!.hour,
        tempClockOutTime!.min,
        tempClockOutTime!.sec,
      );
      recordBloc.add(ClockOutTimeSubmitted(newClockOutTime));
    }

    recordBloc.add(LeaveDurationSubmitted(
      date: selectedDate,
      hours: tempLeaveHours,
    ));
  }
}

//  建立編輯對話框中每一行的方法
Widget _buildEditRow(BuildContext context, String label, Widget control) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleMedium),
        control,
      ],
    ),
  );
}

Widget _buildDialogActions(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(false),
        child: Text(S.of(context).cancel),
      ),
      const SizedBox(width: 8),
      FilledButton(
        onPressed: () => Navigator.of(context).pop(true),
        child: Text(S.of(context).update),
      ),
    ],
  );
}
