// import 'package:flutter/material.dart';
// import 'package:wise_clock/bloc/bloc_barrel.dart';
// import 'package:wise_clock/datetime_id_extension.dart';
// import 'package:wise_clock/model/editing_target.dart';
// import 'package:wise_clock/views/duty_record_text.dart';
// import 'package:wise_clock/views/share_ui_components/shared_container.dart';
// import 'package:wise_clock/views/share_ui_components/time_wheel.dart';
// import 'action_buttons.dart';

// class OnDutyCard extends StatefulWidget {
//   const OnDutyCard({
//     super.key,
//     // required this.onEditingMode,
//   });

//   @override
//   State<OnDutyCard> createState() => _OnDutyCardState();
// }

// class _OnDutyCardState extends State<OnDutyCard> {
//   late final TextEditingController _hourController;
//   late final TextEditingController _minController;
//   late final TextEditingController _secondController;
//   final int animationDuration = 350;

//   @override
//   void initState() {
//     super.initState();
//     final now = DateTime.now();
//     _hourController = TextEditingController(text: now.twoDigitHour);
//     _minController = TextEditingController(text: now.twoDigitMinute);
//     _secondController = TextEditingController(text: now.twoDigitSecond);
//   }

//   @override
//   void dispose() {
//     _hourController.dispose();
//     _minController.dispose();
//     _secondController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final bloc = context.read<DashboardBloc>();

//     return SharedContainer(
//       child: BlocBuilder<DashboardBloc, DashboardState>(
//         // buildWhen: (p, n) =>
//         //     p.editingTarget != n.editingTarget || p.todayRecord?.clockInTime != n.todayRecord?.clockInTime,
//         builder: (context, state) {
//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Text(
//                 "上班時間",
//                 style: Theme.of(context).textTheme.titleMedium,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   // 時間記錄區
//                   DutyRecordText(
//                     timeRecord: state.todayRecord?.clockInTime.hmsFormatted,
//                   ),
//                   // _showDutyRecord(state.todayRecord?.clockInTime),
//                   // 按鈕區
//                   // buttons,
//                 ],
//               ),

//               // 手輸時間
//               // AnimatedSize(
//               //   duration: Duration(milliseconds: animationDuration),
//               //   child: state.editingTarget == EditingTarget.clockIn
//               //       ? _manuallyInputTime(state, bloc)
//               //       : SizedBox.shrink(), // 變沒內容
//               // ),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   Builder _manuallyInputTime(DashboardState state, DashboardBloc bloc) {
//     return Builder(builder: (context) {
//       //判斷是否有打卡紀錄
//       final todayRecord = state.todayRecord;
//       final String? id = todayRecord?.id;
//       final DateTime? clockInTime = todayRecord?.clockInTime;
//       ({int hour, int min, int sec})? clockInRecord;

//       if (clockInTime != null) {
//         clockInRecord = (
//           hour: clockInTime.hour,
//           min: clockInTime.minute,
//           sec: clockInTime.second,
//         );
//       }

//       late ({int hour, int min, int sec}) pickedTime;

//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Divider(),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               TimeWheel(
//                 onSetter: (value) => pickedTime = value,
//                 userReocrd: clockInRecord,
//               ),
//               Row(
//                 children: [
//                   TextButton(
//                     onPressed: () {
//                       // bloc.add(CancelEditingEvent());
//                     },
//                     child: Text("取消"),
//                   ),
//                   FilledButton(
//                     onPressed: () {
//                       final clockInTime = DateTime(
//                         DateTime.now().year,
//                         DateTime.now().month,
//                         DateTime.now().day,
//                         pickedTime.hour,
//                         pickedTime.min,
//                         pickedTime.sec,
//                       );

//                       //表示還沒打過卡，用今天的日期
//                       if (id == null) {
//                         final newID = DateTime.now().getYmd;
//                         // bloc.add(AddClockInEvent(id: newID, clockInTime: clockInTime));
//                         return;
//                       }

//                       //有紀錄就表示，用戶是在修改今天的紀錄
//                       // bloc.add(AddClockInEditEvent(id: id, clockInTime: clockInTime));
//                     },
//                     child: Text(id == null ? "打卡" : "更新"),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ],
//       );
//     });
//   }
// }
