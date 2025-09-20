import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:wise_clock/features/history/bloc/history_bloc.dart';
import 'package:wise_clock/features/history/bloc/history_event.dart';
import 'package:wise_clock/features/history/bloc/history_state.dart';
import 'package:wise_clock/core/data/models/clock_record.dart';
import 'package:wise_clock/core/data/repository/dashboard_repository.dart';
import 'package:wise_clock/features/history/presentation/widget/history_detail_card.dart';

import '../../../../generated/l10n.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../core/providers/settings_provider.dart';
import '../../../../shared/widgets/edit_record_dialog.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  bool showWeekdays = true;
  @override
  Widget build(BuildContext context) {
    // 在頂層提供 HistoryBloc
    return BlocProvider(
      create: (context) => HistoryBloc(context.read<DashboardRepository>())
        // 在創建後立刻觸發一次讀取當前月份資料的事件
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
              const SizedBox(height: 4.0),
              const Divider(height: 1, thickness: 1),
              Expanded(child: _buildRecordDetails(context, state)),
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
    final settingProivder = context.watch<SettingsProvider>();
    final bool showWeekdays = !settingProivder.showWeekend;
    final bool sixWeekMonthsEnforced = settingProivder.showSixWeeks;
    final colorScheme = Theme.of(context).colorScheme;

    return TableCalendar<ClockRecord>(
      startingDayOfWeek: StartingDayOfWeek.monday,
      locale: context.read<LocaleProvider>().locale?.languageCode ?? 'en',
      firstDay: DateTime.utc(2025, 1, 1),
      lastDay: now,
      onlyWeekdays: showWeekdays,
      focusedDay: state.focusedMonth,
      sixWeekMonthsEnforced: sixWeekMonthsEnforced,
      daysOfWeekHeight: 32,
      rowHeight: 44,
      headerVisible: false,
      // enabledDayPredicate: (day) => !day.isAfter(now),
      calendarStyle: CalendarStyle(
        disabledTextStyle: TextStyle(
          color: colorScheme.primary.withValues(alpha: 0.1),
        ),
        defaultTextStyle: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.8)),
        outsideTextStyle: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.4)),
        weekendTextStyle: TextStyle(color: colorScheme.secondary.withValues(alpha: 0.9)),
        //  設定選中日期的背景樣式
        selectedDecoration: BoxDecoration(
          color: colorScheme.primary, // 使用 App 的主題色
          shape: BoxShape.circle,
        ),
        //  設定選中日期的文字樣式
        selectedTextStyle: TextStyle(
          color: colorScheme.onPrimary, // Text color on top of the brand color
          fontWeight: FontWeight.bold,
        ),
        todayDecoration: BoxDecoration(
          border: BoxBorder.all(color: colorScheme.tertiary, width: 1.5),
          shape: BoxShape.circle,
        ),
        todayTextStyle: TextStyle(
          color: colorScheme.secondary, // Use accent color for 'today' text
          // fontWeight: FontWeight.bold,
        ),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        // Style for the weekday labels (Mon, Tue, etc.)
        weekdayStyle: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.6)),
        weekendStyle: TextStyle(color: colorScheme.secondary.withValues(alpha: 0.8)),
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
              // right: 1,
              bottom: 2,
              child: Container(
                width: 16,
                height: 3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  // shape: BoxShape.circle,
                  color: colorScheme.secondary,
                ),
              ),
            );
          }
          return null;
        },
      ),
    );
  }

  Widget _buildRecordDetails(BuildContext context, HistoryState state) {
    final record = state.selectedDayRecord;
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      child: record == null
          ? Container(
              // 使用 ValueKey 來幫助 AnimatedSwitcher 識別不同的 Widget
              key: const ValueKey('empty-placeholder'),

              width: double.infinity,
              height: double.infinity,

              alignment: Alignment.center,
              child: state.selectedDay == null
                  ? Text(
                      S.current.selectDateToViewRecords,
                      style: TextStyle(
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 8,
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          S.current.noRecordForThisDay,
                        ),
                        OutlinedButton.icon(
                          onPressed: state.selectedDay == null
                              ? null // 如果連日期都沒選，就禁用按鈕

                              : () => showEditRecordDialog(
                                    context: context,
                                    selectedDate: state.selectedDay!,
                                    existingRecord: null,
                                  ),
                          icon: Icon(Icons.add),
                          label: Text(S.current.addNewRecord),
                          style: OutlinedButton.styleFrom(),
                        ),
                      ],
                    ),
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
    final locale = Localizations.localeOf(context).toString();
    final headerText = DateFormat.yMMM(locale).format(state.focusedMonth);
    final now = DateTime.now();
    final colorScheme = Theme.of(context).colorScheme;

    // 是否正在瀏覽當前月份？
    final bool isViewingCurrentMonth = state.focusedMonth.year == now.year && state.focusedMonth.month == now.month;

    // 是否顯示「回到今天」按鈕？(只要不在當前月份就顯示)
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

          if (showTodayButton)
            TextButton(
              onPressed: () {
                bloc.add(DaySelected(DateTime.now()));
              },
              child: Text(S.current.today),
            ),

          // 上一個月按鈕
          IconButton(
            icon: Icon(
              Icons.chevron_left,
              color: colorScheme.onSurface.withValues(alpha: .8),
            ),
            onPressed: () {
              final prevMonth = DateTime(state.focusedMonth.year, state.focusedMonth.month - 1);
              bloc.add(MonthChanged(prevMonth));
            },
          ),

          IconButton(
            icon: Icon(
              Icons.chevron_right,
              color: isViewingCurrentMonth
                  ? colorScheme.onSurface.withValues(alpha: .3)
                  : colorScheme.onSurface.withValues(alpha: .8),
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
