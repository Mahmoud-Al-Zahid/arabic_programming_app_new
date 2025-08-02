import '../datasources/cache_datasource.dart';
import '../../domain/repositories/cache_repository_interface.dart';

class CacheRepository implements CacheRepositoryInterface {
  final CacheDataSource _cacheDataSource;

  CacheRepository({
    CacheDataSource? cacheDataSource,
  }) : _cacheDataSource = cacheDataSource ?? CacheDataSource();

  @override
  Future<void> clearAllCache() async {
    try {
      await _cacheDataSource.clearAllCache();
    } catch (e) {
      print('Error in CacheRepository.clearAllCache: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getCacheStatistics() async {
    try {
      return await _cacheDataSource.getCacheStatistics();
    } catch (e) {
      print('Error in CacheRepository.getCacheStatistics: $e');
      return {
        'totalCachedItems': 0,
        'cacheSize': 0,
        'cachedKeys': <String>[],
      };
    }
  }

  // Additional cache management methods
  Future<void> clearUserProgressCache() async {
    try {
      await _cacheDataSource.clearUserProgressCache();
    } catch (e) {
      print('Error clearing user progress cache: $e');
    }
  }

  Future<void> clearLanguageProgressCache(String languageId) async {
    try {
      await _cacheDataSource.clearLanguageProgressCache(languageId);
    } catch (e) {
      print('Error clearing language progress cache for $languageId: $e');
    }
  }

  Future<void> clearLessonProgressCache(String lessonId) async {
    try {
      await _cacheDataSource.clearLessonProgressCache(lessonId);
    } catch (e) {
      print('Error clearing lesson progress cache for $lessonId: $e');
    }
  }

  Future<void> clearQuizResultCache(String quizId) async {
    try {
      await _cacheDataSource.clearQuizResultCache(quizId);
    } catch (e) {
      print('Error clearing quiz result cache for $quizId: $e');
    }
  }

  Future<bool> isUserProgressCached() async {
    try {
      return await _cacheDataSource.isUserProgressCached();
    } catch (e) {
      print('Error checking user progress cache: $e');
      return false;
    }
  }

  Future<bool> isLanguageProgressCached(String languageId) async {
    try {
      return await _cacheDataSource.isLanguageProgressCached(languageId);
    } catch (e) {
      print('Error checking language progress cache for $languageId: $e');
      return false;
    }
  }

  Future<bool> isLessonProgressCached(String lessonId) async {
    try {
      return await _cacheDataSource.isLessonProgressCached(lessonId);
    } catch (e) {
      print('Error checking lesson progress cache for $lessonId: $e');
      return false;
    }
  }

  Future<bool> isQuizResultCached(String quizId) async {
    try {
      return await _cacheDataSource.isQuizResultCached(quizId);
    } catch (e) {
      print('Error checking quiz result cache for $quizId: $e');
      return false;
    }
  }

  Future<void> cacheMultipleItems(Map<String, dynamic> items) async {
    try {
      await _cacheDataSource.cacheMultipleItems(items);
    } catch (e) {
      print('Error caching multiple items: $e');
    }
  }

  Future<Map<String, dynamic>> getCachedMultipleItems(List<String> keys) async {
    try {
      return await _cacheDataSource.getCachedMultipleItems(keys);
    } catch (e) {
      print('Error getting cached multiple items: $e');
      return {};
    }
  }
}
