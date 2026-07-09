import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persists the user's light/dark preference across launches, toggled from
/// the Profile screen.
class ThemeProvider extends ChangeNotifier {
  static const _prefsKey = 'theme_mode';

  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString(_prefsKey) == 'dark') {
      _themeMode = ThemeMode.dark;
      notifyListeners();
    }
  }

  Future<void> setDarkMode(bool value) async {
    _themeMode = value ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, value ? 'dark' : 'light');
  }
}
