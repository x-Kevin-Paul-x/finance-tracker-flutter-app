import 'package:flutter/material.dart';

// Defines a collection of color palettes for the app theme.
// Updated for a more muted, sophisticated, and artistic aesthetic.
class AppPalettes {
  // The default color palette (Muted Purple)
  static const Palette defaultPalette = Palette(
    name: 'Twilight',
    primary: Color(0xFF7B61FF), // Softer purple
    backgroundLight: Color(0xFFF8F9FA), // Off-white, softer than pure white
    backgroundDark: Color(0xFF0F0E17), // Deep charcoal/blue-black
    cardLight: Color(0xFFFFFFFF),
    cardDark: Color(0xFF16161E), // Slightly lighter than background, very subtle
    textLightPrimary: Color(0xFF2D3142), // Not quite black
    textDarkPrimary: Color(0xFFE0E6ED), // Soft white
    textLightSecondary: Color(0xFF9098A9),
    textDarkSecondary: Color(0xFF8A93A6),
    income: Color(0xFF34D399), // Muted emerald
    expense: Color(0xFFFB7185), // Soft rose/coral
  );

  // A green-themed color palette (Sage/Earthy)
  static const Palette greenPalette = Palette(
    name: 'Sage',
    primary: Color(0xFF5CA482), // Sage green
    backgroundLight: Color(0xFFF4F7F6), // Very light greenish-grey
    backgroundDark: Color(0xFF111413), // Deep forest black
    cardLight: Color(0xFFFFFFFF),
    cardDark: Color(0xFF1A1F1D),
    textLightPrimary: Color(0xFF2C3E38),
    textDarkPrimary: Color(0xFFE2E8F0),
    textLightSecondary: Color(0xFF8BA39A),
    textDarkSecondary: Color(0xFF718096),
    income: Color(0xFF5CA482),
    expense: Color(0xFFE07A5F), // Terracotta
  );

  // A blue-themed color palette (Ocean/Mist)
  static const Palette bluePalette = Palette(
    name: 'Mist',
    primary: Color(0xFF5E81AC), // Nordic blue
    backgroundLight: Color(0xFFF5F7FA), // Light cool grey
    backgroundDark: Color(0xFF141824), // Deep navy
    cardLight: Color(0xFFFFFFFF),
    cardDark: Color(0xFF1C2130),
    textLightPrimary: Color(0xFF2E3440),
    textDarkPrimary: Color(0xFFECEFF4),
    textLightSecondary: Color(0xFF8A98B0),
    textDarkSecondary: Color(0xFF7A869A),
    income: Color(0xFF81A1C1), // Soft blue-green
    expense: Color(0xFFBF616A), // Muted red
  );

  // A list of all available color palettes.
  static const List<Palette> allPalettes = [
    defaultPalette,
    greenPalette,
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
