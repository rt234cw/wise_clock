import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wise_clock/clock_records_bloc.dart';
import 'package:wise_clock/clock_records_repository.dart';
import 'package:wise_clock/daily_clock_log.dart';
import 'package:wise_clock/local_clock_records_repository.dart';
import 'package:wise_clock/views/on_duty_card.dart';

import 'app_clock_records_repository.dart';
import 'models/clock_records_event.dart';

class ClockRecordsPage extends StatelessWidget {
  const ClockRecordsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<ClockRecordsRepository>(
      create: (_) => AppClockRecordsRepository(
        LocalClockRecordsRepository(Hive.box<DailyClockLog>('dailyLogs')),
      ),
      child: BlocProvider(
        create: (ctx) => ClockRecordsBloc(
          ctx.read<ClockRecordsRepository>(),
        )..add(FetchClockLogs()),
        child: _ClockRecordsView(), // DutyCard 在這裡面
      ),
    );
  }
}

class _ClockRecordsView extends StatefulWidget {
  @override
  State<_ClockRecordsView> createState() => _ClockRecordsViewState();
}

class _ClockRecordsViewState extends State<_ClockRecordsView> {
  // Timer? _longPressTimer;

  late final TextEditingController onDutyHourController;
  late final TextEditingController onDutyMinController;
  late final TextEditingController onDutySecController;

  late final TextEditingController offDutyHourController;
  late final TextEditingController offDutyMinController;
  late final TextEditingController offDutySecController;

  late int onDutyHour;
  late int onDutyMinute;
  late int onDutySecond;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();

    onDutyHour = now.hour;
    onDutyMinute = now.minute;
    onDutySecond = now.second;

    onDutyHourController = TextEditingController(text: _two(onDutyHour));
    onDutyMinController = TextEditingController(text: _two(onDutyMinute));
    onDutySecController = TextEditingController(text: _two(onDutySecond));

    offDutyHourController = TextEditingController(text: "00");
    offDutyMinController = TextEditingController(text: "00");
    offDutySecController = TextEditingController(text: "00");
  }

  @override
  void dispose() {
    onDutyHourController.dispose();
    onDutyMinController.dispose();
    onDutySecController.dispose();
    offDutyHourController.dispose();
    offDutyMinController.dispose();
    offDutySecController.dispose();
    super.dispose();
  }

  // 把 5 變成 "05"
  String _two(int v) => v.toString().padLeft(2, '0');

  /// 增減並更新文字框
  // void _changeHour(int delta) => setState(() {
  //       onDutyHour = (onDutyHour + delta) % 24;
  //       if (onDutyHour < 0) onDutyHour += 24;
  //       onDutyHourController.text = _two(onDutyHour);
  //     });

  // void _changeMinute(int delta) => setState(() {
  //       onDutyMinute = (onDutyMinute + delta) % 60;
  //       if (onDutyMinute < 0) onDutyMinute += 60;
  //       onDutyMinController.text = _two(onDutyMinute);
  //     });

  // void _changeSecond(int delta) => setState(() {
  //       onDutySecond = (onDutySecond + delta) % 60;
  //       if (onDutySecond < 0) onDutySecond += 60;
  //       onDutySecController.text = _two(onDutySecond);
  //     });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: SingleChildScrollView(
        child: Column(
          spacing: 8,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(height: 8),
            OnDutyCard(),
            Row(
              spacing: 8,
              children: [
                Expanded(child: dayWorkHours()),
                Expanded(child: weekWorkHours()),
              ],
            ),
            leaveContainer(context, containerTitle: "請假"),
          ],
        ),
      ),
    );
  }

  Widget leaveContainer(BuildContext context, {required String containerTitle}) {
    return Container(
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
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(containerTitle, style: Theme.of(context).textTheme.titleMedium),
          Row(
            children: [
              SizedBox(
                width: 40,
                child: TextField(),
              ),
              const SizedBox(width: 8),
              Text("小時", style: Theme.of(context).textTheme.bodyMedium),
              Spacer(),
              TextButton(onPressed: () {}, child: Text("整日")),
              FilledButton(onPressed: () {}, child: Text("請假"))
            ],
          ),
        ],
      ),
    );
  }

  Widget dayWorkHours() {
    return Container(
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
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("今日時數", style: Theme.of(context).textTheme.titleMedium),
          Row(
            children: [
              Text("08:00", style: Theme.of(context).textTheme.titleLarge),
            ],
          ),
        ],
      ),
    );
  }

  Widget weekWorkHours() {
    return Container(
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
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("本週時數", style: Theme.of(context).textTheme.titleMedium),
          Row(
            children: [
              Text("08:00", style: Theme.of(context).textTheme.titleLarge),
            ],
          ),
        ],
      ),
    );
  }

  // void _startHold(Function callback) {
  //   callback(); // 先執行一次
  //   _longPressTimer?.cancel();
  //   _longPressTimer = Timer.periodic(const Duration(milliseconds: 150), (_) {
  //     callback();
  //   });
  // }

  // void _stopHold() {
  //   _longPressTimer?.cancel();
  //   _longPressTimer = null;
  // }

  // Widget _timeSpinner({
  //   required VoidCallback onAdd,
  //   required VoidCallback onRemove,
  //   required TextEditingController controller,
  // }) {
  //   return Column(
  //     mainAxisSize: MainAxisSize.min,
  //     children: [
  //       SizedBox(
  //         width: 40,
  //         child: TextField(
  //           controller: controller,
  //           onChanged: (value) {
  //             if (value.isNotEmpty) {
  //               int? hour = int.tryParse(value);
  //               if (hour != null && hour >= 0 && hour < 24) {
  //                 onDutyHour = hour;
  //               } else {
  //                 // Handle invalid input
  //                 controller.text = onDutyHour.toString();
  //               }
  //             }
  //           },
  //           textAlign: TextAlign.center,
  //           style: TextStyle(fontSize: 24, color: ColorCode.primaryColor, fontWeight: FontWeight.w600),
  //           keyboardType: TextInputType.number,
  //           decoration: const InputDecoration(
  //             isDense: true,
  //             contentPadding: EdgeInsets.symmetric(vertical: 6),
  //             border: InputBorder.none,
  //             filled: false,
  //           ),
  //         ),
  //       ),
  //       GestureDetector(
  //         onTap: onAdd,
  //         onLongPressStart: (_) => _startHold(onAdd),
  //         onLongPressEnd: (_) => _stopHold(),
  //         child: Icon(
  //           Icons.add,
  //           size: 18,
  //           color: const Color.fromARGB(255, 197, 210, 243),
  //         ),
  //       ),
  //       const SizedBox(height: 8),
  //       GestureDetector(
  //         onTap: onRemove,
  //         onLongPressStart: (_) => _startHold(onRemove),
  //         onLongPressEnd: (_) => _stopHold(),
  //         child: Icon(
  //           Icons.remove,
  //           size: 18,
  //           color: const Color.fromARGB(255, 197, 210, 243),
  //         ),
  //       ),
  //     ],
  //   );
  // }

// ===== 主體 =====
  // Widget dutyContainer(
  //   BuildContext context, {
  //   required String containerTitle,
  //   required TextEditingController hourCtrl,
  //   required TextEditingController minCtrl,
  //   required TextEditingController secCtrl,
  // }) {
  //   return Container(
  //     padding: const EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(8),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withValues(alpha: 0.1),
  //           blurRadius: 4,
  //           offset: const Offset(0, 2),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(containerTitle, style: Theme.of(context).textTheme.titleMedium),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Row(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 _timeSpinner(
  //                   onAdd: () => _changeHour(1),
  //                   onRemove: () => _changeHour(-1),
  //                   controller: hourCtrl,
  //                 ),
  //                 _timeSpinner(
  //                   onAdd: () => _changeMinute(1),
  //                   onRemove: () => _changeMinute(-1),
  //                   controller: minCtrl,
  //                 ),
  //                 _timeSpinner(
  //                   onAdd: () => _changeSecond(1),
  //                   onRemove: () => _changeSecond(-1),
  //                   controller: secCtrl,
  //                 ),
  //               ],
  //             ),
  //             FilledButton.icon(onPressed: () {}, label: Text("打卡"))
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
