import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh')
  ];

  /// No description provided for @abbreHour.
  ///
  /// In en, this message translates to:
  /// **'H'**
  String get abbreHour;

  /// No description provided for @abbreMinute.
  ///
  /// In en, this message translates to:
  /// **'m'**
  String get abbreMinute;

  /// No description provided for @accumulatedHours.
  ///
  /// In en, this message translates to:
  /// **'Weekly Hours'**
  String get accumulatedHours;

  /// No description provided for @addNewRecord.
  ///
  /// In en, this message translates to:
  /// **'Add New Record'**
  String get addNewRecord;

  /// No description provided for @adjust.
  ///
  /// In en, this message translates to:
  /// **'Adjust'**
  String get adjust;

  /// No description provided for @alwaysSixWeeks.
  ///
  /// In en, this message translates to:
  /// **'Always show 6 weeks'**
  String get alwaysSixWeeks;

  /// No description provided for @areYouSureOverwrite.
  ///
  /// In en, this message translates to:
  /// **'Are you sure to overwirte existing record?'**
  String get areYouSureOverwrite;

  /// No description provided for @balanced.
  ///
  /// In en, this message translates to:
  /// **'Balanced'**
  String get balanced;

  /// No description provided for @calendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendar;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearAll;

  /// No description provided for @clearAllRecords.
  ///
  /// In en, this message translates to:
  /// **'Clear all records'**
  String get clearAllRecords;

  /// No description provided for @clockIn.
  ///
  /// In en, this message translates to:
  /// **'Clock In'**
  String get clockIn;

  /// No description provided for @clockInNow.
  ///
  /// In en, this message translates to:
  /// **'Clock In Now'**
  String get clockInNow;

  /// No description provided for @clockInTime.
  ///
  /// In en, this message translates to:
  /// **'Clock In Time'**
  String get clockInTime;

  /// No description provided for @clockOutTime.
  ///
  /// In en, this message translates to:
  /// **'Clock Out Time'**
  String get clockOutTime;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @confirmAction.
  ///
  /// In en, this message translates to:
  /// **'Confirm Action'**
  String get confirmAction;

  /// No description provided for @data.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get data;

  /// No description provided for @dataLoadingFailed.
  ///
  /// In en, this message translates to:
  /// **'Data Loading Failed '**
  String get dataLoadingFailed;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get day;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @editRecord.
  ///
  /// In en, this message translates to:
  /// **'Edit Record'**
  String get editRecord;

  /// No description provided for @fullDay.
  ///
  /// In en, this message translates to:
  /// **'Full Day'**
  String get fullDay;

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'Hours'**
  String get hours;

  /// No description provided for @hoursUnit.
  ///
  /// In en, this message translates to:
  /// **'{count,plural, =1{hour} other{hours}}'**
  String hoursUnit(int count);

  /// No description provided for @leave.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get leave;

  /// No description provided for @leaveHours.
  ///
  /// In en, this message translates to:
  /// **'Leave Hours'**
  String get leaveHours;

  /// No description provided for @manualEntry.
  ///
  /// In en, this message translates to:
  /// **'Manual Entry'**
  String get manualEntry;

  /// No description provided for @minutesUnit.
  ///
  /// In en, this message translates to:
  /// **'{count,plural, =1{min} other{mins}}'**
  String minutesUnit(int count);

  /// No description provided for @noCompletedRecords.
  ///
  /// In en, this message translates to:
  /// **'No completed records this week'**
  String get noCompletedRecords;

  /// No description provided for @noLeave.
  ///
  /// In en, this message translates to:
  /// **'No Leave'**
  String get noLeave;

  /// No description provided for @noRecordForThisDay.
  ///
  /// In en, this message translates to:
  /// **'No record for this day'**
  String get noRecordForThisDay;

  /// No description provided for @notClockedIn.
  ///
  /// In en, this message translates to:
  /// **'Not Clocked In'**
  String get notClockedIn;

  /// No description provided for @out.
  ///
  /// In en, this message translates to:
  /// **'Out'**
  String get out;

  /// No description provided for @overtime.
  ///
  /// In en, this message translates to:
  /// **'Overtime'**
  String get overtime;

  /// No description provided for @overwriteExistingRecord.
  ///
  /// In en, this message translates to:
  /// **'Registering a full-day leave will overwrite your existing clock-in/out records for today, and this action cannot be undone.'**
  String get overwriteExistingRecord;

  /// No description provided for @permanentlyDelete.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete all of your clock-in records. Are you sure you want to continue?'**
  String get permanentlyDelete;

  /// No description provided for @selectDateToViewRecords.
  ///
  /// In en, this message translates to:
  /// **'Select a date to view records'**
  String get selectDateToViewRecords;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @shortage.
  ///
  /// In en, this message translates to:
  /// **'Shortage'**
  String get shortage;

  /// No description provided for @showWeekend.
  ///
  /// In en, this message translates to:
  /// **'Show Weekend'**
  String get showWeekend;

  /// No description provided for @sureToDeleteRecord.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this record? This action cannot be undone.'**
  String get sureToDeleteRecord;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @takeLeave.
  ///
  /// In en, this message translates to:
  /// **'Take Leave'**
  String get takeLeave;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @workIn.
  ///
  /// In en, this message translates to:
  /// **'In'**
  String get workIn;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
