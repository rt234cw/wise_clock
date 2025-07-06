// lib/views/main_record_view/clock_action_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ✨ 1. 引入我們需要的 RecordBloc 和 RecordEvent
import 'package:wise_clock/bloc/record_bloc.dart';
import 'package:wise_clock/bloc/record_event.dart';
import 'package:wise_clock/datetime_id_extension.dart';
import 'package:wise_clock/model/editing_target.dart';
import 'package:wise_clock/views/duty_record_text.dart';
import 'package:wise_clock/views/share_ui_components/shared_container.dart';
import 'package:wise_clock/views/share_ui_components/time_wheel.dart';

class ClockActionCard extends StatelessWidget {
  final EditingTarget cardType;
  final bool isEditing;
  final DateTime? clockInTime;
  final DateTime? clockOutTime;
  final double? leaveDuration;
  final ValueChanged<EditingTarget> onToggleEdit;

  const ClockActionCard({
    super.key,
    required this.cardType,
    required this.isEditing,
    this.clockInTime,
    this.clockOutTime,
    this.leaveDuration,
    required this.onToggleEdit,
  });

  @override
  Widget build(BuildContext context) {
    // ✨ 我們不再需要在 build 的頂層讀取 bloc，因為會在各自的方法中按需讀取
    final relevantTime = (cardType == EditingTarget.clockIn) ? clockInTime : clockOutTime;
    final title = (cardType == EditingTarget.clockIn) ? "上班時間" : "下班時間";

    return SharedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  DutyRecordText(timeRecord: relevantTime?.hmsFormatted),
                ],
              ),
              _buildButtons(context),
            ],
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            child: isEditing ? _buildInputSection(context) : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    // ✨ 2. 在需要發送「寫入」事件的地方，明確地讀取 RecordBloc
    final recordBloc = context.read<RecordBloc>();

    if ((leaveDuration ?? 0.0) == 8.0) {
      return const SizedBox.shrink();
    }

    final relevantTime = (cardType == EditingTarget.clockIn) ? clockInTime : clockOutTime;
    if (isEditing) return const SizedBox.shrink();
    if (cardType == EditingTarget.clockOut && clockInTime == null) return const SizedBox.shrink();

    if (relevantTime == null) {
      return Row(children: [
        TextButton(onPressed: () => onToggleEdit(cardType), child: const Text("手動輸入")),
        const SizedBox(width: 8),
        FilledButton(
            // ✨ ElevatedButton -> FilledButton 保持風格一致
            onPressed: () {
              final now = DateTime.now();
              if (cardType == EditingTarget.clockIn) {
                // ✨ 將事件發送給 RecordBloc，並使用正確的參數名 `time`
                recordBloc.add(ClockInTimeSubmitted(now));
              } else {
                recordBloc.add(ClockOutTimeSubmitted(now));
              }
            },
            child: const Text("快速打卡")),
      ]);
    } else {
      return TextButton(onPressed: () => onToggleEdit(cardType), child: const Text("調整"));
    }
  }

  Widget _buildInputSection(BuildContext context) {
    // ✨ 同樣，在需要發送「寫入」事件的地方，明確地讀取 RecordBloc
    final recordBloc = context.read<RecordBloc>();

    late ({int hour, int min, int sec}) pickedTime;
    final relevantTime = (cardType == EditingTarget.clockIn) ? clockInTime : clockOutTime;

    return Column(
      children: [
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TimeWheel(
              userReocrd: relevantTime != null
                  ? (hour: relevantTime.hour, min: relevantTime.minute, sec: relevantTime.second)
                  : null,
              onSetter: (value) => pickedTime = value,
            ),
            Row(children: [
              TextButton(onPressed: () => onToggleEdit(cardType), child: const Text("取消")),
              FilledButton(
                // ✨ ElevatedButton -> FilledButton 保持風格一致
                onPressed: () {
                  final now = DateTime.now();
                  final newTime =
                      DateTime(now.year, now.month, now.day, pickedTime.hour, pickedTime.min, pickedTime.sec);
                  if (cardType == EditingTarget.clockIn) {
                    // ✨ 將事件發送給 RecordBloc，並使用正確的參數名 `time`
                    recordBloc.add(ClockInTimeSubmitted(newTime));
                  } else {
                    recordBloc.add(ClockOutTimeSubmitted(newTime));
                  }
                  onToggleEdit(cardType); // 操作完成後關閉編輯模式
                },
                child: Text(relevantTime == null ? "打卡" : "更新"),
              ),
            ]),
          ],
        ),
      ],
    );
  }
}
