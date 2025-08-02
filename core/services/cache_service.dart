import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/user_progress_model.dart';
import '../data/models/user_model.dart';

class CacheService {
  static const String _userProgressKey = 'user_progress';
  static const String _userDataKey = 'user_data';
  static const String _completedLessonsKey = 'completed_lessons';
  static const String _userStatsKey = 'user_stats';

  Future<UserProgressModel?> getUserProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? progressJson = prefs.getString(_userProgressKey);
      
      if (progressJson != null) {
        final Map<String, dynamic> data = json.decode(progressJson);
        return UserProgressModel.fromJson(data);
      }
      
      // Return default progress if none exists
      return UserProgressModel(
        currentLanguage: '',
        currentCourse: '',
        currentLesson: '',
        completedCourses: [],
        achievements: [],
        streakDays: 0,
        totalStudyTime: 0,
      );
    } catch (e) {
      return null;
    }
  }

  Future<void> saveUserProgress(UserProgressModel progress) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String progressJson = json.encode(progress.toJson());
      await prefs.setString(_userProgressKey, progressJson);
    } catch (e) {
      throw Exception('Failed to save user progress: $e');
    }
  }

  Future<UserModel?> getUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? userJson = prefs.getString(_userDataKey);
      
      if (userJson != null) {
        final Map<String, dynamic> data = json.decode(userJson);
        return UserModel.fromJson(data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> saveUserData(UserModel user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String userJson = json.encode(user.toJson());
      await prefs.setString(_userDataKey, userJson);
    } catch (e) {
      throw Exception('Failed to save user data: $e');
    }
  }

  Future<List<String>> getCompletedLessons() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getStringList(_completedLessonsKey) ?? [];
    } catch (e) {
      return [];
    }
  }

  Future<void> addCompletedLesson(String lessonId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> completed = await getCompletedLessons();
      
      if (!completed.contains(lessonId)) {
        completed.add(lessonId);
        await prefs.setStringList(_completedLessonsKey, completed);
      }
    } catch (e) {
      throw Exception('Failed to add completed lesson: $e');
    }
  }

  Future<Map<String, dynamic>> getUserStats() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? statsJson = prefs.getString(_userStatsKey);
      
      if (statsJson != null) {
        return json.decode(statsJson);
      }
      
      // Return default stats
      return {
        'xp': 0,
        'coins': 0,
        'level': 1,
        'streakDays': 0,
        'totalStudyTime': 0,
      };
    } catch (e) {
      return {};
    }
  }

  Future<void> updateUserStats(Map<String, dynamic> stats) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String statsJson = json.encode(stats);
      await prefs.setString(_userStatsKey, statsJson);
    } catch (e) {
      throw Exception('Failed to update user stats: $e');
    }
  }

  Future<void> clearAllData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (e) {
      throw Exception('Failed to clear data: $e');
    }
  }
}
