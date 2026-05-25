import 'package:flutter/material.dart';
import 'package:flutter_haiku/theme/color_palettes.dart';
import 'package:google_fonts/google_fonts.dart';

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
        backgroundColor: Colors.transparent,
        foregroundColor: palette.textLightPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.playfairDisplay(
          color: palette.textLightPrimary,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        color: palette.cardLight,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: palette.primary,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: palette.cardLight.withOpacity(0.9),
        selectedItemColor: palette.primary,
        unselectedItemColor: palette.textLightSecondary,
        elevation: 0,
        selectedLabelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.inter(fontSize: 12),
      ),
      textTheme: GoogleFonts.interTextTheme(
        TextTheme(
          bodyLarge: TextStyle(color: palette.textLightPrimary),
          bodyMedium: TextStyle(color: palette.textLightSecondary),
          titleLarge: GoogleFonts.playfairDisplay(color: palette.textLightPrimary, fontWeight: FontWeight.w700),
          titleMedium: GoogleFonts.playfairDisplay(color: palette.textLightPrimary, fontWeight: FontWeight.w600),
        ),
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
        backgroundColor: Colors.transparent,
        foregroundColor: palette.textDarkPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.playfairDisplay(
          color: palette.textDarkPrimary,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        color: palette.cardDark,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: palette.primary,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: palette.cardDark.withOpacity(0.9),
        selectedItemColor: palette.primary,
        unselectedItemColor: palette.textDarkSecondary,
        elevation: 0,
        selectedLabelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.inter(fontSize: 12),
      ),
      textTheme: GoogleFonts.interTextTheme(
        TextTheme(
          bodyLarge: TextStyle(color: palette.textDarkPrimary),
          bodyMedium: TextStyle(color: palette.textDarkSecondary),
          titleLarge: GoogleFonts.playfairDisplay(color: palette.textDarkPrimary, fontWeight: FontWeight.w700),
          titleMedium: GoogleFonts.playfairDisplay(color: palette.textDarkPrimary, fontWeight: FontWeight.w600),
        ),
      ).apply(bodyColor: palette.textDarkPrimary, displayColor: palette.textDarkPrimary),
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
