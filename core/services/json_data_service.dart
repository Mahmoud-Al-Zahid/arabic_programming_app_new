import 'dart:convert';
import 'package:flutter/services.dart';
import '../data/models/language_model.dart';
import '../data/models/course_model.dart';
import '../data/models/lesson_model.dart';
import '../data/models/quiz_model.dart';

class JsonDataService {
  static final JsonDataService _instance = JsonDataService._internal();
  factory JsonDataService() => _instance;
  JsonDataService._internal();

  // Cache للبيانات المحملة
  final Map<String, dynamic> _cache = {};

  // تحميل قائمة اللغات
  Future<List<Language>> loadLanguages() async {
    const cacheKey = 'languages';
    
    if (_cache.containsKey(cacheKey)) {
      return (_cache[cacheKey] as List<dynamic>)
          .map((json) => Language.fromJson(json))
          .toList();
    }

    try {
      final String jsonString = await rootBundle.loadString('assets/languages/languages.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      
      _cache[cacheKey] = jsonList;
      
      return jsonList.map((json) => Language.fromJson(json)).toList();
    } catch (e) {
      print('Error loading languages: $e');
      return [];
    }
  }

  // تحميل كورس معين
  Future<Course?> loadCourse(String languageId) async {
    final cacheKey = 'course_$languageId';
    
    if (_cache.containsKey(cacheKey)) {
      return Course.fromJson(_cache[cacheKey]);
    }

    try {
      final String jsonString = await rootBundle.loadString('assets/courses/$languageId.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      
      _cache[cacheKey] = jsonData;
      
      return Course.fromJson(jsonData);
    } catch (e) {
      print('Error loading course $languageId: $e');
      return null;
    }
  }

  // تحميل درس معين
  Future<Lesson?> loadLesson(String languageId, String lessonId) async {
    final cacheKey = 'lesson_${languageId}_$lessonId';
    
    if (_cache.containsKey(cacheKey)) {
      return Lesson.fromJson(_cache[cacheKey]);
    }

    try {
      final String jsonString = await rootBundle.loadString('assets/lessons/$languageId/$lessonId.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      
      _cache[cacheKey] = jsonData;
      
      return Lesson.fromJson(jsonData);
    } catch (e) {
      print('Error loading lesson $lessonId: $e');
      return null;
    }
  }

  // تحميل اختبار درس
  Future<Quiz?> loadLessonQuiz(String quizId) async {
    final cacheKey = 'lesson_quiz_$quizId';
    
    if (_cache.containsKey(cacheKey)) {
      return Quiz.fromJson(_cache[cacheKey]);
    }

    try {
      final String jsonString = await rootBundle.loadString('assets/quizzes/lessons/${quizId}.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      
      _cache[cacheKey] = jsonData;
      
      return Quiz.fromJson(jsonData);
    } catch (e) {
      print('Error loading lesson quiz $quizId: $e');
      return null;
    }
  }

  // تحميل اختبار مستوى
  Future<Quiz?> loadLevelQuiz(String quizFileName) async {
    final cacheKey = 'level_quiz_$quizFileName';
    
    if (_cache.containsKey(cacheKey)) {
      return Quiz.fromJson(_cache[cacheKey]);
    }

    try {
      final String jsonString = await rootBundle.loadString('assets/quizzes/levels/$quizFileName');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      
      _cache[cacheKey] = jsonData;
      
      return Quiz.fromJson(jsonData);
    } catch (e) {
      print('Error loading level quiz $quizFileName: $e');
      return null;
    }
  }

  // مسح الكاش
  void clearCache() {
    _cache.clear();
  }

  // مسح كاش معين
  void clearCacheForKey(String key) {
    _cache.remove(key);
  }

  // التحقق من وجود البيانات في الكاش
  bool isCached(String key) {
    return _cache.containsKey(key);
  }

  // الحصول على حجم الكاش
  int getCacheSize() {
    return _cache.length;
  }
}
