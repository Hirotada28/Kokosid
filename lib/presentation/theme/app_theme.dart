import 'package:flutter/material.dart';

/// アプリケーションテーマ
class AppTheme {
  // カラーパレット
  static const Color primaryColor = Color(0xFF6B73FF);
  static const Color secondaryColor = Color(0xFF9C27B0);
  static const Color accentColor = Color(0xFFFF6B6B);
  static const Color backgroundColor = Color(0xFFF8F9FA);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color errorColor = Color(0xFFE57373);
  static const Color successColor = Color(0xFF81C784);
  static const Color warningColor = Color(0xFFFFB74D);

  // テキストカラー
  static const Color textPrimary = Color(0xFF2D3748);
  static const Color textSecondary = Color(0xFF718096);
  static const Color textDisabled = Color(0xFFA0AEC0);

  /// ライトテーマ
  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          primary: primaryColor,
          secondary: secondaryColor,
          error: errorColor,
          background: backgroundColor,
          surface: surfaceColor,
        ),

        // AppBar
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          iconTheme: IconThemeData(color: textPrimary),
        ),

        // BottomNavigationBar
        bottomNavigationBarTheme: const BottomNavigationBarTheme(
          backgroundColor: surfaceColor,
          selectedItemColor: primaryColor,
          unselectedItemColor: textSecondary,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
        ),

        // Card
        cardTheme: CardTheme(
          color: surfaceColor,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),

        // ElevatedButton
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),

        // TextButton
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),

        // InputDecoration
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: backgroundColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: primaryColor, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: errorColor),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),

        // Typography
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            color: textPrimary,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
          displayMedium: TextStyle(
            color: textPrimary,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
          displaySmall: TextStyle(
            color: textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
          headlineLarge: TextStyle(
            color: textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
          headlineMedium: TextStyle(
            color: textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          headlineSmall: TextStyle(
            color: textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          titleLarge: TextStyle(
            color: textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          titleMedium: TextStyle(
            color: textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          titleSmall: TextStyle(
            color: textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          bodyLarge: TextStyle(
            color: textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
          bodyMedium: TextStyle(
            color: textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
          bodySmall: TextStyle(
            color: textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.normal,
          ),
        ),
      );

  /// ダークテーマ
  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          brightness: Brightness.dark,
          primary: primaryColor,
          secondary: secondaryColor,
          error: errorColor,
          background: const Color(0xFF121212),
          surface: const Color(0xFF1E1E1E),
        ),

        // 基本的にライトテーマと同じ構造だが、色を調整
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
      );
}
