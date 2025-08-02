import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/user_progress_model.dart';
import '../data/models/user_model.dart';

class CacheService {
  static const String _userProgressKey = 'user_progress';
  static const String _userDataKey = 'user_data';
  static const String _languagesKey = 'languages_cache';
  static const String _coursesKey = 'courses_cache';

  // Save user progress
  Future<void> saveUserProgress(UserProgressModel progress) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final progressJson = json.encode(progress.toJson());
      await prefs.setString(_userProgressKey, progressJson);
    } catch (e) {
      print('Error saving user progress: $e');
    }
  }

  // Load user progress
  Future<UserProgressModel?> getUserProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final progressJson = prefs.getString(_userProgressKey);
      
      if (progressJson != null) {
        final progressData = json.decode(progressJson);
        return UserProgressModel.fromJson(progressData);
      }
      
      return _getDefaultUserProgress();
    } catch (e) {
      print('Error loading user progress: $e');
      return _getDefaultUserProgress();
    }
  }

  // Save user data
  Future<void> saveUserData(UserModel user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = json.encode(user.toJson());
      await prefs.setString(_userDataKey, userJson);
    } catch (e) {
      print('Error saving user data: $e');
    }
  }

  // Load user data
  Future<UserModel?> getUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userDataKey);
      
      if (userJson != null) {
        final userData = json.decode(userJson);
        return UserModel.fromJson(userData);
      }
      
      return _getDefaultUser();
    } catch (e) {
      print('Error loading user data: $e');
      return _getDefaultUser();
    }
  }

  // Cache data with key
  Future<void> cacheData(String key, Map<String, dynamic> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dataJson = json.encode(data);
      await prefs.setString(key, dataJson);
    } catch (e) {
      print('Error caching data for key $key: $e');
    }
  }

  // Get cached data
  Future<Map<String, dynamic>?> getCachedData(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dataJson = prefs.getString(key);
      
      if (dataJson != null) {
        return json.decode(dataJson);
      }
      
      return null;
    } catch (e) {
      print('Error getting cached data for key $key: $e');
      return null;
    }
  }

  // Clear all cache
  Future<void> clearAllCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (e) {
      print('Error clearing cache: $e');
    }
  }

  // Clear specific cache
  Future<void> clearCache(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(key);
    } catch (e) {
      print('Error clearing cache for key $key: $e');
    }
  }

  // Check if data is cached
  Future<bool> isCached(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey(key);
    } catch (e) {
      print('Error checking cache for key $key: $e');
      return false;
    }
  }

  // Get default user progress
  UserProgressModel _getDefaultUserProgress() {
    return UserProgressModel(
      currentLanguage: '',
      currentCourse: '',
      currentLesson: '',
      completedCourses: [],
      achievements: [],
      streakDays: 0,
      totalStudyTime: 0,
    );
  }

  // Get default user
  UserModel _getDefaultUser() {
    return UserModel(
      id: '1',
      name: 'مستخدم جديد',
      email: 'user@example.com',
      avatarUrl: null,
      level: 1,
      xp: 0,
      coins: 0,
      completedLessons: [],
      progress: _getDefaultUserProgress(),
    );
  }
}
