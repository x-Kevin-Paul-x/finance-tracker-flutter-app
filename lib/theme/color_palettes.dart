import 'package:flutter/material.dart';

// Defines a collection of color palettes for the app theme.
class AppPalettes {
  // The default color palette.
  static const Palette defaultPalette = Palette(
    name: 'Default',
    primary: Color(0xFF5D3FD3),
    backgroundLight: Color(0xFFF4F6F8),
    backgroundDark: Color(0xFF141121),
    cardLight: Color(0xFFFFFFFF),
    cardDark: Color(0xFF1D192C),
    textLightPrimary: Color(0xFF1A1A1A),
    textDarkPrimary: Color(0xFFFFFFFF),
    textLightSecondary: Color(0xFF6c757d),
    textDarkSecondary: Color(0xFFa0aec0),
    income: Color(0xFF2ECC71),
    expense: Color(0xFFE74C3C),
  );

  // A green-themed color palette.
  static const Palette greenPalette = Palette(
    name: 'Green',
    primary: Color(0xFF48BB78),
    backgroundLight: Color(0xFFF7F8FA),
    backgroundDark: Color(0xFF141121),
    cardLight: Color(0xFFFFFFFF),
    cardDark: Color(0xFF1C182F),
    textLightPrimary: Color(0xFF2D3748),
    textDarkPrimary: Color(0xFFE2E8F0),
    textLightSecondary: Color(0xFFA0AEC0),
    textDarkSecondary: Color(0xFF718096),
    income: Color(0xFF48BB78),
    expense: Color(0xFFE53E3E),
  );

  // A purple-themed color palette.
  static const Palette purplePalette = Palette(
    name: 'Purple',
    primary: Color(0xFF6a4be7),
    backgroundLight: Color(0xFFf6f6f8),
    backgroundDark: Color(0xFF141121),
    cardLight: Color(0xFFFFFFFF),
    cardDark: Color(0xFF1f1a32),
    textLightPrimary: Color(0xFF1A1A1A),
    textDarkPrimary: Color(0xFFFFFFFF),
    textLightSecondary: Color(0xFF6c757d),
    textDarkSecondary: Color(0xFF9e94c7),
    income: Color(0xFF0bda6c),
    expense: Color(0xFFff5c5c),
  );

  // A blue-themed color palette.
  static const Palette bluePalette = Palette(
    name: 'Blue',
    primary: Color(0xFF4A90E2),
    backgroundLight: Color(0xFFF9F9F9),
    backgroundDark: Color(0xFF141121),
    cardLight: Color(0xFFFFFFFF),
    cardDark: Color(0xFF1d1933),
    textLightPrimary: Color(0xFF212121),
    textDarkPrimary: Color(0xFFFFFFFF),
    textLightSecondary: Color(0xFF888888),
    textDarkSecondary: Color(0xFF9e94c7),
    income: Color(0xFF50C878),
    expense: Color(0xFFE94E77),
  );

  // A list of all available color palettes.
  static const List<Palette> allPalettes = [
    defaultPalette,
    greenPalette,
    purplePalette,
    bluePalette,
  ];
}

// Represents a single color palette with specific shades for the app theme.
@immutable
class Palette {
  const Palette({
    required this.name,
    required this.primary,
    required this.backgroundLight,
    required this.backgroundDark,
    required this.cardLight,
    required this.cardDark,
    required this.textLightPrimary,
    required this.textDarkPrimary,
    required this.textLightSecondary,
    required this.textDarkSecondary,
    required this.income,
    required this.expense,
  });

  final String name;
  final Color primary;
  final Color backgroundLight;
  final Color backgroundDark;
  final Color cardLight;
  final Color cardDark;
  final Color textLightPrimary;
  final Color textDarkPrimary;
  final Color textLightSecondary;
  final Color textDarkSecondary;
  final Color income;
  final Color expense;
}
