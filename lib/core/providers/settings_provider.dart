import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  static const String _showWeekendKey = "show_weekend";
  static const String _fixedSixWeeksKey = "fixed_six_weeks";

  bool _showWeekend = false;
  bool _showSixWeeks = false;

  bool get showWeekend => _showWeekend;
  bool get showSixWeeks => _showSixWeeks;

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _showWeekend = prefs.getBool(_showWeekendKey) ?? false;
    _showSixWeeks = prefs.getBool(_fixedSixWeeksKey) ?? false;
  }

  Future<void> setShowWeekend(bool value) async {
    if (_showWeekend == value) return;

    _showWeekend = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_showWeekendKey, value);
  }

  Future<void> setFixedSixWeeks(bool value) async {
    if (_showSixWeeks == value) return;

    _showSixWeeks = value;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_fixedSixWeeksKey, value);
  }
}
