import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pocketflow/theme/color_palettes.dart';
import 'package:pocketflow/theme/app_theme.dart';

class ThemeProvider with ChangeNotifier {
  static const String _themeModeKey = 'themeMode';
  static const String _paletteNameKey = 'paletteName';

  ThemeMode _themeMode = ThemeMode.system;
  Palette _palette = AppPalettes.defaultPalette;

  ThemeMode get themeMode => _themeMode;
  Palette get palette => _palette;

  ThemeData get currentTheme {
    final brightness = _themeMode == ThemeMode.system
        ? WidgetsBinding.instance.window.platformBrightness
        : _themeMode == ThemeMode.dark
            ? Brightness.dark
            : Brightness.light;
    return brightness == Brightness.dark
        ? AppTheme(_palette).darkTheme
        : AppTheme(_palette).lightTheme;
  }

  ThemeProvider() {
    _loadTheme();
  }

  void setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeModeKey, mode.index);
    notifyListeners();
  }

  void setPalette(Palette newPalette) async {
    _palette = newPalette;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_paletteNameKey, newPalette.name);
    notifyListeners();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_themeModeKey) ?? ThemeMode.system.index;
    final paletteName =
        prefs.getString(_paletteNameKey) ?? AppPalettes.defaultPalette.name;

    _themeMode = ThemeMode.values[themeIndex];
    _palette = AppPalettes.allPalettes.firstWhere(
      (p) => p.name == paletteName,
      orElse: () => AppPalettes.defaultPalette,
    );
    notifyListeners();
  }
}
