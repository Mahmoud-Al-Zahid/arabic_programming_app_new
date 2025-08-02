import 'dart:convert';
import 'package:flutter/services.dart';
import '../data/models/language_model.dart';
import '../data/models/course_model.dart';
import '../data/models/lesson_model.dart';
import '../data/models/quiz_model.dart';
import '../constants/json_paths.dart';

class JsonService {
  static final JsonService _instance = JsonService._internal();
  factory JsonService() => _instance;
  JsonService._internal();

  // Cache للبيانات المحملة
  final Map<String, dynamic> _cache = {};

  // تحميل ملف JSON من الأصول
  Future<Map<String, dynamic>> _loadJsonAsset(String path) async {
    if (_cache.containsKey(path)) {
      return _cache[path];
    }

    try {
      final String jsonString = await rootBundle.loadString(path);
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      _cache[path] = jsonData;
      return jsonData;
    } catch (e) {
      print('Error loading JSON from $path: $e');
      throw Exception('Failed to load JSON data from $path');
    }
  }

  // تحميل قائمة اللغات
  Future<List<Language>> loadLanguages() async {
    try {
      final jsonData = await _loadJsonAsset(JsonPaths.languages);
      final List<dynamic> languagesJson = jsonData['languages'] ?? [];
      
      return languagesJson
          .map((languageJson) => Language.fromJson(languageJson))
          .toList();
    } catch (e) {
      print('Error loading languages: $e');
      return [];
    }
  }

  // تحميل كورس معين
  Future<Course?> loadCourse(String languageId) async {
    try {
      final path = JsonPaths.getCoursePath(languageId);
      final jsonData = await _loadJsonAsset(path);
      return Course.fromJson(jsonData);
    } catch (e) {
      print('Error loading course for $languageId: $e');
      return null;
    }
  }

  // تحميل درس معين
  Future<Lesson?> loadLesson(String languageId, String lessonId) async {
    try {
      final path = JsonPaths.getLessonPath(languageId, lessonId);
      final jsonData = await _loadJsonAsset(path);
      return Lesson.fromJson(jsonData);
    } catch (e) {
      print('Error loading lesson $lessonId for $languageId: $e');
      return null;
    }
  }

  // تحميل اختبار درس
  Future<Quiz?> loadLessonQuiz(String lessonId) async {
    try {
      final path = JsonPaths.getLessonQuizPath(lessonId);
      final jsonData = await _loadJsonAsset(path);
      return Quiz.fromJson(jsonData);
    } catch (e) {
      print('Error loading quiz for lesson $lessonId: $e');
      return null;
    }
  }

  // تحميل اختبار مستوى
  Future<Quiz?> loadLevelQuiz(String levelId) async {
    try {
      final path = JsonPaths.getLevelQuizPath(levelId);
      final jsonData = await _loadJsonAsset(path);
      return Quiz.fromJson(jsonData);
    } catch (e) {
      print('Error loading quiz for level $levelId: $e');
      return null;
    }
  }

  // التحقق من صحة البيانات
  bool validateJsonStructure(Map<String, dynamic> data, String type) {
    switch (type) {
      case 'language':
        return data.containsKey('id') && 
               data.containsKey('name') && 
               data.containsKey('description');
      case 'course':
        return data.containsKey('languageId') && 
               data.containsKey('levels') && 
               data['levels'] is List;
      case 'lesson':
        return data.containsKey('lessonId') && 
               data.containsKey('lessonTitle') && 
               data.containsKey('slides');
      case 'quiz':
        return data.containsKey('id') && 
               data.containsKey('questions') && 
               data['questions'] is List;
      default:
        return false;
    }
  }

  // البحث في المحتوى
  Future<List<dynamic>> searchContent(String query, {String? languageId}) async {
    try {
      final List<dynamic> results = [];
      
      // البحث في اللغات
      final languages = await loadLanguages();
      for (final language in languages) {
        if (languageId != null && language.id != languageId) continue;
        
        if (language.name.toLowerCase().contains(query.toLowerCase()) ||
            language.description.toLowerCase().contains(query.toLowerCase())) {
          results.add(language);
        }
      }
      
      return results;
    } catch (e) {
      print('Error searching content: $e');
      return [];
    }
  }

  // مسح الكاش
  void clearCache() {
    _cache.clear();
  }

  // مسح كاش ملف معين
  void clearCacheForPath(String path) {
    _cache.remove(path);
  }

  // التحقق من وجود ملف في الكاش
  bool isCached(String path) {
    return _cache.containsKey(path);
  }

  // الحصول على حجم الكاش
  int getCacheSize() {
    return _cache.length;
  }
}
