// lib/views/main_record_view/clock_action_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_clock/bloc/dashboard_bloc.dart';
import 'package:wise_clock/bloc/dashboard_event.dart';
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
  // ✨ 1. 新增 leaveDuration 參數，讓這個 Widget 知道請假狀態
  final double? leaveDuration;
  final ValueChanged<EditingTarget> onToggleEdit;

  const ClockActionCard({
    super.key,
    required this.cardType,
    required this.isEditing,
    this.clockInTime,
    this.clockOutTime,
    // ✨ 2. 將 leaveDuration 加入建構函式
    this.leaveDuration,
    required this.onToggleEdit,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<DashboardBloc>();
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
              _buildButtons(context, bloc),
            ],
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            child: isEditing ? _buildInputSection(context, bloc) : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildButtons(BuildContext context, DashboardBloc bloc) {
    // ✨ 3. 關鍵修正：現在可以直接使用傳入的 leaveDuration
    if ((leaveDuration ?? 0.0) == 8.0) {
      // 如果是整天請假，則不顯示任何按鈕
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
            onPressed: () {
              final now = DateTime.now();
              if (cardType == EditingTarget.clockIn) {
                bloc.add(ClockInTimeSubmitted(clockInTime: now));
              } else {
                bloc.add(ClockOutTimeSubmitted(clockOutTime: now));
              }
            },
            child: const Text("快速打卡")),
      ]);
    } else {
      return TextButton(onPressed: () => onToggleEdit(cardType), child: const Text("調整"));
    }
  }

  Widget _buildInputSection(BuildContext context, DashboardBloc bloc) {
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
                onPressed: () {
                  final now = DateTime.now();
                  final newTime =
                      DateTime(now.year, now.month, now.day, pickedTime.hour, pickedTime.min, pickedTime.sec);
                  if (cardType == EditingTarget.clockIn) {
                    bloc.add(ClockInTimeSubmitted(clockInTime: newTime));
                  } else {
                    bloc.add(ClockOutTimeSubmitted(clockOutTime: newTime));
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
