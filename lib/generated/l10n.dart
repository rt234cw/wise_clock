// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
            ? locale.languageCode
            : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `H`
  String get abbreHour {
    return Intl.message('H', name: 'abbreHour', desc: '', args: []);
  }

  /// `m`
  String get abbreMinute {
    return Intl.message('m', name: 'abbreMinute', desc: '', args: []);
  }

  /// `Weekly Hours`
  String get accumulatedHours {
    return Intl.message(
      'Weekly Hours',
      name: 'accumulatedHours',
      desc: '',
      args: [],
    );
  }

  /// `Add New Record`
  String get addNewRecord {
    return Intl.message(
      'Add New Record',
      name: 'addNewRecord',
      desc: '',
      args: [],
    );
  }

  /// `Adjust`
  String get adjust {
    return Intl.message('Adjust', name: 'adjust', desc: '', args: []);
  }

  /// `Always show 6 weeks`
  String get alwaysSixWeeks {
    return Intl.message(
      'Always show 6 weeks',
      name: 'alwaysSixWeeks',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure to overwirte existing record?`
  String get areYouSureOverwrite {
    return Intl.message(
      'Are you sure to overwirte existing record?',
      name: 'areYouSureOverwrite',
      desc: '',
      args: [],
    );
  }

  /// `Balanced`
  String get balanced {
    return Intl.message('Balanced', name: 'balanced', desc: '', args: []);
  }

  /// `Calendar`
  String get calendar {
    return Intl.message('Calendar', name: 'calendar', desc: '', args: []);
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Clear`
  String get clear {
    return Intl.message('Clear', name: 'clear', desc: '', args: []);
  }

  /// `Clear All`
  String get clearAll {
    return Intl.message('Clear All', name: 'clearAll', desc: '', args: []);
  }

  /// `Clear all records`
  String get clearAllRecords {
    return Intl.message(
      'Clear all records',
      name: 'clearAllRecords',
      desc: '',
      args: [],
    );
  }

  /// `Clock In`
  String get clockIn {
    return Intl.message('Clock In', name: 'clockIn', desc: '', args: []);
  }

  /// `Clock In Now`
  String get clockInNow {
    return Intl.message('Clock In Now', name: 'clockInNow', desc: '', args: []);
  }

  /// `Clock In Time`
  String get clockInTime {
    return Intl.message(
      'Clock In Time',
      name: 'clockInTime',
      desc: '',
      args: [],
    );
  }

  /// `Clock Out Time`
  String get clockOutTime {
    return Intl.message(
      'Clock Out Time',
      name: 'clockOutTime',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get close {
    return Intl.message('Close', name: 'close', desc: '', args: []);
  }

  /// `Confirm`
  String get confirm {
    return Intl.message('Confirm', name: 'confirm', desc: '', args: []);
  }

  /// `Confirm Action`
  String get confirmAction {
    return Intl.message(
      'Confirm Action',
      name: 'confirmAction',
      desc: '',
      args: [],
    );
  }

  /// `Data`
  String get data {
    return Intl.message('Data', name: 'data', desc: '', args: []);
  }

  /// `Data Loading Failed `
  String get dataLoadingFailed {
    return Intl.message(
      'Data Loading Failed ',
      name: 'dataLoadingFailed',
      desc: '',
      args: [],
    );
  }

  /// `Day`
  String get day {
    return Intl.message('Day', name: 'day', desc: '', args: []);
  }

  /// `Delete`
  String get delete {
    return Intl.message('Delete', name: 'delete', desc: '', args: []);
  }

  /// `Edit Record`
  String get editRecord {
    return Intl.message('Edit Record', name: 'editRecord', desc: '', args: []);
  }

  /// `Full Day`
  String get fullDay {
    return Intl.message('Full Day', name: 'fullDay', desc: '', args: []);
  }

  /// `Hours`
  String get hours {
    return Intl.message('Hours', name: 'hours', desc: '', args: []);
  }

  /// `{count,plural, =1{hour} other{hours}}`
  String hoursUnit(int count) {
    return Intl.plural(
      count,
      one: 'hour',
      other: 'hours',
      name: 'hoursUnit',
      desc: '',
      args: [count],
    );
  }

  /// `Leave`
  String get leave {
    return Intl.message('Leave', name: 'leave', desc: '', args: []);
  }

  /// `Leave Hours`
  String get leaveHours {
    return Intl.message('Leave Hours', name: 'leaveHours', desc: '', args: []);
  }

  /// `Manual Entry`
  String get manualEntry {
    return Intl.message(
      'Manual Entry',
      name: 'manualEntry',
      desc: '',
      args: [],
    );
  }

  /// `{count,plural, =1{min} other{mins}}`
  String minutesUnit(int count) {
    return Intl.plural(
      count,
      one: 'min',
      other: 'mins',
      name: 'minutesUnit',
      desc: '',
      args: [count],
    );
  }

  /// `No completed records this week`
  String get noCompletedRecords {
    return Intl.message(
      'No completed records this week',
      name: 'noCompletedRecords',
      desc: '',
      args: [],
    );
  }

  /// `No Leave`
  String get noLeave {
    return Intl.message('No Leave', name: 'noLeave', desc: '', args: []);
  }

  /// `No record for this day`
  String get noRecordForThisDay {
    return Intl.message(
      'No record for this day',
      name: 'noRecordForThisDay',
      desc: '',
      args: [],
    );
  }

  /// `Not Clocked In`
  String get notClockedIn {
    return Intl.message(
      'Not Clocked In',
      name: 'notClockedIn',
      desc: '',
      args: [],
    );
  }

  /// `Out`
  String get out {
    return Intl.message('Out', name: 'out', desc: '', args: []);
  }

  /// `Overtime`
  String get overtime {
    return Intl.message('Overtime', name: 'overtime', desc: '', args: []);
  }

  /// `Registering a full-day leave will overwrite your existing clock-in/out records for today, and this action cannot be undone.`
  String get overwriteExistingRecord {
    return Intl.message(
      'Registering a full-day leave will overwrite your existing clock-in/out records for today, and this action cannot be undone.',
      name: 'overwriteExistingRecord',
      desc: '',
      args: [],
    );
  }

  /// `This will permanently delete all of your clock-in records. Are you sure you want to continue?`
  String get permanentlyDelete {
    return Intl.message(
      'This will permanently delete all of your clock-in records. Are you sure you want to continue?',
      name: 'permanentlyDelete',
      desc: '',
      args: [],
    );
  }

  /// `Select a date to view records`
  String get selectDateToViewRecords {
    return Intl.message(
      'Select a date to view records',
      name: 'selectDateToViewRecords',
      desc: '',
      args: [],
    );
  }

  /// `Select Language`
  String get selectLanguage {
    return Intl.message(
      'Select Language',
      name: 'selectLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message('Settings', name: 'settings', desc: '', args: []);
  }

  /// `Shortage`
  String get shortage {
    return Intl.message('Shortage', name: 'shortage', desc: '', args: []);
  }

  /// `Show Weekend`
  String get showWeekend {
    return Intl.message(
      'Show Weekend',
      name: 'showWeekend',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this record? This action cannot be undone.`
  String get sureToDeleteRecord {
    return Intl.message(
      'Are you sure you want to delete this record? This action cannot be undone.',
      name: 'sureToDeleteRecord',
      desc: '',
      args: [],
    );
  }

  /// `System`
  String get system {
    return Intl.message('System', name: 'system', desc: '', args: []);
  }

  /// `Take Leave`
  String get takeLeave {
    return Intl.message('Take Leave', name: 'takeLeave', desc: '', args: []);
  }

  /// `Today`
  String get today {
    return Intl.message('Today', name: 'today', desc: '', args: []);
  }

  /// `Update`
  String get update {
    return Intl.message('Update', name: 'update', desc: '', args: []);
  }

  /// `In`
  String get workIn {
    return Intl.message('In', name: 'workIn', desc: '', args: []);
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
