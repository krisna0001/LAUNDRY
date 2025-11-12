import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService extends GetxService {
  static const String _themeKey = 'isDarkMode';
  late SharedPreferences _prefs;

  final isDarkMode = false.obs;

  Future<ThemeService> init() async {
    _prefs = await SharedPreferences.getInstance();
    await loadTheme();
    return this;
  }

  Future<void> saveTheme(bool darkMode) async {
    isDarkMode.value = darkMode;
    await _prefs.setBool(_themeKey, darkMode);
    Get.changeThemeMode(darkMode ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> loadTheme() async {
    isDarkMode.value = _prefs.getBool(_themeKey) ?? false;
  }

  ThemeData getLightTheme() {
    return ThemeData(
      primarySwatch: Colors.blue,
      primaryColor: const Color(0xFF005f9f),
      brightness: Brightness.light,
      useMaterial3: true,
    );
  }

  ThemeData getDarkTheme() {
    return ThemeData(
      primarySwatch: Colors.blue,
      primaryColor: const Color(0xFF005f9f),
      brightness: Brightness.dark,
      useMaterial3: true,
    );
  }
}
