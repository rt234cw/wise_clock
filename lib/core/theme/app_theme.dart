import 'package:flutter/material.dart';

const ColorScheme darkColorScheme = ColorScheme(
  brightness: Brightness.dark,

  // --- 核心品牌色 ---
  primary: Color(0xffFFEED0), // 主要品牌色 (暖米色)，用於最重要的操作，如按鈕、活動分頁。
  onPrimary: Color(0xFF1A1A1A), // 在 Primary 顏色之上的內容 (文字/圖示)。
  secondary: Color(0xFFD8C0A9), // 次要品牌色 (淺駝色)，用於次要按鈕、滑桿、高亮。
  onSecondary: Color(0xFF1A1A1A), // 在 Secondary 顏色之上的內容。

  secondaryContainer: Color(0xFF4A443F),

  // --- 新增的輔助色 (Accent) ---
  tertiary: Color(0xFF8A9AAB), // 輔助色 (灰藍色)，用於不那麼重要的圖示、標籤，增加視覺層次。
  onTertiary: Color(0xFFFFFFFF), // 在 Tertiary 顏色之上的內容。

  // --- 表面與背景色 ---
  surface: Color(0xFF1A1A1A), // App 的最底層背景色。
  onSurface: Color(0xffFFEED0), // 在 Surface 之上的主要文字顏色。
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
        size: 20,
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
            foregroundColor: WidgetStateProperty.all(colorScheme.onSurface),
            // 移除點擊時的覆蓋顏色
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 16, vertical: 8))),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          // 文字顏色使用次要強調色
          foregroundColor: WidgetStateProperty.all(colorScheme.onSurface),
          // 移除點擊時的覆蓋顏色
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          padding: WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 0, vertical: 4),
          ),
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
