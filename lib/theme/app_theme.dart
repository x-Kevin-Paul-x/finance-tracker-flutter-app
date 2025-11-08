import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFF6B4CE6);
  static const Color primaryLight = Color(0xFF8C74FF);
  static const Color income = Color(0xFF10B981);
  static const Color expense = Color(0xFFEF4444);

  static final Gradient primaryGradient = const LinearGradient(
    colors: [Color(0xFF6B4CE6), Color(0xFF8C74FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primary,
    scaffoldBackgroundColor: const Color(0xFFF6F7FB),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black87,
      elevation: 0,
      centerTitle: true,
    ),
    cardTheme: CardTheme(
      color: Colors.white.withOpacity(0.9),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primary,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: primary,
      unselectedItemColor: Colors.grey,
      elevation: 8,
    ),
    colorScheme: ColorScheme.fromSeed(seedColor: primary),
  );
}
