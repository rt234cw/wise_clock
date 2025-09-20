import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../generated/l10n.dart';

class LocaleProvider extends ChangeNotifier {
  Locale? _locale;

  Locale? get locale => _locale;

  Future<void> loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString("languageCode");
    if (languageCode != null) {
      // --- 情況一：使用者之前儲存過設定 ---
      _locale = Locale(languageCode);
    } else {
      // --- 情況二：使用者是第一次開啟 App，沒有儲存的設定 ---
      // 1. 獲取手機當前的系統語言
      final systemLocale = PlatformDispatcher.instance.locale;

      // 2. 檢查系統語言是否在我們支援的列表中
      if (S.delegate.isSupported(systemLocale)) {
        _locale = systemLocale;
      } else {
        // 3. 如果不支援，就 fallback 到預設語言（例如英文）
        _locale = const Locale('en');
      }
    }
  }

  Future<void> setLocale(Locale newLocale) async {
    // 如果語系沒有變化，就不做任何事

    if (_locale == newLocale) return;
    _locale = newLocale;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', newLocale.languageCode);
  }
}
