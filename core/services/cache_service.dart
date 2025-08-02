import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  static const String _userProgressKey = 'user_progress';
  static const String _userDataKey = 'user_data';
  static const String _settingsKey = 'app_settings';

  // Save user progress
  Future<void> saveUserProgress(Map<String, dynamic> progress) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = json.encode(progress);
      await prefs.setString(_userProgressKey, jsonString);
    } catch (e) {
      throw Exception('Failed to save user progress: $e');
    }
  }

  // Load user progress
  Future<Map<String, dynamic>?> loadUserProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_userProgressKey);
      if (jsonString != null) {
        return json.decode(jsonString) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      throw Exception('Failed to load user progress: $e');
    }
  }

  // Save user data
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = json.encode(userData);
      await prefs.setString(_userDataKey, jsonString);
    } catch (e) {
      throw Exception('Failed to save user data: $e');
    }
  }

  // Load user data
  Future<Map<String, dynamic>?> loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_userDataKey);
      if (jsonString != null) {
        return json.decode(jsonString) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      throw Exception('Failed to load user data: $e');
    }
  }

  // Save app settings
  Future<void> saveSettings(Map<String, dynamic> settings) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = json.encode(settings);
      await prefs.setString(_settingsKey, jsonString);
    } catch (e) {
      throw Exception('Failed to save settings: $e');
    }
  }

  // Load app settings
  Future<Map<String, dynamic>?> loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_settingsKey);
      if (jsonString != null) {
        return json.decode(jsonString) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      throw Exception('Failed to load settings: $e');
    }
  }

  // Clear all cached data
  Future<void> clearAllCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (e) {
      throw Exception('Failed to clear cache: $e');
    }
  }

  // Clear specific cache key
  Future<void> clearCacheKey(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(key);
    } catch (e) {
      throw Exception('Failed to clear cache key $key: $e');
    }
  }
}
