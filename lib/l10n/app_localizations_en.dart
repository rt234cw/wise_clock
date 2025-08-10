// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get abbreHour => 'H';

  @override
  String get abbreMinute => 'm';

  @override
  String get accumulatedHours => 'Weekly Hours';

  @override
  String get addNewRecord => 'Add New Record';

  @override
  String get adjust => 'Adjust';

  @override
  String get areYouSureOverwrite =>
      'Are you sure to overwirte existing record?';

  @override
  String get balanced => 'Balanced';

  @override
  String get cancel => 'Cancel';

  @override
  String get clear => 'Clear';

  @override
  String get clearAll => 'Clear All';

  @override
  String get clearAllRecords => 'Clear All Records';

  @override
  String get clockIn => 'Clock In';

  @override
  String get clockInNow => 'Clock In Now';

  @override
  String get clockInTime => 'Clock In Time';

  @override
  String get clockOutTime => 'Clock Out Time';

  @override
  String get close => 'Close';

  @override
  String get confirm => 'Confirm';

  @override
  String get confirmAction => 'Confirm Action';

  @override
  String get dataLoadingFailed => 'Data Loading Failed ';

  @override
  String get day => 'Day';

  @override
  String get editRecord => 'Edit Record';

  @override
  String get fullDay => 'Full Day';

  @override
  String get hours => 'Hours';

  @override
  String hoursUnit(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'hours',
      one: 'hour',
    );
    return '$_temp0';
  }

  @override
  String get leave => 'Leave';

  @override
  String get leaveHours => 'Leave Hours';

  @override
  String get manualEntry => 'Manual Entry';

  @override
  String minutesUnit(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'mins',
      one: 'min',
    );
    return '$_temp0';
  }

  @override
  String get noCompletedRecords => 'No completed records this week';

  @override
  String get noLeave => 'No Leave';

  @override
  String get noRecordForThisDay => 'No record for this day';

  @override
  String get notClockedIn => 'Not Clocked In';

  @override
  String get out => 'Out';

  @override
  String get overtime => 'Overtime';

  @override
  String get overwriteExistingRecord =>
      'Registering a full-day leave will overwrite your existing clock-in/out records for today, and this action cannot be undone.';

  @override
  String get permanentlyDelete =>
      'This will permanently delete all of your clock-in records. Are you sure you want to continue?';

  @override
  String get selectDateToViewRecords => 'Select a date to view records';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get settings => 'Settings';

  @override
  String get shortage => 'Shortage';

  @override
  String get sureToDeleteRecord =>
      'Are you sure you want to delete this record? This action cannot be undone.';

  @override
  String get takeLeave => 'Take Leave';

  @override
  String get today => 'Today';

  @override
  String get update => 'Update';

  @override
  String get workIn => 'In';
}
