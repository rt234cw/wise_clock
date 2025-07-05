extension DateTimeYmd on DateTime {
  //把今天的日期轉換成 YYYYMMDD的格式，用來儲存時間記錄的ID
  String get getYmd {
    return "$year${month.toString().padLeft(2, '0')}${day.toString().padLeft(2, '0')}";
  }
}

extension DateTimeHms on DateTime {
  // 輸出格式像 "083521"
  String get hmsCompact =>
      "${hour.toString().padLeft(2, '0')}${minute.toString().padLeft(2, '0')}${second.toString().padLeft(2, '0')}";

  // 輸出格式像 "08:35:21"
  String get hmsFormatted =>
      "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}:${second.toString().padLeft(2, '0')}";
}

extension TwoDigitsDateTime on DateTime {
  // 取得兩位數的時
  String get twoDigitHour => hour.toString().padLeft(2, '0');

  // 取得兩位數的分
  String get twoDigitMinute => minute.toString().padLeft(2, '0');

  // 取得兩位數的秒
  String get twoDigitSecond => second.toString().padLeft(2, '0');
}
