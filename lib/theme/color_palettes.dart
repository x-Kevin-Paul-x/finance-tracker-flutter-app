import 'package:flutter/material.dart';

// Defines the 3 core artistic styles for the app:
// 1. Art Nouveau (Jaipur Base)
// 2. Royal Peacock Style
// 3. Chola Tamil Style
class AppPalettes {
  // 1. Base / Default: Jaipur Art Nouveau Theme
  static const Palette nouveauStyle = Palette(
    name: 'Art Nouveau Style',
    subtitle: 'Jaipur Gold & Terracotta Fine Art',
    primary: Color(0xFFC85A17), // Terracotta Spice
    accentColor: Color(0xFFD4AF37), // Royal Gold
    backgroundLight: Color(0xFFFAF6EE),
    backgroundDark: Color(0xFF0F0B09),
    cardLight: Color(0xFFFFFFFF),
    cardDark: Color(0xFF1B1411), // Obsidian Velvet
    textLightPrimary: Color(0xFF2B1D18),
    textDarkPrimary: Color(0xFFFFFFFF),
    textLightSecondary: Color(0xFF8C7164),
    textDarkSecondary: Color(0xFFD4C5B9),
    income: Color(0xFF107C41),
    expense: Color(0xFFC0392B),
    darkBgAsset: 'assets/images/art_nouveau_app_bg.jpg',
    lightBgAsset: 'assets/images/art_nouveau_light_bg.jpg',
    buttonGradient: LinearGradient(
      colors: [Color(0xFFD95F1E), Color(0xFFB7410E), Color(0xFF8B2B05)],
    ),
    goldBorderColor: Color(0xFFD4AF37),
    gradientFallbackDark: [Color(0xFF1E140F), Color(0xFF120C0A), Color(0xFF0A0706)],
    gradientFallbackLight: [Color(0xFFFAF6F0), Color(0xFFF3EBE1), Color(0xFFE8DCCF)],
  );

  // 2. Royal Peacock Style (Teal, Cyan Glow & Gold)
  static const Palette peacockStyle = Palette(
    name: 'Royal Peacock Style',
    subtitle: 'Deep Peacock Teal & Saffron Gold',
    primary: Color(0xFF0F5257), // Peacock Teal
    accentColor: Color(0xFF00E5FF), // Peacock Cyan Glow
    backgroundLight: Color(0xFFF2F9F9),
    backgroundDark: Color(0xFF091417),
    cardLight: Color(0xFFFFFFFF),
    cardDark: Color(0xFF102025), // Peacock Dark Velvet
    textLightPrimary: Color(0xFF0D2529),
    textDarkPrimary: Color(0xFFE2F8FA),
    textLightSecondary: Color(0xFF5A7B82),
    textDarkSecondary: Color(0xFF8BB5BD),
    income: Color(0xFF00BFA5), // Peacock Emerald
    expense: Color(0xFFE65100), // Saffron Fire
    darkBgAsset: 'assets/images/peacock_teal_dark_bg.jpg',
    lightBgAsset: 'assets/images/peacock_teal_light_bg.jpg',
    buttonGradient: LinearGradient(
      colors: [Color(0xFF00838F), Color(0xFF005662), Color(0xFF002F35)],
    ),
    goldBorderColor: Color(0xFF00E5FF),
    gradientFallbackDark: [Color(0xFF0F2B30), Color(0xFF0A1C20), Color(0xFF050E10)],
    gradientFallbackLight: [Color(0xFFE0F7FA), Color(0xFFB2EBF2), Color(0xFF80DEEA)],
  );

  // 3. Chola Tamil Style (Deep Kanchipuram Silk Maroon, Tanjore Temple Garnet & Pure Gold)
  static const Palette cholaStyle = Palette(
    name: 'Chola Tamil Style',
    subtitle: 'Deep Kanchipuram Crimson & Tanjore Temple Gold',
    primary: Color(0xFF9E1B32), // Tanjore Ruby Crimson
    accentColor: Color(0xFFFFD700), // Pure Tanjore Temple Gold
    backgroundLight: Color(0xFFFFF0F3), // Soft Kanchipuram Silk Ivory
    backgroundDark: Color(0xFF120508), // Deep Chola Temple Velvet
    cardLight: Color(0xFFFFFDF8), // High Contrast Solid Light Velvet
    cardDark: Color(0xFF220A10), // Chola Velvet Card Surface
    textLightPrimary: Color(0xFF3B0812), // Deep Garnet Text
    textDarkPrimary: Color(0xFFFFF0F3),
    textLightSecondary: Color(0xFF8C4B57),
    textDarkSecondary: Color(0xFFE5B5BD),
    income: Color(0xFF1B5E20), // Tamil Emerald Green
    expense: Color(0xFFB71C1C), // Temple Red
    darkBgAsset: 'assets/images/chola_tamil_dark_bg.jpg',
    lightBgAsset: 'assets/images/chola_tamil_light_bg.jpg',
    buttonGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFC62828), Color(0xFF880E4F), Color(0xFF4A0007)],
    ),
    goldBorderColor: Color(0xFFFFD700), // Pure Tanjore Gold
    gradientFallbackDark: [Color(0xFF3D0611), Color(0xFF200308), Color(0xFF0E0103)],
    gradientFallbackLight: [Color(0xFFFFF0F3), Color(0xFFFCE4EC), Color(0xFFF8BBD0)],
  );

  // Alias default to Art Nouveau Style
  static const Palette defaultPalette = nouveauStyle;

  static const List<Palette> allPalettes = [
    nouveauStyle,
    peacockStyle,
    cholaStyle,
  ];
}

// Represents a single color palette with specific shades, assets & fallback gradients.
@immutable
class Palette {
  const Palette({
    required this.name,
    required this.subtitle,
    required this.primary,
    required this.accentColor,
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
    required this.darkBgAsset,
    required this.lightBgAsset,
    required this.buttonGradient,
    required this.goldBorderColor,
    required this.gradientFallbackDark,
    required this.gradientFallbackLight,
  });

  final String name;
  final String subtitle;
  final Color primary;
  final Color accentColor;
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
  final String darkBgAsset;
  final String lightBgAsset;
  final LinearGradient buttonGradient;
  final Color goldBorderColor;
  final List<Color> gradientFallbackDark;
  final List<Color> gradientFallbackLight;
}
