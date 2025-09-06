// import 'package:flutter/material.dart';
// import 'package:wise_clock/views/share_ui_components/shared_container.dart';
// import '../../bloc/bloc_barrel.dart';
// import '../../color_scheme/color_code.dart';

// class TodayDiffTimeCard extends StatelessWidget {
//   const TodayDiffTimeCard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     const standardDayWorkDuration = Duration(hours: 8);
//     const standardBreakDuration = Duration(hours: 1);

//     return SharedContainer(
//         child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           "本日時數",
//           style: Theme.of(context).textTheme.titleMedium,
//         ),
//         BlocBuilder<DashboardBloc, DashboardState>(
//           buildWhen: (previous, current) => previous.todayRecord != current.todayRecord,
//           builder: (context, state) {
//             final todayRecord = state.todayRecord;
//             if (todayRecord == null) {
//               return const Text("--:--");
//             }

//             Duration totalRecognizedDuration;

//             //  檢查是否為「整天請假」的特殊情況
//             if (todayRecord.leaveDuration == 8.0) {
//               // 如果是，直接將認定工時設為 8 小時
//               totalRecognizedDuration = const Duration(hours: 8);
//             } else {
//               //  否則，執行正常的詳細計算
//               Duration dailyNetWorkDuration = Duration.zero;

//               // 計算實際在公司工時
//               if (todayRecord.clockOutTime != null) {
//                 final grossDuration = todayRecord.clockOutTime!.difference(todayRecord.clockInTime);

//                 Duration breakToSubtract;
//                 if (todayRecord.offDuration != null) {
//                   breakToSubtract = Duration(seconds: (todayRecord.offDuration! * 3600).round());
//                 } else {
//                   breakToSubtract = (grossDuration.inHours >= 6) ? standardBreakDuration : Duration.zero;
//                 }
//                 dailyNetWorkDuration = grossDuration - breakToSubtract;
//               }

//               // 加上請假時數
//               final leaveInHours = todayRecord.leaveDuration ?? 0.0;
//               final leaveDuration = Duration(seconds: (leaveInHours * 3600).round());

//               // 總認定工時 = 淨工時 + 請假時數
//               totalRecognizedDuration = (dailyNetWorkDuration + leaveDuration).isNegative
//                   ? Duration.zero
//                   : (dailyNetWorkDuration + leaveDuration);
//             }

//             final difference = totalRecognizedDuration - standardDayWorkDuration;

//             final absSeconds = difference.inSeconds.abs();
//             final hours = absSeconds ~/ 3600;
//             final minutes = (absSeconds % 3600) ~/ 60;

//             String formattedTime = '';
//             if (hours > 0) {
//               formattedTime += '$hours時';
//             }
//             formattedTime += '${minutes.toString().padLeft(2, '0')}分';

//             Color displayColor = Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey;
//             String prefix = '正好';

//             if (difference.inSeconds > 0) {
//               displayColor = ColorCode.green;
//               prefix = '超時';
//             } else if (difference.inSeconds < 0) {
//               displayColor = ColorCode.red;
//               prefix = '短缺';
//             }

//             return FittedBox(
//               fit: BoxFit.scaleDown,
//               child: Text(
//                 '$prefix $formattedTime',
//                 maxLines: 1,
//                 style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                       color: displayColor,
//                     ),
//               ),
//             );
//           },
//         )
//       ],
//     ));
//   }
// }
