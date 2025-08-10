// import 'package:flutter/material.dart';

// import '../color_scheme/color_code.dart';

// final class MyTheme {
//   static final theme = ThemeData(
//     colorScheme: ColorScheme(
//       // 亮度設定為 dark，表示這是一個深色主題
//       brightness: Brightness.dark,

//       // 主要顏色，用於品牌突顯，如 AppBar、FloatingActionButton 等
//       primary: Color(0xFFF2E4CE),

//       // 在主要顏色之上的文字或圖示顏色
//       // 因為 primary 是淺色，所以 onPrimary 使用深色以確保對比度
//       onPrimary: Color(0xFF1A1A1A),

//       // 次要顏色，用於次要元件或作為強調色的補充
//       // 這裡選用一個比 primary 稍深、飽和度稍高的顏色，保持色調和諧
//       secondary: Color(0xFFD8C0A9),

//       // 在次要顏色之上的文字或圖示顏色
//       // 同樣地，onSecondary 使用深色以確保對比度
//       onSecondary: Color(0xFF1A1A1A),

//       // 錯誤提示顏色，用於表示錯誤狀態，如輸入框驗證失敗
//       // 採用 Material Design 在深色主題中推薦的柔和紅色
//       error: Color(0xFFCF6679),

//       // 在錯誤顏色之上的文字或圖示顏色
//       onError: Color(0xFF1A1A1A),

//       // 元件的表面顏色，如 Card、Dialog、BottomSheet 的背景
//       // 直接使用您指定的 App 背景色
//       surface: Color(0xFF1A1A1A),

//       // 在表面顏色之上的文字或圖示顏色
//       // 這是 App 中最主要的文字顏色，使用您的主視覺色，確保可讀性
//       onSurface: Color(0xFFF2E4CE),

//       // 您也可以根據需求定義其他顏色
//       // background: Color(0xFF1A1A1A),
//       // onBackground: Color(0xFFF2E4CE),
//     ),
//     splashFactory: NoSplash.splashFactory,
//     splashColor: Colors.transparent,
//     highlightColor: Colors.transparent,
//     iconTheme: IconThemeData(
//       color: ColorCode.primaryColor,
//       size: 24,
//     ),
//     iconButtonTheme: IconButtonThemeData(
//       style: ButtonStyle(
//         iconColor: WidgetStateProperty.all<Color>(ColorCode.primaryColor),
//         iconSize: WidgetStateProperty.all<double>(24),
//       ),
//     ),
//     inputDecorationTheme: InputDecorationTheme(
//       border: InputBorder.none,
//       enabledBorder: InputBorder.none,
//       focusedBorder: InputBorder.none,
//       contentPadding: EdgeInsets.all(4),
//       filled: false,
//       fillColor: ColorCode.bgColor,
//     ),
//     textButtonTheme: TextButtonThemeData(
//       style: ButtonStyle(
//         // 將 TextButton 的覆蓋顏色設為透明
//         overlayColor: WidgetStateProperty.all(Colors.transparent),
//       ),
//     ),
//     elevatedButtonTheme: ElevatedButtonThemeData(
//       style: ButtonStyle(
//         //  Use resolveWith to handle different states
//         backgroundColor: WidgetStateProperty.resolveWith<Color?>(
//           (Set<WidgetState> states) {
//             // If the button is disabled, return a grey color
//             if (states.contains(WidgetState.disabled)) {
//               return Colors.grey.shade300; // Disabled background color
//             }
//             // For all other states (pressed, hovered, focused, etc.), return the primary color
//             return ColorCode.primaryColor; // Default background color
//           },
//         ),
//         //  Do the same for the foreground (text/icon) color
//         foregroundColor: WidgetStateProperty.resolveWith<Color?>(
//           (Set<WidgetState> states) {
//             if (states.contains(WidgetState.disabled)) {
//               return Colors.grey.shade500; // Disabled foreground color
//             }
//             return Colors.white; // Default foreground color
//           },
//         ),
//         elevation: WidgetStateProperty.resolveWith<double?>(
//           (Set<WidgetState> states) {
//             // Disabled buttons should have no shadow/elevation
//             if (states.contains(WidgetState.disabled)) {
//               return 0;
//             }
//             return 2; // Default elevation
//           },
//         ),
//         side: WidgetStateProperty.all(BorderSide.none),
//         // 將覆蓋顏色也設為透明，徹底根除所有點擊效果
//         overlayColor: WidgetStateProperty.all(Colors.transparent),
//         padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
//           const EdgeInsets.symmetric(horizontal: 16),
//         ),
//         shape: WidgetStateProperty.all<RoundedRectangleBorder>(
//           RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(8),
//           ),
//         ),
//       ),
//     ),
//   );
// }

import 'package:flutter/material.dart';

const ColorScheme darkColorScheme = ColorScheme(
  brightness: Brightness.dark,

  // --- 核心品牌色 ---
  primary: Color(0xFFF2E4CE), // 主要品牌色 (暖米色)，用於最重要的操作，如按鈕、活動分頁。
  onPrimary: Color(0xFF1A1A1A), // 在 Primary 顏色之上的內容 (文字/圖示)。
  secondary: Color(0xFFD8C0A9), // 次要品牌色 (淺駝色)，用於次要按鈕、滑桿、高亮。
  onSecondary: Color(0xFF1A1A1A), // 在 Secondary 顏色之上的內容。

  secondaryContainer: Color(0xFF4A443F),

  // --- 新增的輔助色 (Accent) ---
  tertiary: Color(0xFF8A9AAB), // 輔助色 (灰藍色)，用於不那麼重要的圖示、標籤，增加視覺層次。
  onTertiary: Color(0xFFFFFFFF), // 在 Tertiary 顏色之上的內容。

  // --- 表面與背景色 ---
  surface: Color(0xFF1A1A1A), // App 的最底層背景色。
  onSurface: Color(0xFFF2E4CE), // 在 Surface 之上的主要文字顏色。
  surfaceContainer: Color(0xFF2C2C2C), // 容器背景 (如 Card)，比 surface 稍亮，創造層次感。
  onSurfaceVariant: Color(0xFFA9A9A9), // 在 Surface 之上的次要文字顏色 (如副標題、提示文字)。

  // --- 其他語意顏色 ---
  error: Color(0xFFCF6679), // 錯誤狀態顏色。
  onError: Color(0xFF1A1A1A), // 在 Error 顏色之上的內容。
);

final class MyTheme {
  static final ThemeData darkTheme = _buildTheme(darkColorScheme);
  static ThemeData _buildTheme(ColorScheme colorScheme) {
    return ThemeData(
      // 將我們定義好的 ColorScheme 賦予給主題
      colorScheme: colorScheme,

      // 讓 App 的預設背景色使用 surface 顏色
      scaffoldBackgroundColor: colorScheme.surface,

      // 移除點擊時的水波紋效果 (這是個人風格選擇，可以保留)
      splashFactory: NoSplash.splashFactory,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,

      // --- 元件樣式設定 ---

      cardTheme: CardThemeData(
        // 移除陰影，維持扁平化設計
        elevation: 0,
        // 設定卡片的背景顏色。使用 onSurface 搭配低透明度，
        // 可以在深色背景上創造一個和諧的、稍亮的層次感。
        color: const Color(0xFF2C2C2C),
        // 設定統一的圓角
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        // 設定預設的外邊距
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),

      // 設定預設的圖示主題
      iconTheme: IconThemeData(
        color: colorScheme.onSurface.withValues(alpha: .8), // 預設圖示使用主要文字色，帶一點透明度
        size: 24,
      ),

      // 設定 IconButton 的主題
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          // 讓 IconButton 的圖示顏色繼承自 colorScheme
          foregroundColor: WidgetStateProperty.all<Color>(colorScheme.onSurface),
          iconSize: WidgetStateProperty.all<double>(24),
          // 移除點擊時的覆蓋顏色
          overlayColor: WidgetStateProperty.all(Colors.transparent),
        ),
      ),

      // 設定輸入框 (TextField) 的主題
      inputDecorationTheme: InputDecorationTheme(
        // 預設無邊框
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        // 設定內容邊距
        contentPadding: const EdgeInsets.all(4),
        // 設定提示文字的顏色
        hintStyle: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.4)),
      ),

      // 設定文字按鈕 (TextButton) 的主題
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          // 文字顏色使用次要強調色
          foregroundColor: WidgetStateProperty.all(colorScheme.secondary),
          // 移除點擊時的覆蓋顏色
          overlayColor: WidgetStateProperty.all(Colors.transparent),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.disabled)) {
                // 禁用時的顏色與 ElevatedButton 保持一致
                return colorScheme.onSurface.withValues(alpha: 0.12);
              }
              // 預設狀態下，使用 secondary 顏色，作為次要但重要的操作按鈕
              return colorScheme.secondary;
            },
          ),
          foregroundColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.disabled)) {
                return colorScheme.onSurface.withValues(alpha: 0.38);
              }
              // 預設狀態下，使用 onSecondary 顏色
              return colorScheme.onSecondary;
            },
          ),
          elevation: WidgetStateProperty.all(0),
          padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
            const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),

      // 設定凸起按鈕 (ElevatedButton) 的主題
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.disabled)) {
                // 禁用時，使用表面顏色的輕微變體
                return colorScheme.onSurface.withValues(alpha: 0.12);
              }
              // 預設狀態下，使用 primary 顏色
              return colorScheme.primary;
            },
          ),
          foregroundColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.disabled)) {
                // 禁用時，文字顏色使用表面顏色的較淡變體
                return colorScheme.onSurface.withValues(alpha: 0.38);
              }
              // 預設狀態下，使用 onPrimary 顏色
              return colorScheme.onPrimary;
            },
          ),
          elevation: WidgetStateProperty.all(0), // 移除陰影
          padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
            const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
}
