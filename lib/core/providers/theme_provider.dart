import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.light) {
    _loadThemeMode();
  }

  static const String _key = 'theme_mode';

  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeIndex = prefs.getInt(_key) ?? 0;
    state = ThemeMode.values[themeModeIndex];
  }

  Future<void> toggleTheme() async {
    final newThemeMode = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    state = newThemeMode;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_key, newThemeMode.index);
  }
}
