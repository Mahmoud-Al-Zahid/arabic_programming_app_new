import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  static const String _cachePrefix = 'app_cache_';
  static const String _cacheTimestampPrefix = 'cache_timestamp_';
  static const int _defaultCacheExpiryHours = 24;

  // Cache data with expiry
  Future<void> cacheData(
    String key,
    dynamic data, {
    int expiryHours = _defaultCacheExpiryHours,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheKey = _cachePrefix + key;
      final timestampKey = _cacheTimestampPrefix + key;
      
      final jsonData = jsonEncode(data);
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      
      await prefs.setString(cacheKey, jsonData);
      await prefs.setInt(timestampKey, timestamp);
      
      print('Cached data for key: $key');
    } catch (e) {
      print('Error caching data for key $key: $e');
    }
  }

  // Get cached data
  Future<T?> getCachedData<T>(
    String key, {
    int expiryHours = _defaultCacheExpiryHours,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheKey = _cachePrefix + key;
      final timestampKey = _cacheTimestampPrefix + key;
      
      final cachedData = prefs.getString(cacheKey);
      final timestamp = prefs.getInt(timestampKey);
      
      if (cachedData == null || timestamp == null) {
        return null;
      }
      
      // Check if cache has expired
      final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final expiryTime = cacheTime.add(Duration(hours: expiryHours));
      
      if (DateTime.now().isAfter(expiryTime)) {
        // Cache expired, remove it
        await removeCachedData(key);
        return null;
      }
      
      final decodedData = jsonDecode(cachedData);
      return decodedData as T;
    } catch (e) {
      print('Error getting cached data for key $key: $e');
      return null;
    }
  }

  // Check if data is cached and valid
  Future<bool> isCached(
    String key, {
    int expiryHours = _defaultCacheExpiryHours,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheKey = _cachePrefix + key;
      final timestampKey = _cacheTimestampPrefix + key;
      
      final cachedData = prefs.getString(cacheKey);
      final timestamp = prefs.getInt(timestampKey);
      
      if (cachedData == null || timestamp == null) {
        return false;
      }
      
      // Check if cache has expired
      final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final expiryTime = cacheTime.add(Duration(hours: expiryHours));
      
      return DateTime.now().isBefore(expiryTime);
    } catch (e) {
      print('Error checking cache for key $key: $e');
      return false;
    }
  }

  // Remove cached data
  Future<void> removeCachedData(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheKey = _cachePrefix + key;
      final timestampKey = _cacheTimestampPrefix + key;
      
      await prefs.remove(cacheKey);
      await prefs.remove(timestampKey);
      
      print('Removed cached data for key: $key');
    } catch (e) {
      print('Error removing cached data for key $key: $e');
    }
  }

  // Clear all cache
  Future<void> clearAllCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();
      
      final cacheKeys = keys.where((key) => 
        key.startsWith(_cachePrefix) || key.startsWith(_cacheTimestampPrefix)
      ).toList();
      
      for (final key in cacheKeys) {
        await prefs.remove(key);
      }
      
      print('Cleared all cache data');
    } catch (e) {
      print('Error clearing all cache: $e');
    }
  }

  // Get cache size (approximate)
  Future<int> getCacheSize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();
      
      int totalSize = 0;
      for (final key in keys) {
        if (key.startsWith(_cachePrefix)) {
          final data = prefs.getString(key);
          if (data != null) {
            totalSize += data.length;
          }
        }
      }
      
      return totalSize;
    } catch (e) {
      print('Error calculating cache size: $e');
      return 0;
    }
  }

  // Get all cached keys
  Future<List<String>> getCachedKeys() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();
      
      return keys
          .where((key) => key.startsWith(_cachePrefix))
          .map((key) => key.replaceFirst(_cachePrefix, ''))
          .toList();
    } catch (e) {
      print('Error getting cached keys: $e');
      return [];
    }
  }

  // Cache with custom serialization
  Future<void> cacheObject<T>(
    String key,
    T object,
    Map<String, dynamic> Function(T) toJson, {
    int expiryHours = _defaultCacheExpiryHours,
  }) async {
    try {
      final jsonData = toJson(object);
      await cacheData(key, jsonData, expiryHours: expiryHours);
    } catch (e) {
      print('Error caching object for key $key: $e');
    }
  }

  // Get cached object with custom deserialization
  Future<T?> getCachedObject<T>(
    String key,
    T Function(Map<String, dynamic>) fromJson, {
    int expiryHours = _defaultCacheExpiryHours,
  }) async {
    try {
      final jsonData = await getCachedData<Map<String, dynamic>>(
        key,
        expiryHours: expiryHours,
      );
      
      if (jsonData == null) return null;
      
      return fromJson(jsonData);
    } catch (e) {
      print('Error getting cached object for key $key: $e');
      return null;
    }
  }
}
