import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../../services/cache_service.dart';

class CacheDataSource {
  final CacheService _cacheService = CacheService();
  
  // Cache keys
  static const String _userProgressKey = 'user_progress';
  static const String _languageProgressPrefix = 'language_progress_';
  static const String _lessonProgressPrefix = 'lesson_progress_';
  static const String _quizResultPrefix = 'quiz_result_';
  static const String _userPreferencesKey = 'user_preferences';
  static const String _appSettingsKey = 'app_settings';

  // User progress caching
  Future<void> cacheUserProgress(User user) async {
    try {
      await _cacheService.cacheObject(
        _userProgressKey,
        user,
        (user) => user.toJson(),
        expiryHours: 168, // 1 week
      );
    } catch (e) {
      print('Error caching user progress: $e');
    }
  }

  Future<User?> getCachedUserProgress() async {
    try {
      return await _cacheService.getCachedObject(
        _userProgressKey,
        (json) => User.fromJson(json),
        expiryHours: 168,
      );
    } catch (e) {
      print('Error getting cached user progress: $e');
      return null;
    }
  }

  // Language progress caching
  Future<void> cacheLanguageProgress(String languageId, Map<String, dynamic> progress) async {
    try {
      await _cacheService.cacheData(
        _languageProgressPrefix + languageId,
        progress,
        expiryHours: 72, // 3 days
      );
    } catch (e) {
      print('Error caching language progress for $languageId: $e');
    }
  }

  Future<Map<String, dynamic>?> getCachedLanguageProgress(String languageId) async {
    try {
      return await _cacheService.getCachedData<Map<String, dynamic>>(
        _languageProgressPrefix + languageId,
        expiryHours: 72,
      );
    } catch (e) {
      print('Error getting cached language progress for $languageId: $e');
      return null;
    }
  }

  // Lesson progress caching
  Future<void> cacheLessonProgress(String lessonId, Map<String, dynamic> progress) async {
    try {
      await _cacheService.cacheData(
        _lessonProgressPrefix + lessonId,
        progress,
        expiryHours: 48, // 2 days
      );
    } catch (e) {
      print('Error caching lesson progress for $lessonId: $e');
    }
  }

  Future<Map<String, dynamic>?> getCachedLessonProgress(String lessonId) async {
    try {
      return await _cacheService.getCachedData<Map<String, dynamic>>(
        _lessonProgressPrefix + lessonId,
        expiryHours: 48,
      );
    } catch (e) {
      print('Error getting cached lesson progress for $lessonId: $e');
      return null;
    }
  }

  // Quiz result caching
  Future<void> cacheQuizResult(String quizId, Map<String, dynamic> result) async {
    try {
      await _cacheService.cacheData(
        _quizResultPrefix + quizId,
        result,
        expiryHours: 72, // 3 days
      );
    } catch (e) {
      print('Error caching quiz result for $quizId: $e');
    }
  }

  Future<Map<String, dynamic>?> getCachedQuizResult(String quizId) async {
    try {
      return await _cacheService.getCachedData<Map<String, dynamic>>(
        _quizResultPrefix + quizId,
        expiryHours: 72,
      );
    } catch (e) {
      print('Error getting cached quiz result for $quizId: $e');
      return null;
    }
  }

  // User preferences caching
  Future<void> cacheUserPreferences(Map<String, dynamic> preferences) async {
    try {
      await _cacheService.cacheData(
        _userPreferencesKey,
        preferences,
        expiryHours: 720, // 30 days
      );
    } catch (e) {
      print('Error caching user preferences: $e');
    }
  }

  Future<Map<String, dynamic>?> getCachedUserPreferences() async {
    try {
      return await _cacheService.getCachedData<Map<String, dynamic>>(
        _userPreferencesKey,
        expiryHours: 720,
      );
    } catch (e) {
      print('Error getting cached user preferences: $e');
      return null;
    }
  }

  // App settings caching
  Future<void> cacheAppSettings(Map<String, dynamic> settings) async {
    try {
      await _cacheService.cacheData(
        _appSettingsKey,
        settings,
        expiryHours: 168, // 1 week
      );
    } catch (e) {
      print('Error caching app settings: $e');
    }
  }

  Future<Map<String, dynamic>?> getCachedAppSettings() async {
    try {
      return await _cacheService.getCachedData<Map<String, dynamic>>(
        _appSettingsKey,
        expiryHours: 168,
      );
    } catch (e) {
      print('Error getting cached app settings: $e');
      return null;
    }
  }

  // Clear specific cache
  Future<void> clearUserProgressCache() async {
    await _cacheService.removeCachedData(_userProgressKey);
  }

  Future<void> clearLanguageProgressCache(String languageId) async {
    await _cacheService.removeCachedData(_languageProgressPrefix + languageId);
  }

  Future<void> clearLessonProgressCache(String lessonId) async {
    await _cacheService.removeCachedData(_lessonProgressPrefix + lessonId);
  }

  Future<void> clearQuizResultCache(String quizId) async {
    await _cacheService.removeCachedData(_quizResultPrefix + quizId);
  }

  // Clear all cache
  Future<void> clearAllCache() async {
    await _cacheService.clearAllCache();
  }

  // Check if data is cached
  Future<bool> isUserProgressCached() async {
    return await _cacheService.isCached(_userProgressKey, expiryHours: 168);
  }

  Future<bool> isLanguageProgressCached(String languageId) async {
    return await _cacheService.isCached(_languageProgressPrefix + languageId, expiryHours: 72);
  }

  Future<bool> isLessonProgressCached(String lessonId) async {
    return await _cacheService.isCached(_lessonProgressPrefix + lessonId, expiryHours: 48);
  }

  Future<bool> isQuizResultCached(String quizId) async {
    return await _cacheService.isCached(_quizResultPrefix + quizId, expiryHours: 72);
  }

  // Get cache statistics
  Future<Map<String, dynamic>> getCacheStatistics() async {
    final cacheInfo = _cacheService.getCacheInfo();
    final cacheSize = await _cacheService.getCacheSize();
    
    return {
      'totalCachedItems': cacheInfo['cacheSize'],
      'cacheSize': cacheSize,
      'cachedKeys': cacheInfo['cachedFiles'],
    };
  }

  // Batch operations
  Future<void> cacheMultipleItems(Map<String, dynamic> items) async {
    for (final entry in items.entries) {
      final key = entry.key;
      final value = entry.value;
      
      await _cacheService.cacheData(key, value);
    }
  }

  Future<Map<String, dynamic>> getCachedMultipleItems(List<String> keys) async {
    final results = <String, dynamic>{};
    
    for (final key in keys) {
      final cachedData = await _cacheService.getCachedData(key);
      if (cachedData != null) {
        results[key] = cachedData;
      }
    }
    
    return results;
  }
}
