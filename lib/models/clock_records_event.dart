sealed class ClockRecordsEvent {}

class ClockInPressed extends ClockRecordsEvent {
  final DateTime clockIn;
  ClockInPressed(this.clockIn);
}

/// 進入「編輯上班時間」模式（展開 UI）
class ClockInEditStarted extends ClockRecordsEvent {}

/// 取消編輯（折疊 UI，不改時間）
class ClockInEditCanceled extends ClockRecordsEvent {}

/// 調整上班時間後重新送出
class ClockInEdited extends ClockRecordsEvent {
  final DateTime newClckIn;
  ClockInEdited(this.newClckIn);
}

class ClockOutPressed extends ClockRecordsEvent {
  final DateTime clockOut;
  ClockOutPressed(this.clockOut);
}

class FetchClockLogs extends ClockRecordsEvent {}
