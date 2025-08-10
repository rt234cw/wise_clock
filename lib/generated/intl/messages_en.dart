// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static String m0(count) =>
      "${Intl.plural(count, one: 'hour', other: 'hours')}";

  static String m1(count) => "${Intl.plural(count, one: 'min', other: 'mins')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "abbreHour": MessageLookupByLibrary.simpleMessage("H"),
    "abbreMinute": MessageLookupByLibrary.simpleMessage("m"),
    "accumulatedHours": MessageLookupByLibrary.simpleMessage("Weekly Hours"),
    "addNewRecord": MessageLookupByLibrary.simpleMessage("Add New Record"),
    "adjust": MessageLookupByLibrary.simpleMessage("Adjust"),
    "areYouSureOverwrite": MessageLookupByLibrary.simpleMessage(
      "Are you sure to overwirte existing record?",
    ),
    "balanced": MessageLookupByLibrary.simpleMessage("Balanced"),
    "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "clear": MessageLookupByLibrary.simpleMessage("Clear"),
    "clearAll": MessageLookupByLibrary.simpleMessage("Clear All"),
    "clearAllRecords": MessageLookupByLibrary.simpleMessage(
      "Clear All Records",
    ),
    "clockIn": MessageLookupByLibrary.simpleMessage("Clock In"),
    "clockInNow": MessageLookupByLibrary.simpleMessage("Clock In Now"),
    "clockInTime": MessageLookupByLibrary.simpleMessage("Clock In Time"),
    "clockOutTime": MessageLookupByLibrary.simpleMessage("Clock Out Time"),
    "close": MessageLookupByLibrary.simpleMessage("Close"),
    "confirm": MessageLookupByLibrary.simpleMessage("Confirm"),
    "confirmAction": MessageLookupByLibrary.simpleMessage("Confirm Action"),
    "dataLoadingFailed": MessageLookupByLibrary.simpleMessage(
      "Data Loading Failed ",
    ),
    "day": MessageLookupByLibrary.simpleMessage("Day"),
    "editRecord": MessageLookupByLibrary.simpleMessage("Edit Record"),
    "fullDay": MessageLookupByLibrary.simpleMessage("Full Day"),
    "hours": MessageLookupByLibrary.simpleMessage("Hours"),
    "hoursUnit": m0,
    "leave": MessageLookupByLibrary.simpleMessage("Leave"),
    "leaveHours": MessageLookupByLibrary.simpleMessage("Leave Hours"),
    "manualEntry": MessageLookupByLibrary.simpleMessage("Manual Entry"),
    "minutesUnit": m1,
    "noCompletedRecords": MessageLookupByLibrary.simpleMessage(
      "No completed records this week",
    ),
    "noLeave": MessageLookupByLibrary.simpleMessage("No Leave"),
    "noRecordForThisDay": MessageLookupByLibrary.simpleMessage(
      "No record for this day",
    ),
    "notClockedIn": MessageLookupByLibrary.simpleMessage("Not Clocked In"),
    "out": MessageLookupByLibrary.simpleMessage("Out"),
    "overtime": MessageLookupByLibrary.simpleMessage("Overtime"),
    "overwriteExistingRecord": MessageLookupByLibrary.simpleMessage(
      "Registering a full-day leave will overwrite your existing clock-in/out records for today, and this action cannot be undone.",
    ),
    "permanentlyDelete": MessageLookupByLibrary.simpleMessage(
      "This will permanently delete all of your clock-in records. Are you sure you want to continue?",
    ),
    "selectDateToViewRecords": MessageLookupByLibrary.simpleMessage(
      "Select a date to view records",
    ),
    "selectLanguage": MessageLookupByLibrary.simpleMessage("Select Language"),
    "settings": MessageLookupByLibrary.simpleMessage("Settings"),
    "shortage": MessageLookupByLibrary.simpleMessage("Shortage"),
    "sureToDeleteRecord": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to delete this record? This action cannot be undone.",
    ),
    "takeLeave": MessageLookupByLibrary.simpleMessage("Take Leave"),
    "today": MessageLookupByLibrary.simpleMessage("Today"),
    "update": MessageLookupByLibrary.simpleMessage("Update"),
    "workIn": MessageLookupByLibrary.simpleMessage("In"),
  };
}
