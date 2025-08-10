// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a zh locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'zh';

  static String m0(count) => "小時";

  static String m1(count) => "分";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "abbreHour": MessageLookupByLibrary.simpleMessage("時"),
    "abbreMinute": MessageLookupByLibrary.simpleMessage("分"),
    "accumulatedHours": MessageLookupByLibrary.simpleMessage("本週累積時數"),
    "addNewRecord": MessageLookupByLibrary.simpleMessage("新增打卡記錄"),
    "adjust": MessageLookupByLibrary.simpleMessage("調整"),
    "alwaysSixWeeks": MessageLookupByLibrary.simpleMessage("永遠顯示六週"),
    "areYouSureOverwrite": MessageLookupByLibrary.simpleMessage("確認要覆蓋原有紀錄嗎？"),
    "balanced": MessageLookupByLibrary.simpleMessage("正好"),
    "calendar": MessageLookupByLibrary.simpleMessage("月曆"),
    "cancel": MessageLookupByLibrary.simpleMessage("取消"),
    "clear": MessageLookupByLibrary.simpleMessage("清除"),
    "clearAll": MessageLookupByLibrary.simpleMessage("全部清除"),
    "clearAllRecords": MessageLookupByLibrary.simpleMessage("清除所有紀錄"),
    "clockIn": MessageLookupByLibrary.simpleMessage("打卡"),
    "clockInNow": MessageLookupByLibrary.simpleMessage("快速打卡"),
    "clockInTime": MessageLookupByLibrary.simpleMessage("上班時間"),
    "clockOutTime": MessageLookupByLibrary.simpleMessage("下班時間"),
    "close": MessageLookupByLibrary.simpleMessage("關閉"),
    "confirm": MessageLookupByLibrary.simpleMessage("確認"),
    "confirmAction": MessageLookupByLibrary.simpleMessage("再次確認"),
    "data": MessageLookupByLibrary.simpleMessage("資料"),
    "dataLoadingFailed": MessageLookupByLibrary.simpleMessage("讀取資料失敗"),
    "day": MessageLookupByLibrary.simpleMessage("星期"),
    "delete": MessageLookupByLibrary.simpleMessage("刪除"),
    "editRecord": MessageLookupByLibrary.simpleMessage("編輯紀錄"),
    "fullDay": MessageLookupByLibrary.simpleMessage("整日"),
    "hours": MessageLookupByLibrary.simpleMessage("工時"),
    "hoursUnit": m0,
    "leave": MessageLookupByLibrary.simpleMessage("請假"),
    "leaveHours": MessageLookupByLibrary.simpleMessage("請假時數"),
    "manualEntry": MessageLookupByLibrary.simpleMessage("手動輸入"),
    "minutesUnit": m1,
    "noCompletedRecords": MessageLookupByLibrary.simpleMessage("本週尚無已完成的打卡紀錄"),
    "noLeave": MessageLookupByLibrary.simpleMessage("未請假"),
    "noRecordForThisDay": MessageLookupByLibrary.simpleMessage("查無當日記錄"),
    "notClockedIn": MessageLookupByLibrary.simpleMessage("尚未打卡"),
    "out": MessageLookupByLibrary.simpleMessage("下班"),
    "overtime": MessageLookupByLibrary.simpleMessage("超時"),
    "overwriteExistingRecord": MessageLookupByLibrary.simpleMessage(
      "登記整天請假將會覆蓋您原有的上下班打卡紀錄，且此操作無法復原。",
    ),
    "permanentlyDelete": MessageLookupByLibrary.simpleMessage(
      "此操作將永久清除您所有的打卡紀錄，確定要繼續嗎？",
    ),
    "selectDateToViewRecords": MessageLookupByLibrary.simpleMessage("選擇日期查詢記錄"),
    "selectLanguage": MessageLookupByLibrary.simpleMessage("選擇語言"),
    "settings": MessageLookupByLibrary.simpleMessage("設定"),
    "shortage": MessageLookupByLibrary.simpleMessage("短缺"),
    "showWeekend": MessageLookupByLibrary.simpleMessage("顯示週末"),
    "sureToDeleteRecord": MessageLookupByLibrary.simpleMessage(
      "您確定要刪除這筆打卡紀錄嗎？此操作無法復原。",
    ),
    "system": MessageLookupByLibrary.simpleMessage("系統"),
    "takeLeave": MessageLookupByLibrary.simpleMessage("請假"),
    "today": MessageLookupByLibrary.simpleMessage("今日"),
    "update": MessageLookupByLibrary.simpleMessage("更新"),
    "workIn": MessageLookupByLibrary.simpleMessage("上班"),
  };
}
