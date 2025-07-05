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
        backgroundColor: WidgetStateProperty.all<Color>(ColorCode.primaryColor),
        foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
        padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
          EdgeInsets.symmetric(horizontal: 16),
        ),
        elevation: WidgetStateProperty.all<double>(2),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    ),
  );
}
