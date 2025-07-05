import 'package:flutter/material.dart';

import '../color_scheme/color_code.dart';

final class MyTheme {
  static final theme = ThemeData(
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
    filledButtonTheme: FilledButtonThemeData(
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
