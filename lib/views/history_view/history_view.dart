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
    // ✨ 使用 BlocProvider 來創建和提供 HistoryBloc
    return BlocProvider(
      create: (context) => HistoryBloc(context.read<DashboardRepository>())
        // ✨ 在創建後立刻觸發一次讀取當前月份資料的事件
        ..add(MonthChanged(DateTime.now())),
      child: BlocBuilder<HistoryBloc, HistoryState>(
        builder: (context, state) {
          return Column(
            children: [
              _buildCalendar(context, state),
              const SizedBox(height: 16.0),
              const Divider(height: 1, thickness: 1),
              const SizedBox(height: 16.0),
              HistoryDetailCard(
                  detailInfo: state.selectedDayRecord == null
                      ? null
                      : [
                          {
                            "日期:": DateFormat('yyyy/MM/dd E', 'zh_TW').format(state.selectedDayRecord!.clockInTime),
                          },
                          {"上班時間:": state.selectedDayRecord!.clockInTime.format('HH:mm:ss')},
                          {"下班時間:": state.selectedDayRecord!.clockOutTime?.format('HH:mm:ss') ?? '尚未打卡'},
                          {"請假時數:": "${(state.selectedDayRecord!.leaveDuration?.toInt()) ?? 0} 小時"},
                        ]),
              // _buildRecordDetails(context, state.selectedDayRecord),
            ],
          );
        },
      ),
    );
  }

  // 建立日曆的 Widget
  Widget _buildCalendar(BuildContext context, HistoryState state) {
    final bloc = context.read<HistoryBloc>();

    return TableCalendar<ClockRecord>(
      locale: 'zh_TW',
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: state.focusedMonth,
      headerStyle: const HeaderStyle(
        formatButtonVisible: false, // 隱藏「兩週/月份」切換按鈕
        titleCentered: true,
      ),
      selectedDayPredicate: (day) => isSameDay(state.selectedDay, day),
      onDaySelected: (selectedDay, focusedDay) {
        // 當使用者點擊日期時，發送 DaySelected 事件
        bloc.add(DaySelected(selectedDay));
      },
      onPageChanged: (focusedDay) {
        // 當使用者滑動月份時，發送 MonthChanged 事件
        bloc.add(MonthChanged(focusedDay));
      },
      // ✨ eventLoader 會為每一天尋找對應的事件（打卡紀錄）
      eventLoader: (day) {
        return state.recordsForMonth.where((record) => isSameDay(record.clockInTime, day)).toList();
      },
      calendarBuilders: CalendarBuilders(
        // ✨ 當某天有事件（打卡紀錄）時，在其下方繪製一個小點
        markerBuilder: (context, date, events) {
          if (events.isNotEmpty) {
            return Positioned(
              right: 1,
              bottom: 1,
              child: Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.deepOrange,
                ),
              ),
            );
          }
          return null;
        },
      ),
    );
  }

  // 建立顯示打卡紀錄詳情的 Widget
  // Widget _buildRecordDetails(BuildContext context, ClockRecord? record) {
  //   if (record == null) {
  //     return const Expanded(
  //       child: Center(child: Text("請選擇有紀錄的日期來查看詳情")),
  //     );
  //   }

  //   return Expanded(
  //     child: ListView(
  //       physics: const BouncingScrollPhysics(),
  //       padding: const EdgeInsets.symmetric(horizontal: 16),
  //       children: [
  //         _buildDetailRow("日期:", DateFormat('yyyy/MM/dd E', 'zh_TW').format(record.clockInTime)),
  //         _buildDetailRow("上班時間:", record.clockInTime.format('HH:mm:ss')),
  //         _buildDetailRow("下班時間:", record.clockOutTime?.format('HH:mm:ss') ?? '尚未打卡'),
  //         _buildDetailRow("請假時數:", "${(record.leaveDuration?.toInt()) ?? 0} 小時"),
  //       ],
  //     ),
  //   );
  // }

  // 輔助 Widget，用於建立每一行的詳情
  // Widget _buildDetailRow(String label, String value) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 8.0),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
  //         Text(value),
  //       ],
  //     ),
  //   );
  // }
}

// 為了方便格式化，可以為 DateTime 寫一個擴展
extension DateTimeFormat on DateTime {
  String format(String pattern) {
    return DateFormat(pattern).format(this);
  }
}
