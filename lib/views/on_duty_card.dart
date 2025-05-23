import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:wise_clock/clock_records_bloc.dart';

import '../color_scheme/color_code.dart';
import '../models/clock_records_event.dart';
import '../models/clock_records_state.dart';

/// ──────────────────────────────────────────────────────────────
///  DutyCard：可展開/折疊的上班打卡區塊
/// ──────────────────────────────────────────────────────────────
class OnDutyCard extends StatefulWidget {
  const OnDutyCard({super.key});

  @override
  State<OnDutyCard> createState() => _OnDutyCardState();
}

class _OnDutyCardState extends State<OnDutyCard> {
  Timer? _longPressTimer;
  // 3 個 TextEditingController
  late final TextEditingController hCtl;
  late final TextEditingController mCtl;
  late final TextEditingController sCtl;

  DateTime _selected = DateTime.now();

  @override
  void initState() {
    super.initState();
    hCtl = TextEditingController(text: _two(_selected.hour));
    mCtl = TextEditingController(text: _two(_selected.minute));
    sCtl = TextEditingController(text: _two(_selected.second));
  }

  @override
  void dispose() {
    hCtl.dispose();
    mCtl.dispose();
    sCtl.dispose();
    super.dispose();
  }

  String _two(int v) => v.toString().padLeft(2, '0');

  void _updateSelected({int? h, int? m, int? s}) {
    _selected = DateTime(
      _selected.year,
      _selected.month,
      _selected.day,
      h ?? _selected.hour,
      m ?? _selected.minute,
      s ?? _selected.second,
    );
    context.read<ClockRecordsBloc>().add(ClockInEditStarted()); // 供外層知道在編輯
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClockRecordsBloc, ClockRecordsState>(
      buildWhen: (p, n) => p.currentLog != n.currentLog || p.isEditingClockIn != n.isEditingClockIn,
      builder: (context, state) {
        final log = state.currentLog;
        final hasClockedIn = log?.clockIn != null;

        // 第一次進來或尚未打卡
        final isFirstTime = !hasClockedIn;
        print('isFirstTime: $isFirstTime');

        // 只要 state.isEditingClockIn = true，就進入編輯模式
        final isEditing = state.isEditingClockIn || isFirstTime;

        // 若不是編輯又已經有 clockIn，更新 _selected
        if (hasClockedIn && !isEditing) _selected = log!.clockIn!;

        // final estimatedOff = _selected.add(const Duration(hours: 9));

        return AnimatedCrossFade(
          firstChild: hasClockedIn // <- 先確定有資料才 build
              ? _collapsedView(log!.clockIn!)
              : const SizedBox.shrink(),
          secondChild: _expandedView(isFirstTime), // <- 傳正確旗標
          crossFadeState: isEditing ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 300),
          sizeCurve: Curves.easeInOut,
        );
      },
    );
  }

  /// ───────── 折疊：只顯示時間 +《調整》─────────
  Widget _collapsedView(DateTime clockIn) {
    final fmt = DateFormat.Hms(); // 24 hr: 14:30:05
    return _cardWrapper(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 左側：標籤 + 時間
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "上班時間",
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Colors.grey,
                    ),
              ),
              Text(fmt.format(clockIn), style: Theme.of(context).textTheme.titleLarge),
            ],
          ),

          // 右側：調整按鈕
          TextButton(
            onPressed: () => context.read<ClockRecordsBloc>().add(ClockInEditStarted()),
            child: const Text("調整"),
          ),
        ],
      ),
    );
  }

  /// ───────── 展開：三個 spinner +《打卡 / 取消》─────────
  Widget _expandedView(bool isFirstTime) {
    return _cardWrapper(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("上班時間", style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Row(
            children: [
              _timeSpinner(
                controller: hCtl,
                onAdd: () => _changeHour(1),
                onRemove: () => _changeHour(-1),
              ),
              _timeSpinner(
                controller: mCtl,
                onAdd: () => _changeMinute(1),
                onRemove: () => _changeMinute(-1),
              ),
              _timeSpinner(
                controller: sCtl,
                onAdd: () => _changeSecond(1),
                onRemove: () => _changeSecond(-1),
              ),
              const Spacer(),
              Column(
                children: [
                  if (isFirstTime) ...[
                    ElevatedButton(
                      onPressed: () {
                        context.read<ClockRecordsBloc>().add(ClockInPressed(DateTime.now()));
                      },
                      child: const Text("快速打卡"),
                    ),
                    const SizedBox(height: 8),
                  ],
                  // 只有編輯舊資料才顯示取消

                  Row(
                    children: [
                      if (!isFirstTime) ...[
                        TextButton(
                          onPressed: () => context.read<ClockRecordsBloc>().add(ClockInEditCanceled()),
                          child: const Text("取消"),
                        ),
                        const SizedBox(width: 8),
                      ],
                      FilledButton(
                        onPressed: () {
                          final bloc = context.read<ClockRecordsBloc>();
                          bloc.add(isFirstTime ? ClockInPressed(_selected) : ClockInEdited(_selected));
                        },
                        child: const Text("打卡"),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ───────── Utils ───────────────────────────
  Widget _cardWrapper(Widget child) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  // three small spinner buttons
  Widget _timeSpinner({
    required TextEditingController controller,
    required VoidCallback onAdd,
    required VoidCallback onRemove,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 50,
          child: TextField(
            textAlign: TextAlign.center,
            controller: controller,
            readOnly: true,
            style: const TextStyle(
              fontSize: 24,
              color: ColorCode.primaryColor,
              fontWeight: FontWeight.w600,
            ),
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              isDense: true,
              border: InputBorder.none,
              filled: false,
            ),
          ),
        ),
        const SizedBox(height: 8),
        _spinBtn(Icons.add, onAdd),
        const SizedBox(height: 4),
        _spinBtn(Icons.remove, onRemove),
      ],
    );
  }

  Widget _spinBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      onLongPressStart: (_) => _startHold(onTap),
      onLongPressEnd: (_) => _stopHold(),
      child: Icon(icon, size: 18, color: const Color.fromARGB(255, 197, 210, 243)),
    );
  }

  // update helpers
  void _changeHour(int delta) {
    final h = (int.parse(hCtl.text) + delta) % 24;
    hCtl.text = _two(h < 0 ? h + 24 : h);
    _updateSelected(h: int.parse(hCtl.text));
  }

  void _changeMinute(int delta) {
    final m = (int.parse(mCtl.text) + delta) % 60;
    mCtl.text = _two(m < 0 ? m + 60 : m);
    _updateSelected(m: int.parse(mCtl.text));
  }

  void _changeSecond(int delta) {
    final s = (int.parse(sCtl.text) + delta) % 60;
    sCtl.text = _two(s < 0 ? s + 60 : s);
    _updateSelected(s: int.parse(sCtl.text));
  }

  void _startHold(Function callback) {
    callback(); // 先執行一次
    _longPressTimer?.cancel();
    _longPressTimer = Timer.periodic(const Duration(milliseconds: 120), (_) {
      callback();
    });
  }

  void _stopHold() {
    _longPressTimer?.cancel();
    _longPressTimer = null;
  }
}
