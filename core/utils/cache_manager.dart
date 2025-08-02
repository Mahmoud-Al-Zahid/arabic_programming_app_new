import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../services/cache_service.dart';

class CacheManager {
  static final CacheManager _instance = CacheManager._internal();
  factory CacheManager() => _instance;
  CacheManager._internal();

  final CacheService _cacheService = CacheService();
  
  // Cache categories
  static const String _userDataCategory = 'user_data';
  static const String _courseDataCategory = 'course_data';
  static const String _lessonDataCategory = 'lesson_data';
  static const String _quizDataCategory = 'quiz_data';
  static const String _imageCategory = 'images';
  static const String _audioCategory = 'audio';

  // Cache expiry times (in hours)
  static const int _userDataExpiry = 168; // 1 week
  static const int _courseDataExpiry = 72; // 3 days
  static const int _lessonDataExpiry = 48; // 2 days
  static const int _quizDataExpiry = 24; // 1 day
  static const int _mediaExpiry = 720; // 30 days

  // User data caching
  Future<void> cacheUserData(String userId, Map<String, dynamic> userData) async {
    try {
      final key = '${_userDataCategory}_$userId';
      await _cacheService.cacheData(key, userData, expiryHours: _userDataExpiry);
    } catch (e) {
      print('Error caching user data: $e');
    }
  }

  Future<Map<String, dynamic>?> getCachedUserData(String userId) async {
    try {
      final key = '${_userDataCategory}_$userId';
      return await _cacheService.getCachedData<Map<String, dynamic>>(
        key,
        expiryHours: _userDataExpiry,
      );
    } catch (e) {
      print('Error getting cached user data: $e');
      return null;
    }
  }

  // Course data caching
  Future<void> cacheCourseData(String languageId, Map<String, dynamic> courseData) async {
    try {
      final key = '${_courseDataCategory}_$languageId';
      await _cacheService.cacheData(key, courseData, expiryHours: _courseDataExpiry);
    } catch (e) {
      print('Error caching course data: $e');
    }
  }

  Future<Map<String, dynamic>?> getCachedCourseData(String languageId) async {
    try {
      final key = '${_courseDataCategory}_$languageId';
      return await _cacheService.getCachedData<Map<String, dynamic>>(
        key,
        expiryHours: _courseDataExpiry,
      );
    } catch (e) {
      print('Error getting cached course data: $e');
      return null;
    }
  }

  // Lesson data caching
  Future<void> cacheLessonData(String lessonId, Map<String, dynamic> lessonData) async {
    try {
      final key = '${_lessonDataCategory}_$lessonId';
      await _cacheService.cacheData(key, lessonData, expiryHours: _lessonDataExpiry);
    } catch (e) {
      print('Error caching lesson data: $e');
    }
  }

  Future<Map<String, dynamic>?> getCachedLessonData(String lessonId) async {
    try {
      final key = '${_lessonDataCategory}_$lessonId';
      return await _cacheService.getCachedData<Map<String, dynamic>>(
        key,
        expiryHours: _lessonDataExpiry,
      );
    } catch (e) {
      print('Error getting cached lesson data: $e');
      return null;
    }
  }

  // Quiz data caching
  Future<void> cacheQuizData(String quizId, Map<String, dynamic> quizData) async {
    try {
      final key = '${_quizDataCategory}_$quizId';
      await _cacheService.cacheData(key, quizData, expiryHours: _quizDataExpiry);
    } catch (e) {
      print('Error caching quiz data: $e');
    }
  }

  Future<Map<String, dynamic>?> getCachedQuizData(String quizId) async {
    try {
      final key = '${_quizDataCategory}_$quizId';
      return await _cacheService.getCachedData<Map<String, dynamic>>(
        key,
        expiryHours: _quizDataExpiry,
      );
    } catch (e) {
      print('Error getting cached quiz data: $e');
      return null;
    }
  }

  // Media caching (images, audio)
  Future<void> cacheImage(String imageUrl, List<int> imageBytes) async {
    try {
      final key = '${_imageCategory}_${_getFileNameFromUrl(imageUrl)}';
      final imageData = {
        'url': imageUrl,
        'data': base64Encode(imageBytes),
        'cachedAt': DateTime.now().toIso8601String(),
      };
      await _cacheService.cacheData(key, imageData, expiryHours: _mediaExpiry);
    } catch (e) {
      print('Error caching image: $e');
    }
  }

  Future<List<int>?> getCachedImage(String imageUrl) async {
    try {
      final key = '${_imageCategory}_${_getFileNameFromUrl(imageUrl)}';
      final imageData = await _cacheService.getCachedData<Map<String, dynamic>>(
        key,
        expiryHours: _mediaExpiry,
      );
      
      if (imageData != null && imageData['data'] != null) {
        return base64Decode(imageData['data'] as String);
      }
      
      return null;
    } catch (e) {
      print('Error getting cached image: $e');
      return null;
    }
  }

  Future<void> cacheAudio(String audioUrl, List<int> audioBytes) async {
    try {
      final key = '${_audioCategory}_${_getFileNameFromUrl(audioUrl)}';
      final audioData = {
        'url': audioUrl,
        'data': base64Encode(audioBytes),
        'cachedAt': DateTime.now().toIso8601String(),
      };
      await _cacheService.cacheData(key, audioData, expiryHours: _mediaExpiry);
    } catch (e) {
      print('Error caching audio: $e');
    }
  }

  Future<List<int>?> getCachedAudio(String audioUrl) async {
    try {
      final key = '${_audioCategory}_${_getFileNameFromUrl(audioUrl)}';
      final audioData = await _cacheService.getCachedData<Map<String, dynamic>>(
        key,
        expiryHours: _mediaExpiry,
      );
      
      if (audioData != null && audioData['data'] != null) {
        return base64Decode(audioData['data'] as String);
      }
      
      return null;
    } catch (e) {
      print('Error getting cached audio: $e');
      return null;
    }
  }

  // Batch operations
  Future<void> cacheBatchData(Map<String, Map<String, dynamic>> batchData) async {
    try {
      for (final entry in batchData.entries) {
        final key = entry.key;
        final data = entry.value;
        
        // Determine expiry based on key prefix
        int expiryHours = _courseDataExpiry;
        if (key.startsWith(_userDataCategory)) {
          expiryHours = _userDataExpiry;
        } else if (key.startsWith(_lessonDataCategory)) {
          expiryHours = _lessonDataExpiry;
        } else if (key.startsWith(_quizDataCategory)) {
          expiryHours = _quizDataExpiry;
        } else if (key.startsWith(_imageCategory) || key.startsWith(_audioCategory)) {
          expiryHours = _mediaExpiry;
        }
        
        await _cacheService.cacheData(key, data, expiryHours: expiryHours);
      }
    } catch (e) {
      print('Error caching batch data: $e');
    }
  }

  Future<Map<String, dynamic>> getCachedBatchData(List<String> keys) async {
    try {
      final results = <String, dynamic>{};
      
      for (final key in keys) {
        // Determine expiry based on key prefix
        int expiryHours = _courseDataExpiry;
        if (key.startsWith(_userDataCategory)) {
          expiryHours = _userDataExpiry;
        } else if (key.startsWith(_lessonDataCategory)) {
          expiryHours = _lessonDataExpiry;
        } else if (key.startsWith(_quizDataCategory)) {
          expiryHours = _quizDataExpiry;
        } else if (key.startsWith(_imageCategory) || key.startsWith(_audioCategory)) {
          expiryHours = _mediaExpiry;
        }
        
        final data = await _cacheService.getCachedData(key, expiryHours: expiryHours);
        if (data != null) {
          results[key] = data;
        }
      }
      
      return results;
    } catch (e) {
      print('Error getting cached batch data: $e');
      return {};
    }
  }

  // Cache management
  Future<void> clearCacheByCategory(String category) async {
    try {
      final allKeys = await _cacheService.getCachedKeys();
      final categoryKeys = allKeys.where((key) => key.startsWith(category)).toList();
      
      for (final key in categoryKeys) {
        await _cacheService.removeCachedData(key);
      }
    } catch (e) {
      print('Error clearing cache by category: $e');
    }
  }

  Future<void> clearUserCache(String userId) async {
    try {
      await _cacheService.removeCachedData('${_userDataCategory}_$userId');
    } catch (e) {
      print('Error clearing user cache: $e');
    }
  }

  Future<void> clearCourseCache(String languageId) async {
    try {
      await _cacheService.removeCachedData('${_courseDataCategory}_$languageId');
    } catch (e) {
      print('Error clearing course cache: $e');
    }
  }

  Future<void> clearLessonCache(String lessonId) async {
    try {
      await _cacheService.removeCachedData('${_lessonDataCategory}_$lessonId');
    } catch (e) {
      print('Error clearing lesson cache: $e');
    }
  }

  Future<void> clearQuizCache(String quizId) async {
    try {
      await _cacheService.removeCachedData('${_quizDataCategory}_$quizId');
    } catch (e) {
      print('Error clearing quiz cache: $e');
    }
  }

  Future<void> clearMediaCache() async {
    try {
      await clearCacheByCategory(_imageCategory);
      await clearCacheByCategory(_audioCategory);
    } catch (e) {
      print('Error clearing media cache: $e');
    }
  }

  Future<void> clearAllCache() async {
    try {
      await _cacheService.clearAllCache();
    } catch (e) {
      print('Error clearing all cache: $e');
    }
  }

  // Cache statistics and health
  Future<Map<String, dynamic>> getCacheStatistics() async {
    try {
      final allKeys = await _cacheService.getCachedKeys();
      final totalSize = await _cacheService.getCacheSize();
      
      final categoryStats = <String, int>{};
      for (final key in allKeys) {
        String category = 'other';
        if (key.startsWith(_userDataCategory)) {
          category = 'user_data';
        } else if (key.startsWith(_courseDataCategory)) {
          category = 'course_data';
        } else if (key.startsWith(_lessonDataCategory)) {
          category = 'lesson_data';
        } else if (key.startsWith(_quizDataCategory)) {
          category = 'quiz_data';
        } else if (key.startsWith(_imageCategory)) {
          category = 'images';
        } else if (key.startsWith(_audioCategory)) {
          category = 'audio';
        }
        
        categoryStats[category] = (categoryStats[category] ?? 0) + 1;
      }
      
      return {
        'totalItems': allKeys.length,
        'totalSize': totalSize,
        'categoryBreakdown': categoryStats,
        'averageItemSize': allKeys.isNotEmpty ? totalSize / allKeys.length : 0,
      };
    } catch (e) {
      print('Error getting cache statistics: $e');
      return {
        'totalItems': 0,
        'totalSize': 0,
        'categoryBreakdown': <String, int>{},
        'averageItemSize': 0,
      };
    }
  }

  Future<bool> isCacheHealthy() async {
    try {
      final stats = await getCacheStatistics();
      final totalSize = stats['totalSize'] as int;
      final totalItems = stats['totalItems'] as int;
      
      // Consider cache healthy if:
      // - Total size is less than 100MB
      // - Total items is less than 1000
      // - Average item size is reasonable
      
      return totalSize < 100 * 1024 * 1024 && // Less than 100MB
             totalItems < 1000 && // Less than 1000 items
             (totalItems == 0 || (totalSize / totalItems) < 1024 * 1024); // Average item less than 1MB
    } catch (e) {
      print('Error checking cache health: $e');
      return false;
    }
  }

  Future<void> optimizeCache() async {
    try {
      // Remove expired cache entries
      await _cacheService.cleanExpiredCache();
      
      // If cache is still too large, remove oldest entries
      final isHealthy = await isCacheHealthy();
      if (!isHealthy) {
        final allKeys = await _cacheService.getCachedKeys();
        
        // Sort keys by category priority (keep user data, remove media first)
        final prioritizedKeys = allKeys.toList();
        prioritizedKeys.sort((a, b) {
          int getPriority(String key) {
            if (key.startsWith(_userDataCategory)) return 1;
            if (key.startsWith(_courseDataCategory)) return 2;
            if (key.startsWith(_lessonDataCategory)) return 3;
            if (key.startsWith(_quizDataCategory)) return 4;
            if (key.startsWith(_imageCategory)) return 5;
            if (key.startsWith(_audioCategory)) return 6;
            return 7;
          }
          
          return getPriority(b).compareTo(getPriority(a));
        });
        
        // Remove lowest priority items until cache is healthy
        for (int i = prioritizedKeys.length - 1; i >= 0; i--) {
          await _cacheService.removeCachedData(prioritizedKeys[i]);
          
          final stillHealthy = await isCacheHealthy();
          if (stillHealthy) break;
          
          // Don't remove more than 50% of cache in one optimization
          if (i <= prioritizedKeys.length / 2) break;
        }
      }
    } catch (e) {
      print('Error optimizing cache: $e');
    }
  }

  // Preload commonly used data
  Future<void> preloadEssentialData(String userId, String currentLanguageId) async {
    try {
      // This would be called during app startup to preload critical data
      // Implementation would depend on your specific data loading logic
      
      print('Preloading essential data for user: $userId, language: $currentLanguageId');
      
      // Example: Preload user data, current course, and first few lessons
      // This would be implemented based on your specific data sources
    } catch (e) {
      print('Error preloading essential data: $e');
    }
  }

  // Helper methods
  String _getFileNameFromUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.pathSegments.last.replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_');
    } catch (e) {
      return url.hashCode.toString();
    }
  }

  Future<String> _getCacheDirectory() async {
    try {
      final directory = await getApplicationCacheDirectory();
      return directory.path;
    } catch (e) {
      print('Error getting cache directory: $e');
      return '';
    }
  }
}
