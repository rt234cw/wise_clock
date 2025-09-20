import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_clock/core/bloc/record_bloc.dart';
import 'package:wise_clock/core/bloc/record_event.dart';
import 'package:wise_clock/shared/utils/datetime_id_extension.dart';
import 'package:wise_clock/features/clock_in/presentation/models/editing_target.dart';
import 'package:wise_clock/features/clock_in/presentation/widget/duty_record_text.dart';
import 'package:wise_clock/shared/widgets/shared_container.dart';
import 'package:wise_clock/shared/widgets/time_wheel.dart';

import '../../../../generated/l10n.dart';

// 檔案: clock_action_card.dart

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
    final relevantTime = (cardType == EditingTarget.clockIn) ? clockInTime : clockOutTime;
    final title = (cardType == EditingTarget.clockIn) ? S.current.clockInTime : S.current.clockOutTime;
    // 如果 relevantTime 是 null，就用當前時間作為預設值
    final initialDateTime = relevantTime ?? DateTime.now();

    return SharedContainer(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 4),
                  if (isEditing)
                    DutyRecordText(timeRecord: relevantTime?.hmsFormatted)
                  else
                    // --- 主要修正區域 ---
                    AdjustableClockContainer(
                      timeRecord: relevantTime?.hmsFormatted ?? '--:--:--',
                      // 1. 補上 initialTime
                      initialTime: initialDateTime,
                      // 2. 補上 cardType
                      cardType: cardType,
                      // 3. 補上 onTimeConfirmed 回調
                      onTimeConfirmed: (newTime) {
                        // 在這裡你可以呼叫 BLoC event 來更新狀態
                        print('新時間已確認: $newTime');
                        if (cardType == EditingTarget.clockIn) {
                          context.read<RecordBloc>().add(
                                UpdateRecord(
                                  id: initialDateTime.toDateId(),
                                  clockIn: newTime,
                                ),
                              );
                        } else {
                          context.read<RecordBloc>().add(
                                UpdateRecord(
                                  id: initialDateTime.toDateId(),
                                  clockOut: newTime,
                                ),
                              );
                        }
                      },
                    )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// 新增一個 callback 型別，用於回傳選擇的時間
typedef OnTimeConfirmed = void Function(DateTime newTime);

class AdjustableClockContainer extends StatefulWidget {
  final String timeRecord;
  final DateTime initialTime; // 傳入初始的 DateTime 物件，方便時間選擇器初始化
  final OnTimeConfirmed onTimeConfirmed;
  final EditingTarget cardType; // 傳入 cardType 以便 dispatch event

  const AdjustableClockContainer({
    required this.timeRecord,
    required this.initialTime,
    required this.onTimeConfirmed,
    required this.cardType,
    super.key,
  });

  @override
  State<AdjustableClockContainer> createState() => _AdjustableClockContainerState();
}

// 檔案: adjustable_clock_container.dart

class _AdjustableClockContainerState extends State<AdjustableClockContainer> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  late DateTime _selectedTime;

  @override
  void initState() {
    super.initState();
    _selectedTime = widget.initialTime;
  }

  @override
  void didUpdateWidget(covariant AdjustableClockContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialTime != oldWidget.initialTime) {
      _selectedTime = widget.initialTime;
    }
  }

  @override
  void dispose() {
    _hideOverlay();
    super.dispose();
  }

  // --- 主要修正區域 ---
  void _showOverlay() {
    if (_overlayEntry != null) return;

    final overlayState = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    // 1. 宣告 tempRecord 變數
    ({int hour, int min, int sec}) tempRecord = (
      hour: _selectedTime.hour,
      min: _selectedTime.minute,
      sec: _selectedTime.second,
    );

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return TapRegion(
          onTapOutside: (_) => _hideOverlay(),
          child: Stack(
            children: [
              CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(0.0, size.height + 8.0),
                child: Material(
                  elevation: 4.0,
                  color: const Color(0xff2a2a2a),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TimeWheel(
                          key: ValueKey(_selectedTime),
                          initialTime: (
                            hour: _selectedTime.hour,
                            min: _selectedTime.minute,
                            sec: _selectedTime.second,
                          ),
                          onTimeChanged: (newTimeRecord) {
                            // 更新 tempRecord
                            tempRecord = newTimeRecord;
                          },
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: _hideOverlay,
                              child: const Text('取消'),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () {
                                // 2. 修正按鈕的邏輯，使用 tempRecord 來建立新時間
                                final newFinalTime = DateTime(
                                  _selectedTime.year,
                                  _selectedTime.month,
                                  _selectedTime.day,
                                  tempRecord.hour,
                                  tempRecord.min,
                                  tempRecord.sec,
                                );
                                // 回傳這個最終的新時間
                                widget.onTimeConfirmed(newFinalTime);
                                _hideOverlay();
                              },
                              child: const Text('確認'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
    overlayState.insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    // build 方法不變
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _showOverlay,
        child: Container(
          height: 40,
          width: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: const Color(0xff101010),
            border: Border.all(color: const Color(0xffFFEED0)),
          ),
          padding: const EdgeInsets.all(4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(widget.timeRecord, style: Theme.of(context).textTheme.bodyMedium),
              const Icon(Icons.timer_sharp, color: Color(0xffFFEED0)),
            ],
          ),
        ),
      ),
    );
  }
}
