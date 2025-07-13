// lib/views/history_view/history_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:wise_clock/bloc/history_bloc.dart';
import 'package:wise_clock/bloc/history_event.dart';
import 'package:wise_clock/bloc/history_state.dart';
import 'package:wise_clock/hive/clock_record.dart';
import 'package:wise_clock/model/dashboard_repository.dart';
import 'package:wise_clock/views/history_view/history_detail_card.dart';

class HistoryView extends StatelessWidget {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    // ✨ 在頂層提供 HistoryBloc
    return BlocProvider(
      create: (context) => HistoryBloc(context.read<DashboardRepository>())
        // ✨ 在創建後立刻觸發一次讀取當前月份資料的事件
        ..add(MonthChanged(DateTime.now())),
      child: BlocBuilder<HistoryBloc, HistoryState>(
        builder: (context, state) {
          if (state.status == HistoryStatus.initial) {
            context.read<HistoryBloc>().add(MonthChanged(DateTime.now()));
          }
          return Column(
            children: [
              _CalendarHeader(state: state),
              _buildCalendar(context, state),
              const SizedBox(height: 8.0),
              const Divider(height: 1, thickness: 1),
              Expanded(child: _buildRecordDetails(context, state.selectedDayRecord)),
            ],
          );
        },
      ),
    );
  }

  // 建立日曆的 Widget
  Widget _buildCalendar(BuildContext context, HistoryState state) {
    final bloc = context.read<HistoryBloc>();
    final now = DateTime.now();

    return TableCalendar<ClockRecord>(
      locale: 'zh_TW',
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: now,
      focusedDay: state.focusedMonth,
      sixWeekMonthsEnforced: true,
      daysOfWeekHeight: 32,
      rowHeight: 48,
      headerVisible: false,
      calendarStyle: CalendarStyle(
        // ✨ 1. 設定選中日期的背景樣式
        selectedDecoration: BoxDecoration(
          color: Theme.of(context).primaryColor, // 使用 App 的主題色
          shape: BoxShape.circle,
        ),
        // ✨ 2. 設定選中日期的文字樣式
        selectedTextStyle: const TextStyle(color: Colors.white),

        // (可選) 您也可以設定今天日期的樣式
        todayDecoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withValues(alpha: .5),
          shape: BoxShape.rectangle,
        ),
        todayTextStyle: const TextStyle(color: Colors.white),
      ),
      headerStyle: HeaderStyle(
        formatButtonVisible: false, // 隱藏「兩週/月份」切換按鈕
        titleCentered: true,
        rightChevronVisible: !(state.focusedMonth.year == now.year && state.focusedMonth.month == now.month),
      ),
      selectedDayPredicate: (day) => isSameDay(state.selectedDay, day),
      onDaySelected: (selectedDay, focusedDay) {
        // 當使用者點擊日期時，發送 DaySelected 事件
        bloc.add(DaySelected(selectedDay));
      },
      onPageChanged: (focusedDay) {
        // 雖然 lastDay 和 headerStyle 已經做了限制，
        // 但這是一個額外的保險，防止用戶透過某些方式滑動到未來
        if (focusedDay.isAfter(now)) {
          return;
        }
        // 當使用者滑動月份時，發送 MonthChanged 事件
        bloc.add(MonthChanged(focusedDay));
      },
      eventLoader: (day) {
        return state.recordsForMonth.where((record) => isSameDay(record.clockInTime, day)).toList();
      },
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, date, events) {
          if (events.isNotEmpty) {
            return Positioned(
              right: 1,
              bottom: 1,
              child: Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            );
          }
          return null;
        },
      ),
    );
  }

  // ✨ 建立顯示打卡紀錄詳情的 Widget (修正後)
  Widget _buildRecordDetails(BuildContext context, ClockRecord? record) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      // ✨ 為了更平滑的切換效果，我們可以自訂 transitionBuilder
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      child: record == null
          // ✨ 關鍵修正：使用 Container 替代 Center
          ? Container(
              // ✨ 使用 ValueKey 來幫助 AnimatedSwitcher 識別不同的 Widget
              key: const ValueKey('empty-placeholder'),
              // ✨ 明確地讓 Container 填滿所有可用空間
              width: double.infinity,
              height: double.infinity,
              // ✨ 並將其子元件（Text）置中
              alignment: Alignment.center,
              child: const Text("請選擇有紀錄的日期"),
            )
          : SingleChildScrollView(
              child: HistoryDetailCard(
                key: ValueKey(record.id),
                record: record,
              ),
            ),
    );
  }
}

// 輔助函數
bool isSameDay(DateTime? a, DateTime? b) {
  if (a == null || b == null) {
    return false;
  }
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

class _CalendarHeader extends StatelessWidget {
  final HistoryState state;
  const _CalendarHeader({required this.state});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<HistoryBloc>();
    final headerText = DateFormat.yMMM('zh_TW').format(state.focusedMonth);
    final now = DateTime.now();

    // ✨ 關鍵修正：將判斷邏輯分開
    // 規則 1：是否正在瀏覽當前月份？
    final bool isViewingCurrentMonth = state.focusedMonth.year == now.year && state.focusedMonth.month == now.month;

    // 規則 2：是否顯示「回到今天」按鈕？(只要不在當前月份就顯示)
    final bool showTodayButton = !isViewingCurrentMonth;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: [
          // 月份標題
          Text(
            headerText,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const Spacer(),

          // ✨ 「回到今天」按鈕，根據 showTodayButton 決定是否顯示
          if (showTodayButton)
            TextButton(
              onPressed: () {
                bloc.add(DaySelected(DateTime.now()));
              },
              child: const Text("今天"),
            ),

          // 上一個月按鈕
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () {
              final prevMonth = DateTime(state.focusedMonth.year, state.focusedMonth.month - 1);
              bloc.add(MonthChanged(prevMonth));
            },
          ),

          // ✨ 下一個月按鈕，根據 isViewingCurrentMonth 決定是否禁用
          IconButton(
            icon: Icon(
              Icons.chevron_right,
              color: isViewingCurrentMonth ? Colors.grey : Colors.black,
            ),
            onPressed: isViewingCurrentMonth
                ? null // 如果是當前月份，就禁用按鈕
                : () {
                    final nextMonth = DateTime(state.focusedMonth.year, state.focusedMonth.month + 1);
                    bloc.add(MonthChanged(nextMonth));
                  },
          ),
        ],
      ),
    );
  }
}
