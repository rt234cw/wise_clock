// lib/views/main_record_view/leave_card.dart

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_clock/bloc/bloc_barrel.dart';
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
    final bloc = context.read<DashboardBloc>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog.adaptive(
        title: const Text("確認操作"),
        content: const Text("登記整天請假將會覆蓋您原有的上下班打卡紀錄，且此操作無法復原。您確定要繼續嗎？"),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text("取消")),
          FilledButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text("確定")),
        ],
      ),
    );

    if (confirmed == true && _selectedHours != null) {
      bloc.add(LeaveDurationSubmitted(_selectedHours!));
      setState(() {
        _isEditing = false;
      }); // 提交後自動切換到檢視模式
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DashboardBloc, DashboardState>(
      listenWhen: (prev, curr) => prev.todayRecord?.leaveDuration != curr.todayRecord?.leaveDuration,
      listener: (context, state) {
        // 當 BLoC 的狀態更新時，同步本地的暫存值，確保顯示正確
        setState(() {
          _selectedHours = state.todayRecord?.leaveDuration ?? 0.0;
        });
      },
      builder: (context, state) {
        final todayRecord = state.todayRecord;
        final double savedHours = todayRecord?.leaveDuration ?? 0.0;

        // ✨ 核心邏輯：決定是否顯示編輯畫面
        // 1. 如果今天還沒有任何紀錄 (todayRecord == null)，則直接進入編輯模式。
        // 2. 如果已有紀錄，則根據 _isEditing 旗標來決定。
        final bool showEditView = (todayRecord == null) || _isEditing;

        // 初始化或同步 UI 上的暫存值
        _selectedHours ??= savedHours;

        return SharedContainer(
          child: showEditView ? _buildEditingView(context, savedHours) : _buildReadOnlyView(context, savedHours),
        );
      },
    );
  }

  // ✨ 檢視模式的 UI (請假完成後顯示)
  Widget _buildReadOnlyView(BuildContext context, double savedHours) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("請假/公出時數", style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              savedHours == 0 ? "未請假" : "${savedHours.toInt()} 小時",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        // ✨ 按下「調整」按鈕，進入編輯模式
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

  // ✨ 編輯模式的 UI (一開始或按下「調整」後顯示)
  Widget _buildEditingView(BuildContext context, double savedHours) {
    final bloc = context.read<DashboardBloc>();
    final todayRecord = bloc.state.todayRecord;
    final bool isDayStarted = todayRecord != null;
    final bool isButtonEnabled = _selectedHours != savedHours;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text("請假", style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: DropdownButtonHideUnderline(
                child: DropdownButton2<double>(
                  value: _selectedHours,
                  hint: Text("請先打卡以選擇時數", style: TextStyle(fontSize: 14, color: Theme.of(context).hintColor)),
                  items: List.generate(9, (i) => i.toDouble())
                      .map((h) => DropdownMenuItem(value: h, child: Text(h == 0 ? "未請假" : "${h.toInt()} 小時")))
                      .toList(),
                  // ✨ 只有在已有打卡紀錄時，才可選擇部分時數
                  onChanged: isDayStarted ? (v) => setState(() => _selectedHours = v) : null,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text("整天"),
            Transform.scale(
              scale: 1.5,
              child: Checkbox.adaptive(
                value: _selectedHours == 8.0,
                onChanged: (v) => setState(() {
                  _selectedHours = v == true ? 8.0 : 0.0;
                }),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // ✨ 如果是從「調整」按鈕進來的，才顯示「取消」按鈕
            if (isDayStarted)
              TextButton(
                  onPressed: () => setState(() {
                        _isEditing = false;
                        _selectedHours = null;
                      }),
                  child: const Text("取消")),
            const SizedBox(width: 8),
            FilledButton(
              onPressed: isButtonEnabled
                  ? () {
                      if (_selectedHours == 8.0 && todayRecord?.clockOutTime != null) {
                        _showConfirmationDialog();
                      } else {
                        bloc.add(LeaveDurationSubmitted(_selectedHours!));
                        // 如果是無紀錄狀態下請假，提交後自動切換到檢視模式
                        if (!isDayStarted) {
                          setState(() {
                            _isEditing = false;
                          });
                        }
                      }
                    }
                  : null,
              child: const Text("請假"),
            ),
          ],
        ),
      ],
    );
  }
}
