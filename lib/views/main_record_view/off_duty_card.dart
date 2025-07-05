import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_clock/datetime_id_extension.dart';
import 'package:wise_clock/model/editing_target.dart';
import 'package:wise_clock/views/duty_record_text.dart';
import 'package:wise_clock/views/share_ui_components/shared_container.dart';

import '../../bloc/dashboard_bloc.dart';
import '../../bloc/dashboard_event.dart';
import '../../bloc/clock_record_state.dart';
import '../share_ui_components/time_wheel.dart';
import 'off_action_buttons.dart';

class OffDutyCard extends StatefulWidget {
  const OffDutyCard({super.key});

  @override
  State<OffDutyCard> createState() => _OffDutyCardState();
}

class _OffDutyCardState extends State<OffDutyCard> {
  late final DashboardBloc _bloc;
  late final TextEditingController _hourController;
  late final TextEditingController _minController;
  late final TextEditingController _secondController;
  final int animationDuration = 350;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _hourController = TextEditingController(text: now.twoDigitHour);
    _minController = TextEditingController(text: now.twoDigitMinute);
    _secondController = TextEditingController(text: now.twoDigitSecond);

    _bloc = context.read<DashboardBloc>();
  }

  @override
  void dispose() {
    _hourController.dispose();
    _minController.dispose();
    _secondController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SharedContainer(
      child: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "下班時間",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 時間記錄區
                      DutyRecordText(timeRecord: state.todayRecord?.clockOutTime?.hmsFormatted),
                      // 按鈕區
                    ],
                  ),

                  // 手輸時間
                  AnimatedSize(
                    duration: Duration(milliseconds: animationDuration),
                    child: state.editingTarget == EditingTarget.clockOut
                        ? _manuallyInputTime(state, _bloc)
                        : SizedBox.shrink(), // 變沒內容
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Builder _manuallyInputTime(DashboardState state, DashboardBloc bloc) {
    return Builder(builder: (context) {
      //判斷是否有打卡紀錄
      final todayRecord = state.todayRecord;
      final String? id = todayRecord?.id;
      final DateTime? clockOutTime = todayRecord?.clockOutTime;
      ({int hour, int min, int sec})? clockOutRecord;

      if (clockOutTime != null) {
        clockOutRecord = (
          hour: clockOutTime.hour,
          min: clockOutTime.minute,
          sec: clockOutTime.second,
        );
      }

      late ({int hour, int min, int sec}) pickedTime;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TimeWheel(
                onSetter: (value) => pickedTime = value,
                userReocrd: clockOutRecord,
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      bloc.add(CancelEditingEvent());
                    },
                    child: Text("取消"),
                  ),
                  FilledButton(
                    onPressed: () {
                      final clockOutTime = DateTime(
                        DateTime.now().year,
                        DateTime.now().month,
                        DateTime.now().day,
                        pickedTime.hour,
                        pickedTime.min,
                        pickedTime.sec,
                      );
                      if (clockOutTime.isAfter(state.todayRecord!.clockInTime)) {
                        //表示還沒打過卡，用今天的日期
                        if (id == null) {
                          final newID = DateTime.now().getYmd;
                          bloc.add(AddClockOutEvent(id: newID, clockOutTime: clockOutTime));
                          return;
                        }

                        print("object");

                        //有紀錄就表示，用戶是在修改今天的紀錄
                        bloc.add(AddClockOutEditEvent(id: id, clockOutTime: clockOutTime));
                      } else {
                        ScaffoldMessenger.of(context)
                          ..removeCurrentSnackBar()
                          ..showSnackBar(
                            SnackBar(
                              animation: AlwaysStoppedAnimation(0.5),
                              behavior: SnackBarBehavior.floating,
                              content: Text("下班時間不能早於上班時間"),
                            ),
                          );
                      }
                    },
                    child: Text(id == null ? "打卡" : "更新"),
                  ),
                ],
              ),
            ],
          ),
        ],
      );
    });
  }

  // Widget _offWork() {
  //   return Column(
  //     children: [
  //       Text("下班時間"),
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           SizedBox(
  //             width: 50,
  //             child: TextField(
  //               controller: _hourController,
  //               keyboardType: TextInputType.number,
  //               decoration: const InputDecoration(hintText: "時"),
  //             ),
  //           ),
  //           const Text(":"),
  //           SizedBox(
  //             width: 50,
  //             child: TextField(
  //               controller: _minController,
  //               keyboardType: TextInputType.number,
  //               decoration: const InputDecoration(hintText: "分"),
  //             ),
  //           ),
  //           const Text(":"),
  //           SizedBox(
  //             width: 50,
  //             child: TextField(
  //               controller: _secondController,
  //               keyboardType: TextInputType.number,
  //               decoration: const InputDecoration(hintText: "秒"),
  //             ),
  //           ),
  //         ],
  //       ),
  //       ElevatedButton(
  //         onPressed: () {},
  //         child: const Text("下班"),
  //       ),
  //     ],
  //   );
  // }

  // Widget _offWorkCompleted() {
  //   final DateTime? estimatedOffTime = _bloc.state.todayRecord?.clockOutTime?.add(Duration(hours: 9));
  //   final isOffTimeExisting = _bloc.state.todayRecord?.clockOutTime == null;
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.stretch,
  //     children: [
  //       Text(
  //         "下班時間",
  //         style: Theme.of(context).textTheme.labelMedium!.copyWith(
  //               color: Colors.black54,
  //             ),
  //       ),
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           Text(
  //             estimatedOffTime?.hmsFormatted ?? "--:--:--",
  //             style: Theme.of(context)
  //                 .textTheme
  //                 .headlineMedium
  //                 ?.copyWith(fontWeight: FontWeight.w600, color: isOffTimeExisting ? Colors.grey : null),
  //           ),
  //           Row(
  //             spacing: 16,
  //             children: [
  //               IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
  //               FilledButton(
  //                   onPressed: () {
  //                     final offTime = DateTime.now();
  //                     final onTime = _bloc.state.todayRecord!.clockOutTime!;

  //                     if (offTime.isBefore(onTime)) {
  //                       ScaffoldMessenger.of(context)
  //                         ..removeCurrentSnackBar()
  //                         ..showSnackBar(
  //                           SnackBar(content: Text("下班時間不能早於上班時間")),
  //                         );
  //                       return;
  //                     } else {
  //                       final id = _bloc.state.todayRecord!.id;
  //                       _bloc.add(AddClockOutEvent(id: id, clockOutTime: offTime));
  //                     }
  //                   },
  //                   child: Text("下班")),
  //             ],
  //           ),
  //         ],
  //       ),
  //     ],
  //   );
  // }

  // DateTime _getClockOutTime() {
  //   return DateTime(
  //     DateTime.now().year,
  //     DateTime.now().month,
  //     DateTime.now().day,
  //     int.parse(_hourController.text),
  //     int.parse(_minController.text),
  //     int.parse(_secondController.text),
  //   );
  // }

  // Widget get secondChild => _offWorkCompleted();
}
