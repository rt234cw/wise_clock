// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// import 'record_list_item.dart';

// class HistoryView extends StatefulWidget {
//   const HistoryView({super.key});

//   @override
//   State<HistoryView> createState() => _HistoryViewState();
// }

// class _HistoryViewState extends State<HistoryView> {
//   final List<PunchRecord> _punchRecords = [
//     PunchRecord(
//       id: '1',
//       date: DateTime(2025, 5, 29),
//       checkInTime: '09:00',
//       checkOutTime: '18:00',
//       leaveTime: '0h',
//     ),
//     PunchRecord(
//       id: '2',
//       date: DateTime(2025, 5, 28),
//       checkInTime: '09:05',
//       checkOutTime: '17:55',
//       leaveTime: '0h',
//     ),
//     PunchRecord(
//       id: '3',
//       date: DateTime(2025, 5, 27),
//       checkInTime: '09:30',
//       checkOutTime: '18:30',
//       leaveTime: '4h', // 半天假
//     ),
//     PunchRecord(
//       id: '4',
//       date: DateTime(2025, 5, 26),
//       checkInTime: '09:00',
//       checkOutTime: '18:00',
//       leaveTime: '8h', // 一天假
//     ),
//     PunchRecord(
//       id: '5',
//       date: DateTime(2025, 5, 23),
//       checkInTime: '09:15',
//       checkOutTime: '18:00',
//       leaveTime: '0h',
//     ),
//   ];
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         CalendarDatePicker(
//           initialDate: DateTime.now(),
//           firstDate: DateTime.now().add(Duration(days: -365)),
//           lastDate: DateTime.now(),
//           onDateChanged: (value) {},
//         )
//         // Row(
//         //   children: [
//         //     Expanded(flex: 3, child: Text('日期', style: TextStyle(fontWeight: FontWeight.bold))),
//         //     Expanded(
//         //         flex: 2, child: Text('上班', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
//         //     Expanded(
//         //         flex: 2, child: Text('下班', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
//         //     Expanded(
//         //         flex: 2, child: Text('請假', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
//         //     Expanded(
//         //         flex: 2, child: Text('操作', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
//         //   ],
//         // ),
//         // const SizedBox(height: 4),
//         // const Divider(height: 1, thickness: 1),
//         // Expanded(
//         //     child: ListView.builder(
//         //   physics: ClampingScrollPhysics(),
//         //   itemCount: 5, // 假設有20條記錄
//         //   itemBuilder: (context, index) {
//         //     final record = _punchRecords[index];
//         //     return Card(
//         //       child: Row(
//         //         children: [
//         //           Expanded(
//         //             flex: 3,
//         //             child: Text(DateFormat('yyyy/MM/dd').format(record.date)),
//         //           ),
//         //           // 上班時間
//         //           Expanded(
//         //             flex: 2,
//         //             child: Text(record.checkInTime, textAlign: TextAlign.center),
//         //           ),
//         //           // 下班時間
//         //           Expanded(
//         //             flex: 2,
//         //             child: Text(record.checkOutTime, textAlign: TextAlign.center),
//         //           ),
//         //           // 請假時間
//         //           Expanded(
//         //             flex: 2,
//         //             child: Text(record.leaveTime, textAlign: TextAlign.center),
//         //           ),
//         //           // 操作按鈕 (編輯/刪除)
//         //           Expanded(
//         //             flex: 2,
//         //             child: Row(
//         //               mainAxisAlignment: MainAxisAlignment.spaceAround,
//         //               children: [
//         //                 GestureDetector(
//         //                   // 使用 GestureDetector for custom tap effects or small areas
//         //                   onTap: () {},
//         //                   child: const Icon(Icons.edit, size: 20),
//         //                 ),
//         //                 GestureDetector(
//         //                   onTap: () {},
//         //                   child: const Icon(Icons.delete, size: 20, color: Colors.red),
//         //                 ),
//         //               ],
//         //             ),
//         //           ),
//         //         ],
//         //       ),
//         //     );
//         //   },
//         // ))
//       ],
//     );
//   }
// }

// class PunchRecord {
//   final String id; // Unique ID for editing/deleting
//   final DateTime date;
//   final String checkInTime; // e.g., "09:00"
//   final String checkOutTime; // e.g., "18:00"
//   final String leaveTime; // e.g., "0h", "4h", "8h" (半天/一天)

//   PunchRecord({
//     required this.id,
//     required this.date,
//     required this.checkInTime,
//     required this.checkOutTime,
//     required this.leaveTime,
//   });
// }

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  CalendarFormat _calendarFormat = CalendarFormat.month; // 初始日曆格式為月視圖
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  PunchRecord? _selectedRecord; // 儲存當前選中日期的打卡記錄

  // --- 模擬數據 ---
  // Key: 標準化後的日期 (不含時分秒)，Value: 該日期的 PunchRecord 列表
  // 為了方便演示，我們直接在這裡定義數據
  late final Map<DateTime, List<PunchRecord>> _kEventSource;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _generateDummyData(); // 在 initState 中生成模擬數據
    _initializeSelectedRecord(); // 初始化時檢查今天是否有記錄
  }

  // 模擬生成一些打卡數據
  void _generateDummyData() {
    final now = DateTime.now();
    final formatter = DateFormat('yyyyMMdd');

    // 清空舊數據，確保每次運行都是新的模擬數據
    _kEventSource = {};

    // 今天的打卡記錄
    _addRecord(now, '今天完成了重要任務，感覺棒極了！✨', now.subtract(const Duration(hours: 2)));

    // 昨天的打卡記錄
    final yesterday = now.subtract(const Duration(days: 1));
    _addRecord(yesterday, '昨日工作順利，完成了報告，提前下班。😊', yesterday.subtract(const Duration(hours: 3)));

    // 前三天的打卡記錄
    final threeDaysAgo = now.subtract(const Duration(days: 3));
    _addRecord(threeDaysAgo, '這一天開了一整天的會，有些疲憊但收穫滿滿。💼', threeDaysAgo.add(const Duration(hours: 5)));

    // 下週一的打卡記錄 (模擬未來事件)
    final nextMonday = now.add(Duration(days: 7 - now.weekday + DateTime.monday));
    _addRecord(nextMonday, '預計下週一開始一個新的大型項目，期待中！🚀', nextMonday.add(const Duration(hours: 10)));

    // 隨機在當月和上個月添加一些記錄
    for (int i = 0; i < 10; i++) {
      final randomDay = now.subtract(Duration(days: i * 2 + 5)); // 更多分散的日期
      _addRecord(
        randomDay,
        '這是一條隨機生成的打卡記錄，日期為 ${DateFormat('MM月dd日').format(randomDay)}。',
        randomDay.subtract(const Duration(hours: 1)),
      );
    }
  }

  // 輔助方法：添加記錄到 _kEventSource
  void _addRecord(DateTime date, String content, DateTime punchTime) {
    final normalizedDate = DateTime.utc(date.year, date.month, date.day);
    if (_kEventSource[normalizedDate] == null) {
      _kEventSource[normalizedDate] = [];
    }
    _kEventSource[normalizedDate]!.add(
      PunchRecord(
        dateId: DateFormat('yyyyMMdd').format(date),
        recordContent: content,
        punchTime: punchTime,
      ),
    );
  }

  // 初始化時檢查今天是否有記錄並顯示
  void _initializeSelectedRecord() {
    final normalizedToday = DateTime.utc(_focusedDay.year, _focusedDay.month, _focusedDay.day);
    setState(() {
      // 假設一天只有一條記錄，如果有多條，你可能需要選擇一個顯示或顯示列表
      _selectedRecord = _kEventSource[normalizedToday]?.first;
    });
  }

  // TableCalendar 的 eventLoader，用於判斷哪些日期有事件
  List<PunchRecord> _getEventsForDay(DateTime day) {
    final normalizedDay = DateTime.utc(day.year, day.month, day.day);
    return _kEventSource[normalizedDay] ?? [];
  }

  // 當用戶點擊日曆中的某一天時調用
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (selectedDay.month != DateTime.now().month) {
      return; // 只允許選擇當月的日期
    }
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;

      // 查找選中日期的記錄
      final normalizedSelectedDay = DateTime.utc(selectedDay.year, selectedDay.month, selectedDay.day);
      _selectedRecord = _kEventSource[normalizedSelectedDay]?.first; // 假設一天只有一條記錄
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 上半部：日曆顯示
        TableCalendar<PunchRecord>(
          calendarStyle: CalendarStyle(),

          startingDayOfWeek: StartingDayOfWeek.monday,
          rowHeight: 40,
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          calendarFormat: _calendarFormat,
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: _onDaySelected,
          onFormatChanged: (format) {
            if (_calendarFormat != format) {
              setState(() {
                _calendarFormat = format;
              });
            }
          },

          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
          // holidayPredicate: (day) => day.weekday == DateTime.saturday || day.weekday == DateTime.sunday, // 假日判斷條件
          // headerVisible: false, // 隱藏日曆頭部
          // sixWeekMonthsEnforced: true,

          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: TextStyle(color: Colors.black87),
            weekendStyle: TextStyle(color: Colors.redAccent),
          ),

          eventLoader: _getEventsForDay,
          calendarBuilders: CalendarBuilders(
            outsideBuilder: (context, day, focusedDay) {
              if (day.month != focusedDay.month) {
                return Text(" ");
              }
              return null;
            },
            weekNumberBuilder: (context, weekNumber) {
              return null;
            },
            // headerTitleBuilder: (context, day) {
            //   return Text("data");
            // },

            markerBuilder: (context, date, events) {
              if (events.isNotEmpty) {
                if (date.month == DateTime.now().month) {
                  return Center(
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.amber.withAlpha(30),
                    ),
                  );
                } else {
                  return Text(" ");
                }
              }
              return null;
            },
          ),
        ),
        const SizedBox(height: 16.0),
        // --- 分割線 ---
        const Divider(height: 1, thickness: 1),
        const SizedBox(height: 16.0),
        // 下半部：顯示選中日期的記錄內容
        SizedBox(
          height: 100,
          child: _selectedRecord != null
              ? Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '打卡日期: ${DateFormat('yyyy年MM月dd日').format(_selectedDay!)}',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '打卡內容:',
                          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Text(
                              _selectedRecord!.recordContent,
                              style: const TextStyle(fontSize: 18, height: 1.5),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            '打卡時間: ${DateFormat('HH:mm').format(_selectedRecord!.punchTime)}',
                            style: TextStyle(fontSize: 14, color: Colors.grey[500], fontStyle: FontStyle.italic),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Center(
                  child: Text(
                    _selectedDay == null
                        ? '請在日曆上選擇一個日期來查看打卡記錄。'
                        : '選擇日期 (${DateFormat('yyyy年MM月dd日').format(_selectedDay!)}) 無打卡記錄。',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildEventsMarker(DateTime date, List<PunchRecord> events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).colorScheme.secondary,
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: const TextStyle().copyWith(
            color: Colors.white,
            fontSize: 10.0,
          ),
        ),
      ),
    );
  }
}

class PunchRecord {
  final String dateId; // 儲存日期的標準化 ID，例如 "20250523"
  final String recordContent; // 打卡內容
  final DateTime punchTime; // 打卡時間

  PunchRecord({
    required this.dateId,
    required this.recordContent,
    required this.punchTime,
  });
}
