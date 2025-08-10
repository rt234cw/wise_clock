// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get abbreHour => '時';

  @override
  String get abbreMinute => '分';

  @override
  String get accumulatedHours => '本週累積時數';

  @override
  String get addNewRecord => '新增打卡記錄';

  @override
  String get adjust => '調整';

  @override
  String get areYouSureOverwrite => '確認要覆蓋原有紀錄嗎？';

  @override
  String get balanced => '正好';

  @override
  String get cancel => '取消';

  @override
  String get clear => '清除';

  @override
  String get clearAll => '全部清除';

  @override
  String get clearAllRecords => '清除所有紀錄';

  @override
  String get clockIn => '打卡';

  @override
  String get clockInNow => '快速打卡';

  @override
  String get clockInTime => '上班時間';

  @override
  String get clockOutTime => '下班時間';

  @override
  String get close => '關閉';

  @override
  String get confirm => '確認';

  @override
  String get confirmAction => '再次確認';

  @override
  String get dataLoadingFailed => '讀取資料失敗';

  @override
  String get day => '星期';

  @override
  String get editRecord => '編輯紀錄';

  @override
  String get fullDay => '整日';

  @override
  String get hours => '工時';

  @override
  String hoursUnit(int count) {
    return '小時';
  }

  @override
  String get leave => '請假';

  @override
  String get leaveHours => '請假時數';

  @override
  String get manualEntry => '手動輸入';

  @override
  String minutesUnit(int count) {
    return '分';
  }

  @override
  String get noCompletedRecords => '本週尚無已完成的打卡紀錄';

  @override
  String get noLeave => '未請假';

  @override
  String get noRecordForThisDay => '查無當日記錄';

  @override
  String get notClockedIn => '尚未打卡';

  @override
  String get out => '下班';

  @override
  String get overtime => '超時';

  @override
  String get overwriteExistingRecord => '登記整天請假將會覆蓋您原有的上下班打卡紀錄，且此操作無法復原。';

  @override
  String get permanentlyDelete => '此操作將永久清除您所有的打卡紀錄，確定要繼續嗎？';

  @override
  String get selectDateToViewRecords => '選擇日期查詢記錄';

  @override
  String get selectLanguage => '選擇語言';

  @override
  String get settings => '設定';

  @override
  String get shortage => '短缺';

  @override
  String get sureToDeleteRecord => '您確定要刪除這筆打卡紀錄嗎？此操作無法復原。';

  @override
  String get takeLeave => '請假';

  @override
  String get today => '今日';

  @override
  String get update => '更新';

  @override
  String get workIn => '上班';
}
