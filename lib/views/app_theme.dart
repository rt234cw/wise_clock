import 'package:flutter/material.dart';

import '../color_scheme/color_code.dart';

final class MyTheme {
  static final theme = ThemeData(
    splashFactory: NoSplash.splashFactory,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    iconTheme: IconThemeData(
      color: ColorCode.primaryColor,
      size: 24,
    ),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        iconColor: WidgetStateProperty.all<Color>(ColorCode.primaryColor),
        iconSize: WidgetStateProperty.all<double>(24),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      contentPadding: EdgeInsets.all(4),
      filled: false,
      fillColor: ColorCode.bgColor,
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        // ✨ 關鍵修正：明確地將 TextButton 的覆蓋顏色設為透明
        overlayColor: WidgetStateProperty.all(Colors.transparent),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        // ✨ Use resolveWith to handle different states
        backgroundColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            // If the button is disabled, return a grey color
            if (states.contains(WidgetState.disabled)) {
              return Colors.grey.shade300; // Disabled background color
            }
            // For all other states (pressed, hovered, focused, etc.), return the primary color
            return ColorCode.primaryColor; // Default background color
          },
        ),
        // ✨ Do the same for the foreground (text/icon) color
        foregroundColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return Colors.grey.shade500; // Disabled foreground color
            }
            return Colors.white; // Default foreground color
          },
        ),
        elevation: WidgetStateProperty.resolveWith<double?>(
          (Set<WidgetState> states) {
            // Disabled buttons should have no shadow/elevation
            if (states.contains(WidgetState.disabled)) {
              return 0;
            }
            return 2; // Default elevation
          },
        ),
        side: WidgetStateProperty.all(BorderSide.none),
        // ✨ 關鍵修正：將覆蓋顏色也設為透明，徹底根除所有點擊效果
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
          const EdgeInsets.symmetric(horizontal: 16),
        ),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    ),
  );
}
