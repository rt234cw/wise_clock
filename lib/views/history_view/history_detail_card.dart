// lib/views/history_view/history_detail_card.dart

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:wise_clock/bloc/record_bloc.dart';
import 'package:wise_clock/bloc/record_event.dart';
import 'package:wise_clock/hive/clock_record.dart';

import '../share_ui_components/time_wheel.dart';

class HistoryDetailCard extends StatefulWidget {
  // ✨ 1. 我們現在接收一個強型別的 ClockRecord 物件
  final ClockRecord record;

  const HistoryDetailCard({super.key, required this.record});

  @override
  State<HistoryDetailCard> createState() => _HistoryDetailCardState();
}

class _HistoryDetailCardState extends State<HistoryDetailCard> {
  // UI 狀態：控制卡片是處於「編輯模式」還是「檢視模式」
  bool _isEditing = false;

  // UI 狀態：用於編輯模式下的暫存值
  late ({int hour, int min, int sec}) _pickedClockIn;
  late ({int hour, int min, int sec})? _pickedClockOut;
  late double _pickedLeaveHours;

  // ✨ 1. 全新的「顯示編輯對話框」方法
  Future<void> _showEditDialog() async {
    final recordBloc = context.read<RecordBloc>();
    final recordDate = widget.record.clockInTime;

    // 用於在對話框中暫存使用者選擇的時間
    var tempClockIn = (hour: recordDate.hour, min: recordDate.minute, sec: recordDate.second);
    var tempClockOut = widget.record.clockOutTime != null
        ? (
            hour: widget.record.clockOutTime!.hour,
            min: widget.record.clockOutTime!.minute,
            sec: widget.record.clockOutTime!.second
          )
        : null;
    var tempLeaveHours = widget.record.leaveDuration ?? 0.0;

    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false, // 防止用戶點擊背景關閉
      builder: (ctx) {
        // ✨ 使用 StatefulBuilder 來讓對話框內的 UI 可以獨立刷新
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Material(
              type: MaterialType.transparency, // 類型設為透明，避免產生背景色
              child: Theme(
                data: Theme.of(context).copyWith(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                ),
                child: AlertDialog.adaptive(
                  title: const Text("編輯紀錄"),
                  contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildEditRow(
                          context,
                          "上班時間",
                          TimeWheel(userReocrd: tempClockIn, onSetter: (v) => tempClockIn = v),
                        ),
                        _buildEditRow(
                          context,
                          "下班時間",
                          TimeWheel(userReocrd: tempClockOut, onSetter: (v) => tempClockOut = v),
                        ),
                        _buildEditRow(
                          context,
                          "請假/公出",
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              DropdownButtonHideUnderline(
                                child: DropdownButton2<double>(
                                  value: tempLeaveHours,
                                  dropdownStyleData: DropdownStyleData(
                                    maxHeight: 160,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 4,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                  ),
                                  items: List.generate(9, (i) => i.toDouble())
                                      .map((h) =>
                                          DropdownMenuItem(value: h, child: Text(h == 0 ? "未請假" : "${h.toInt()} 小時")))
                                      .toList(),
                                  onChanged: (v) => setDialogState(() => tempLeaveHours = v ?? 0.0),
                                ),
                              ),
                              // Switch.adaptive(
                              //   value: tempLeaveHours == 8.0,
                              //   onChanged: (v) => setDialogState(() => tempLeaveHours = v ? 8.0 : 0.0),
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: _buildDialogActions(ctx, isDelete: false),
                ),
              ),
            );
          },
        );
      },
    );

    // 如果使用者點擊了「儲存變更」
    if (confirmed == true) {
      // 只有在時間真的改變時才發送事件，減少不必要的 BLoC 活動
      final newClockInTime = DateTime(
          recordDate.year, recordDate.month, recordDate.day, tempClockIn.hour, tempClockIn.min, tempClockIn.sec);
      if (newClockInTime != widget.record.clockInTime) {
        recordBloc.add(ClockInTimeSubmitted(newClockInTime));
      }

      if (tempClockOut != null) {
        final newClockOutTime = DateTime(recordDate.year, recordDate.month, recordDate.day, tempClockOut!.hour,
            tempClockOut!.min, tempClockOut!.sec);
        if (newClockOutTime != widget.record.clockOutTime) {
          recordBloc.add(ClockOutTimeSubmitted(newClockOutTime));
        }
      }

      if (tempLeaveHours != (widget.record.leaveDuration ?? 0.0)) {
        recordBloc.add(LeaveDurationSubmitted(tempLeaveHours));
      }
    }
  }

  // ✨ 建立編輯對話框中每一行的方法
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

  @override
  void initState() {
    super.initState();
    // ✨ 關鍵修正 1：在 initState 中呼叫，確保 Widget 第一次建立時就有初始值
    _resetLocalStateToRecord();
  }

  @override
  void didUpdateWidget(covariant HistoryDetailCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.record.id != oldWidget.record.id) {
      _resetLocalStateToRecord();
      // 切換日期時，自動回到檢視模式
      _isEditing = false;
    }
  }

  void _resetLocalStateToRecord() {
    final record = widget.record;
    _pickedClockIn = (hour: record.clockInTime.hour, min: record.clockInTime.minute, sec: record.clockInTime.second);
    _pickedClockOut = record.clockOutTime != null
        ? (hour: record.clockOutTime!.hour, min: record.clockOutTime!.minute, sec: record.clockOutTime!.second)
        : null;
    _pickedLeaveHours = record.leaveDuration ?? 0.0;
  }

  void _submitChanges() {
    final recordBloc = context.read<RecordBloc>();
    final recordDate = widget.record.clockInTime;

    // 組裝新的 DateTime 物件
    final newClockInTime = DateTime(
        recordDate.year, recordDate.month, recordDate.day, _pickedClockIn.hour, _pickedClockIn.min, _pickedClockIn.sec);
    // 只有在時間真的改變時才發送事件，減少不必要的 BLoC 活動
    if (newClockInTime != widget.record.clockInTime) {
      recordBloc.add(ClockInTimeSubmitted(newClockInTime));
    }

    if (_pickedClockOut != null) {
      final newClockOutTime = DateTime(recordDate.year, recordDate.month, recordDate.day, _pickedClockOut!.hour,
          _pickedClockOut!.min, _pickedClockOut!.sec);
      if (newClockOutTime != widget.record.clockOutTime) {
        recordBloc.add(ClockOutTimeSubmitted(newClockOutTime));
      }
    }

    if (_pickedLeaveHours != (widget.record.leaveDuration ?? 0.0)) {
      recordBloc.add(LeaveDurationSubmitted(_pickedLeaveHours));
    }

    // 提交後切換回檢視模式
    setState(() {
      _isEditing = false;
    });
  }

  // ✨ 2. 顯示確認對話框的方法
  Future<void> _showDeleteConfirmationDialog() async {
    final recordBloc = context.read<RecordBloc>();

    final confirmed = await showAdaptiveDialog<bool>(
      context: context,
      builder: (ctx) {
        return Material(
          type: MaterialType.transparency, // 類型設為透明，避免產生背景色
          child: Theme(
            data: Theme.of(context).copyWith(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
            ),
            child: AlertDialog.adaptive(
              title: const Text("確認刪除"),
              content: const Text("您確定要刪除這筆打卡紀錄嗎？此操作無法復原。"),
              actions: _buildDialogActions(ctx, isDelete: false),
            ),
          ),
        );
      },
    );

    if (confirmed == true) {
      // ✨ 3. 向 RecordBloc 發送刪除事件，並附上這筆紀錄的 ID
      recordBloc.add(RecordDeleted(widget.record.id));
    }
  }

  // 根據平台建立不同的對話框按鈕
  List<Widget> _buildDialogActions(BuildContext context, {required bool isDelete}) {
    final platform = Theme.of(context).platform;
    if (platform == TargetPlatform.iOS || platform == TargetPlatform.macOS) {
      return [
        CupertinoDialogAction(
          child: const Text("取消"),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        CupertinoDialogAction(
          isDestructiveAction: true,
          child: const Text("更新"),
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ];
    } else {
      return [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text("取消"),
        ),
        FilledButton.tonal(
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.errorContainer,
            foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
          ),
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text("更新"),
        ),
      ];
    }
  }

  // 輔助 Widget，用來建立每一行的詳情
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600)),
          Text(value, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }

  @override
  @override
  Widget build(BuildContext context) {
    // ✨ 卡片本身現在只負責「顯示」和提供「觸發點」
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildDetailRow("日期:", DateFormat('yyyy/MM/dd E', 'zh_TW').format(widget.record.clockInTime)),
            _buildDetailRow("上班時間:", DateFormat('HH:mm:ss').format(widget.record.clockInTime)),
            _buildDetailRow(
                "下班時間:",
                widget.record.clockOutTime != null
                    ? DateFormat('HH:mm:ss').format(widget.record.clockOutTime!)
                    : '---'),
            _buildDetailRow("請假時數:", "${(widget.record.leaveDuration?.toInt()) ?? 0} 小時"),
            const Divider(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.delete_outline, color: Theme.of(context).colorScheme.error),
                  onPressed: _showDeleteConfirmationDialog,
                ),
                // ✨ 編輯按鈕現在會呼叫我們全新的對話框方法
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: _showEditDialog,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ✨ 檢視模式的 UI
  Widget _buildReadOnlyView() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("打卡詳情", style: Theme.of(context).textTheme.titleLarge),
              TextButton(
                onPressed: () => setState(() => _isEditing = true),
                child: const Text("編輯"),
              ),
            ],
          ),
          const Divider(height: 20),
          _buildDetailRow("日期:", DateFormat('yyyy/MM/dd E', 'zh_TW').format(widget.record.clockInTime)),
          _buildDetailRow("上班時間:", DateFormat('HH:mm:ss').format(widget.record.clockInTime)),
          _buildDetailRow("下班時間:",
              widget.record.clockOutTime != null ? DateFormat('HH:mm:ss').format(widget.record.clockOutTime!) : '---'),
          _buildDetailRow("請假時數:", "${(widget.record.leaveDuration?.toInt()) ?? 0} 小時"),
          const SizedBox(height: 8),
          // 您也可以在這裡加入一個顯示「當日工時統計」的小元件
        ],
      ),
    );
  }

  // ✨ 編輯模式的 UI
  // Widget _buildEditingView() {
  //   return Padding(
  //     padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
  //     child: SingleChildScrollView(
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           _buildEditSectionHeader("上班時間"),
  //           Center(child: TimeWheel(userReocrd: _pickedClockIn, onSetter: (v) => _pickedClockIn = v)),
  //           const Divider(height: 24),

  //           _buildEditSectionHeader("下班時間"),
  //           Center(child: TimeWheel(userReocrd: _pickedClockOut, onSetter: (v) => _pickedClockOut = v)),
  //           const Divider(height: 24),

  //           _buildEditSectionHeader("請假時數"),
  //           Row(
  //             children: [
  //               Expanded(
  //                 child: DropdownButtonHideUnderline(
  //                   child: DropdownButton2<double>(
  //                     value: _pickedLeaveHours,
  //                     items: List.generate(9, (i) => i.toDouble())
  //                         .map((h) => DropdownMenuItem(value: h, child: Text(h == 0 ? "未請假" : "${h.toInt()} 小時")))
  //                         .toList(),
  //                     onChanged: (v) => setState(() => _pickedLeaveHours = v ?? 0.0),
  //                   ),
  //                 ),
  //               ),
  //               // const Text("整天"),
  //               // Switch.adaptive(
  //               //   value: _pickedLeaveHours == 8.0,
  //               //   onChanged: (v) => setState(() => _pickedLeaveHours = v ? 8.0 : 0.0),
  //               // ),
  //             ],
  //           ),
  //           const SizedBox(height: 16),
  //           // ✨ 編輯模式的操作按鈕
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.end,
  //             children: [
  //               IconButton(
  //                   icon: Icon(Icons.delete_outline, color: Theme.of(context).colorScheme.error),
  //                   onPressed: _showDeleteConfirmationDialog),
  //               const Spacer(),
  //               TextButton(
  //                   onPressed: () => setState(() {
  //                         _isEditing = false;
  //                         _resetLocalStateToRecord();
  //                       }),
  //                   child: const Text("取消")),
  //               const SizedBox(width: 8),
  //               FilledButton(onPressed: _submitChanges, child: const Text("儲存變更")),
  //             ],
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // 輔助函式
  Widget _buildEditSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(title, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}
