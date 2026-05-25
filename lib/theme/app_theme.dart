import 'package:flutter/material.dart';
import 'package:flutter_haiku/theme/color_palettes.dart';

class AppTheme {
  final Palette palette;

  AppTheme(this.palette);

  ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: palette.primary,
      scaffoldBackgroundColor: palette.backgroundLight,
      cardColor: palette.cardLight,
      appBarTheme: AppBarTheme(
        backgroundColor: palette.cardLight,
        foregroundColor: palette.textLightPrimary,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardTheme(
        color: palette.cardLight,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: palette.primary,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: palette.cardLight,
        selectedItemColor: palette.primary,
        unselectedItemColor: palette.textLightSecondary,
        elevation: 8,
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: palette.textLightPrimary),
        bodyMedium: TextStyle(color: palette.textLightSecondary),
      ),
      colorScheme: ColorScheme.light(
        primary: palette.primary,
        secondary: palette.primary,
        surface: palette.cardLight,
        background: palette.backgroundLight,
        error: palette.expense,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: palette.textLightPrimary,
        onBackground: palette.textLightPrimary,
        onError: Colors.white,
        brightness: Brightness.light,
      ),
    );
  }

  ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: palette.primary,
      scaffoldBackgroundColor: palette.backgroundDark,
      cardColor: palette.cardDark,
      appBarTheme: AppBarTheme(
        backgroundColor: palette.backgroundDark,
        foregroundColor: palette.textDarkPrimary,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardTheme(
        color: palette.cardDark,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: palette.primary,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: palette.cardDark,
        selectedItemColor: palette.primary,
        unselectedItemColor: palette.textDarkSecondary,
        elevation: 8,
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: palette.textDarkPrimary),
        bodyMedium: TextStyle(color: palette.textDarkSecondary),
      ),
      colorScheme: ColorScheme.dark(
        primary: palette.primary,
        secondary: palette.primary,
        surface: palette.cardDark,
        background: palette.backgroundDark,
        error: palette.expense,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: palette.textDarkPrimary,
        onBackground: palette.textDarkPrimary,
        onError: Colors.white,
        brightness: Brightness.dark,
      ),
    );
  }
}
