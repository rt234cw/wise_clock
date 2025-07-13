// lib/views/main_record_view/leave_card.dart

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_clock/bloc/clock_record_state.dart';
import 'package:wise_clock/bloc/record_bloc.dart';
import 'package:wise_clock/bloc/record_event.dart';
import 'package:wise_clock/bloc/dashboard_bloc.dart';
import 'package:wise_clock/bloc/record_state.dart';

import 'package:wise_clock/views/share_ui_components/shared_container.dart';

class LeaveCard extends StatefulWidget {
  const LeaveCard({super.key});

  @override
  State<LeaveCard> createState() => _LeaveCardState();
}

class _LeaveCardState extends State<LeaveCard> {
  // UI 狀態 1: 使用者在 UI 上的「暫存」選擇
  double? _selectedHours;
  // UI 狀態 2: 控制卡片是處於「編輯模式」還是「檢視模式」
  bool _isEditing = false;

  // 確認對話框的方法
  Future<void> _showConfirmationDialog() async {
    final recordBloc = context.read<RecordBloc>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        // 使用 Theme 來包裹，確保在 iOS 上有原生的點擊效果
        return Theme(
          data: Theme.of(context).copyWith(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
          ),
          child: AlertDialog.adaptive(
            title: const Text("確認操作"),
            content: const Text("登記整天請假將會覆蓋您原有的上下班打卡紀錄，且此操作無法復原。您確定要繼續嗎？"),
            actions: _buildDialogActions(ctx),
          ),
        );
      },
    );

    if (confirmed == true && _selectedHours != null) {
      recordBloc.add(LeaveDurationSubmitted(_selectedHours!));
      setState(() {
        _isEditing = false;
      }); // 提交後自動切換到檢視模式
    }
  }

  // 根據平台建立不同的對話框按鈕
  List<Widget> _buildDialogActions(BuildContext context) {
    final platform = Theme.of(context).platform;
    if (platform == TargetPlatform.iOS || platform == TargetPlatform.macOS) {
      return [
        CupertinoDialogAction(
          isDestructiveAction: true,
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text("取消"),
        ),
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text("確定"),
        ),
      ];
    } else {
      return [
        TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text("取消")),
        FilledButton(onPressed: () => Navigator.of(context).pop(true), child: const Text("確定")),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RecordBloc, RecordState>(
      // 監聽 RecordBloc 的提交狀態
      listener: (context, state) {
        // 當提交成功後，重置本地的編輯狀態
        if (state.submissionStatus.isSuccessful) {
          setState(() {
            _isEditing = false;
            _selectedHours = null; // 重置選擇，讓 UI 在下次 build 時能從 BLoC 獲取最新值
          });
        }
        // 您也可以在這裡處理 submissionStatus.isError 的情況，例如顯示一個錯誤 SnackBar
      },
      child: BlocBuilder<DashboardBloc, DashboardState>(
        buildWhen: (prev, curr) => prev.todayRecord != curr.todayRecord,
        builder: (context, state) {
          final todayRecord = state.todayRecord;
          final double savedHours = todayRecord?.leaveDuration ?? 0.0;

          // ✨ 核心邏輯：決定是否顯示編輯畫面
          final bool showEditView = (todayRecord == null) || _isEditing;

          // 初始化或同步 UI 上的暫存值
          _selectedHours ??= savedHours;

          return SharedContainer(
            child: showEditView ? _buildEditingView(context, savedHours) : _buildReadOnlyView(context, savedHours),
          );
        },
      ),
    );
  }

  // ✨ 檢視模式的 UI (請假完成後或初始有紀錄時顯示)
  Widget _buildReadOnlyView(BuildContext context, double savedHours) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("請假時數", style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              savedHours == 0 ? "未請假" : "${savedHours.toInt()} 小時",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        TextButton(
          onPressed: () {
            setState(() {
              _isEditing = true;
            });
          },
          child: const Text("調整"),
        ),
      ],
    );
  }

  // ✨ 編輯模式的 UI (一開始無紀錄，或按下「調整」後顯示)
  Widget _buildEditingView(BuildContext context, double savedHours) {
    final recordBloc = context.read<RecordBloc>();
    final todayRecord = context.read<DashboardBloc>().state.todayRecord;
    final bool isDayStarted = todayRecord != null;
    final bool isButtonEnabled = _selectedHours != savedHours;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text("請假時數", style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            DropdownButtonHideUnderline(
              child: DropdownButton2<double>(
                isExpanded: true,
                value: _selectedHours,
                buttonStyleData: ButtonStyleData(
                  width: 120,
                  height: 40,
                  // width: 180,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Theme.of(context).cardColor,
                    border: Border.all(color: Theme.of(context).dividerColor),
                  ),
                ),
                dropdownStyleData: DropdownStyleData(
                  maxHeight: 200,
                  padding: EdgeInsets.zero,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Theme.of(context).cardColor,
                  ),
                ),
                items: List.generate(9, (i) => i.toDouble())
                    .map((h) => DropdownMenuItem(value: h, child: Text(h == 0 ? "未請假" : "${h.toInt()} 小時")))
                    .toList(),
                onChanged: isDayStarted ? (v) => setState(() => _selectedHours = v) : null,
              ),
            ),
            const SizedBox(width: 8),
            Row(
              children: [
                const Text("整天"),
                Switch.adaptive(
                  value: _selectedHours == 8.0,
                  onChanged: (v) => setState(() => _selectedHours = v == true ? 8.0 : 0.0),
                ),
                const SizedBox(width: 16),
                Column(
                  children: [
                    // ✨ 如果是從「調整」按鈕進來的，才顯示「取消」按鈕
                    if (isDayStarted)
                      TextButton(
                          onPressed: () => setState(() {
                                _isEditing = false;
                                _selectedHours = null; // 取消時重置選擇
                              }),
                          child: const Text("取消")),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: isButtonEnabled
                          ? () {
                              if (_selectedHours == 8.0 && todayRecord?.clockOutTime != null) {
                                _showConfirmationDialog();
                              } else {
                                recordBloc.add(LeaveDurationSubmitted(_selectedHours!));
                                // 提交後，讓 BlocListener 來處理狀態重置，這裡不再需要 setState
                              }
                            }
                          : null,
                      child: const Text("登記"),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
