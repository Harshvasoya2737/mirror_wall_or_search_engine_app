import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  int _themeMode = 0;

  ThemeProvider() {
    _loadThemePreference();
  }

  int get themeMode => _themeMode;

  ThemeMode getThemeMode() {
    if (_themeMode == 1) {
      return ThemeMode.light;
    } else if (_themeMode == 2) {
      return ThemeMode.dark;
    } else {
      return ThemeMode.system;
    }
  }

  void _loadThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _themeMode = prefs.getInt('themeMode') ?? 0;
    notifyListeners();
  }

  void changeTheme(int type) async {
    _themeMode = type;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeMode', _themeMode);
    notifyListeners();
  }
}
