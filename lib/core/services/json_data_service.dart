import 'dart:convert';
import 'package:flutter/services.dart';
import '../data/models/language_model.dart';
import '../data/models/course_model.dart';
import '../data/models/lesson_model.dart';
import '../data/models/quiz_model.dart';
import '../data/models/user_model.dart';

class JsonDataService {
  static final JsonDataService _instance = JsonDataService._internal();
  factory JsonDataService() => _instance;
  JsonDataService._internal();

  // Cache for loaded data
  final Map<String, dynamic> _cache = {};

  // Languages
  Future<List<Language>> getLanguages() async {
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

  // Course by language ID
  Future<Course?> getCourse(String languageId) async {
    final cacheKey = 'course_$languageId';
    
    if (_cache.containsKey(cacheKey)) {
      return Course.fromJson(_cache[cacheKey]);
    }

    try {
      final String jsonString = await rootBundle.loadString('assets/courses/$languageId.json');
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      
      _cache[cacheKey] = jsonMap;
      
      return Course.fromJson(jsonMap);
    } catch (e) {
      print('Error loading course $languageId: $e');
      return null;
    }
  }

  // Lesson by language and lesson ID
  Future<Lesson?> getLesson(String languageId, String lessonId) async {
    final cacheKey = 'lesson_${languageId}_$lessonId';
    
    if (_cache.containsKey(cacheKey)) {
      return Lesson.fromJson(_cache[cacheKey]);
    }

    try {
      final String jsonString = await rootBundle.loadString('assets/lessons/$languageId/$lessonId.json');
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      
      _cache[cacheKey] = jsonMap;
      
      return Lesson.fromJson(jsonMap);
    } catch (e) {
      print('Error loading lesson $lessonId: $e');
      return null;
    }
  }

  // Quiz by type and ID
  Future<Quiz?> getQuiz(String type, String quizId) async {
    final cacheKey = 'quiz_${type}_$quizId';
    
    if (_cache.containsKey(cacheKey)) {
      return Quiz.fromJson(_cache[cacheKey]);
    }

    try {
      final String jsonString = await rootBundle.loadString('assets/quizzes/$type/$quizId.json');
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      
      _cache[cacheKey] = jsonMap;
      
      return Quiz.fromJson(jsonMap);
    } catch (e) {
      print('Error loading quiz $quizId: $e');
      return null;
    }
  }

  // Get lesson quiz
  Future<Quiz?> getLessonQuiz(String quizId) async {
    return await getQuiz('lessons', quizId);
  }

  // Get level quiz
  Future<Quiz?> getLevelQuiz(String quizId) async {
    return await getQuiz('levels', quizId);
  }

  // Clear cache
  void clearCache() {
    _cache.clear();
  }

  // Clear specific cache entry
  void clearCacheEntry(String key) {
    _cache.remove(key);
  }

  // Preload data for better performance
  Future<void> preloadLanguageData(String languageId) async {
    await getCourse(languageId);
  }

  Future<void> preloadLevelData(String languageId, String levelId) async {
    final course = await getCourse(languageId);
    if (course != null) {
      final level = course.levels.firstWhere(
        (l) => l.levelId == levelId,
        orElse: () => throw Exception('Level not found'),
      );
      
      // Preload all lessons in this level
      for (final lessonInfo in level.lessons) {
        await getLesson(languageId, lessonInfo.lessonId);
        await getLessonQuiz(lessonInfo.quizId);
      }
      
      // Preload level quiz
      await getLevelQuiz(level.quizlv);
    }
  }
}
