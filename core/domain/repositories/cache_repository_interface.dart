abstract class CacheRepositoryInterface {
  /// Clear all cached data
  Future<void> clearAllCache();

  /// Get cache statistics
  Future<Map<String, dynamic>> getCacheStatistics();

  /// Clear specific cache by key
  Future<void> clearCache(String key) async {
    // Default implementation - should be overridden by concrete class
  }

  /// Check if data is cached
  Future<bool> isCached(String key) async {
    // Default implementation - should be overridden by concrete class
    return false;
  }

  /// Get cache size in bytes
  Future<int> getCacheSize() async {
    final stats = await getCacheStatistics();
    return stats['cacheSize'] as int? ?? 0;
  }

  /// Get number of cached items
  Future<int> getCachedItemsCount() async {
    final stats = await getCacheStatistics();
    return stats['totalCachedItems'] as int? ?? 0;
  }

  /// Clear expired cache entries
  Future<void> clearExpiredCache() async {
    // Default implementation - should be overridden by concrete class
  }

  /// Set cache expiry time for a key
  Future<void> setCacheExpiry(String key, Duration expiry) async {
    // Default implementation - should be overridden by concrete class
  }

  /// Get cache expiry time for a key
  Future<Duration?> getCacheExpiry(String key) async {
    // Default implementation - should be overridden by concrete class
    return null;
  }

  /// Cache data with custom expiry
  Future<void> cacheWithExpiry(
    String key,
    dynamic data,
    Duration expiry,
  ) async {
    // Default implementation - should be overridden by concrete class
  }

  /// Get cached data
  Future<T?> getCachedData<T>(String key) async {
    // Default implementation - should be overridden by concrete class
    return null;
  }

  /// Cache multiple items at once
  Future<void> cacheMultiple(Map<String, dynamic> items) async {
    // Default implementation - should be overridden by concrete class
  }

  /// Get multiple cached items
  Future<Map<String, dynamic>> getCachedMultiple(List<String> keys) async {
    // Default implementation - should be overridden by concrete class
    return {};
  }

  /// Clear cache by pattern
  Future<void> clearCacheByPattern(String pattern) async {
    // Default implementation - should be overridden by concrete class
  }

  /// Get cache keys matching pattern
  Future<List<String>> getCacheKeysByPattern(String pattern) async {
    // Default implementation - should be overridden by concrete class
    return [];
  }

  /// Optimize cache (remove unused entries, compress data, etc.)
  Future<void> optimizeCache() async {
    await clearExpiredCache();
  }

  /// Get cache health information
  Future<Map<String, dynamic>> getCacheHealth() async {
    final stats = await getCacheStatistics();
    final size = await getCacheSize();
    final count = await getCachedItemsCount();
    
    return {
      'isHealthy': size < 50 * 1024 * 1024, // Less than 50MB
      'totalSize': size,
      'totalItems': count,
      'averageItemSize': count > 0 ? size / count : 0,
      'recommendations': _getCacheRecommendations(size, count),
    };
  }

  /// Get cache recommendations based on current state
  List<String> _getCacheRecommendations(int size, int count) {
    final recommendations = <String>[];
    
    if (size > 100 * 1024 * 1024) { // More than 100MB
      recommendations.add('Consider clearing cache - size is large');
    }
    
    if (count > 1000) {
      recommendations.add('Consider optimizing cache - too many items');
    }
    
    if (size > 0 && count == 0) {
      recommendations.add('Cache corruption detected - clear all cache');
    }
    
    return recommendations;
  }
}
