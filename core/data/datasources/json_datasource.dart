import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/language_model.dart';
import '../models/course_model.dart';
import '../models/lesson_model.dart';
import '../models/quiz_model.dart';
import '../models/user_model.dart';
import '../../constants/json_paths.dart';
import '../../utils/json_validator.dart';

class JsonDataSource {
  // Cache for loaded JSON data
  final Map<String, dynamic> _cache = {};

  // Load and parse JSON file
  Future<Map<String, dynamic>> _loadJsonFile(String path) async {
    try {
      if (_cache.containsKey(path)) {
        return _cache[path] as Map<String, dynamic>;
      }

      final jsonString = await rootBundle.loadString(path);
      
      if (!JsonValidator.isValidJson(jsonString)) {
        throw Exception('Invalid JSON format in file: $path');
      }

      final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
      _cache[path] = jsonData;
      
      return jsonData;
    } catch (e) {
      print('Error loading JSON file $path: $e');
      throw Exception('Failed to load JSON file: $path');
    }
  }

  // Load languages
  Future<List<Language>> getLanguages() async {
    try {
      final jsonData = await _loadJsonFile(JsonPaths.languages);
      
      if (!jsonData.containsKey('languages') || jsonData['languages'] is! List) {
        throw Exception('Invalid languages JSON structure');
      }

      final languagesJson = jsonData['languages'] as List;
      return languagesJson
          .map((json) => Language.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting languages: $e');
      return [];
    }
  }

  // Load course by language ID
  Future<Course?> getCourse(String languageId) async {
    try {
      final coursePath = JsonPaths.getCoursePathForLanguage(languageId);
      final jsonData = await _loadJsonFile(coursePath);
      
      if (!JsonValidator.isValidCourseJson(jsonData)) {
        throw Exception('Invalid course JSON structure for language: $languageId');
      }

      return Course.fromJson(jsonData);
    } catch (e) {
      print('Error getting course for language $languageId: $e');
      return null;
    }
  }

  // Load lesson
  Future<Lesson?> getLesson(String languageId, String lessonId) async {
    try {
      final lessonPath = JsonPaths.getLessonPath(languageId, lessonId);
      final jsonData = await _loadJsonFile(lessonPath);
      
      if (!JsonValidator.isValidLessonJson(jsonData)) {
        throw Exception('Invalid lesson JSON structure for lesson: $lessonId');
      }

      return Lesson.fromJson(jsonData);
    } catch (e) {
      print('Error getting lesson $lessonId for language $languageId: $e');
      return null;
    }
  }

  // Load lesson quiz
  Future<Quiz?> getLessonQuiz(String lessonId) async {
    try {
      final quizPath = JsonPaths.getLessonQuizPath(lessonId);
      final jsonData = await _loadJsonFile(quizPath);
      
      if (!JsonValidator.isValidQuizJson(jsonData)) {
        throw Exception('Invalid quiz JSON structure for lesson: $lessonId');
      }

      return Quiz.fromJson(jsonData);
    } catch (e) {
      print('Error getting quiz for lesson $lessonId: $e');
      return null;
    }
  }

  // Load level quiz
  Future<Quiz?> getLevelQuiz(String levelId) async {
    try {
      final quizPath = JsonPaths.getLevelQuizPath(levelId);
      final jsonData = await _loadJsonFile(quizPath);
      
      if (!JsonValidator.isValidQuizJson(jsonData)) {
        throw Exception('Invalid quiz JSON structure for level: $levelId');
      }

      return Quiz.fromJson(jsonData);
    } catch (e) {
      print('Error getting quiz for level $levelId: $e');
      return null;
    }
  }

  // Search content across all JSON files
  Future<List<dynamic>> searchContent(String query, {String? languageId}) async {
    try {
      final results = <dynamic>[];
      final searchQuery = query.toLowerCase();

      // Search in languages
      final languages = await getLanguages();
      for (final language in languages) {
        if (languageId != null && language.id != languageId) continue;
        
        if (language.name.toLowerCase().contains(searchQuery) ||
            language.description.toLowerCase().contains(searchQuery)) {
          results.add({
            'type': 'language',
            'data': language,
            'relevance': _calculateRelevance(searchQuery, language.name + ' ' + language.description),
          });
        }
      }

      // Search in courses
      if (languageId != null) {
        final course = await getCourse(languageId);
        if (course != null) {
          results.addAll(await _searchInCourse(course, searchQuery));
        }
      } else {
        // Search in all courses
        for (final language in languages) {
          final course = await getCourse(language.id);
          if (course != null) {
            results.addAll(await _searchInCourse(course, searchQuery));
          }
        }
      }

      // Sort by relevance
      results.sort((a, b) => (b['relevance'] as double).compareTo(a['relevance'] as double));
      
      return results.map((result) => result['data']).toList();
    } catch (e) {
      print('Error searching content: $e');
      return [];
    }
  }

  // Search within a specific course
  Future<List<Map<String, dynamic>>> _searchInCourse(Course course, String query) async {
    final results = <Map<String, dynamic>>[];

    // Search in course info
    if (course.languageName.toLowerCase().contains(query) ||
        course.description.toLowerCase().contains(query)) {
      results.add({
        'type': 'course',
        'data': course,
        'relevance': _calculateRelevance(query, course.languageName + ' ' + course.description),
      });
    }

    // Search in levels and lessons
    for (final level in course.levels) {
      if (level.levelName.toLowerCase().contains(query) ||
          level.description.toLowerCase().contains(query)) {
        results.add({
          'type': 'level',
          'data': level,
          'relevance': _calculateRelevance(query, level.levelName + ' ' + level.description),
        });
      }

      for (final lesson in level.lessons) {
        if (lesson.lessonTitle.toLowerCase().contains(query) ||
            lesson.description.toLowerCase().contains(query)) {
          results.add({
            'type': 'lesson',
            'data': lesson,
            'relevance': _calculateRelevance(query, lesson.lessonTitle + ' ' + lesson.description),
          });
        }
      }
    }

    return results;
  }

  // Calculate search relevance score
  double _calculateRelevance(String query, String content) {
    final contentLower = content.toLowerCase();
    final queryLower = query.toLowerCase();
    
    double score = 0.0;
    
    // Exact match gets highest score
    if (contentLower.contains(queryLower)) {
      score += 1.0;
    }
    
    // Word matches
    final queryWords = queryLower.split(' ');
    final contentWords = contentLower.split(' ');
    
    for (final queryWord in queryWords) {
      for (final contentWord in contentWords) {
        if (contentWord.contains(queryWord)) {
          score += 0.5;
        }
      }
    }
    
    return score;
  }

  // Get all available lesson IDs for a language
  Future<List<String>> getLessonIds(String languageId) async {
    try {
      final course = await getCourse(languageId);
      if (course == null) return [];

      final lessonIds = <String>[];
      for (final level in course.levels) {
        for (final lesson in level.lessons) {
          lessonIds.add(lesson.lessonId);
        }
      }
      
      return lessonIds;
    } catch (e) {
      print('Error getting lesson IDs for language $languageId: $e');
      return [];
    }
  }

  // Get all available quiz IDs for a language
  Future<List<String>> getQuizIds(String languageId) async {
    try {
      final lessonIds = await getLessonIds(languageId);
      final quizIds = <String>[];
      
      // Add lesson quiz IDs
      for (final lessonId in lessonIds) {
        final quiz = await getLessonQuiz(lessonId);
        if (quiz != null) {
          quizIds.add(quiz.quizId);
        }
      }
      
      // Add level quiz IDs
      final course = await getCourse(languageId);
      if (course != null) {
        for (final level in course.levels) {
          final levelQuiz = await getLevelQuiz(level.levelId);
          if (levelQuiz != null) {
            quizIds.add(levelQuiz.quizId);
          }
        }
      }
      
      return quizIds;
    } catch (e) {
      print('Error getting quiz IDs for language $languageId: $e');
      return [];
    }
  }

  // Validate all JSON files
  Future<Map<String, List<String>>> validateAllJsonFiles() async {
    final errors = <String, List<String>>{};

    try {
      // Validate languages
      final languagesErrors = await _validateLanguagesJson();
      if (languagesErrors.isNotEmpty) {
        errors['languages'] = languagesErrors;
      }

      // Validate courses
      final languages = await getLanguages();
      for (final language in languages) {
        final courseErrors = await _validateCourseJson(language.id);
        if (courseErrors.isNotEmpty) {
          errors['course_${language.id}'] = courseErrors;
        }
      }
    } catch (e) {
      errors['validation'] = ['Error during validation: $e'];
    }

    return errors;
  }

  // Validate languages JSON
  Future<List<String>> _validateLanguagesJson() async {
    try {
      final jsonData = await _loadJsonFile(JsonPaths.languages);
      return JsonValidator.getJsonValidationErrors(jsonData, 'language');
    } catch (e) {
      return ['Error validating languages JSON: $e'];
    }
  }

  // Validate course JSON
  Future<List<String>> _validateCourseJson(String languageId) async {
    try {
      final coursePath = JsonPaths.getCoursePathForLanguage(languageId);
      final jsonData = await _loadJsonFile(coursePath);
      return JsonValidator.getJsonValidationErrors(jsonData, 'course');
    } catch (e) {
      return ['Error validating course JSON for $languageId: $e'];
    }
  }

  // Clear cache
  void clearCache() {
    _cache.clear();
  }

  // Get cache info
  Map<String, dynamic> getCacheInfo() {
    return {
      'cachedFiles': _cache.keys.toList(),
      'cacheSize': _cache.length,
    };
  }
}
