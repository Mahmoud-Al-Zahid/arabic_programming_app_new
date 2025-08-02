import 'dart:convert';
import 'package:flutter/services.dart';
import '../data/models/language_model.dart';
import '../data/models/course_model.dart';
import '../data/models/lesson_model.dart';
import '../data/models/quiz_model.dart';

class JsonService {
  static const String _languagesPath = 'languages/languages.json';
  static const String _coursesPath = 'courses';
  static const String _lessonsPath = 'lessons';
  static const String _quizzesPath = 'quizzes';

  // Load languages
  Future<List<LanguageModel>> loadLanguages() async {
    try {
      final String jsonString = await rootBundle.loadString(_languagesPath);
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => LanguageModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load languages: $e');
    }
  }

  // Load course by language ID
  Future<CourseModel?> loadCourse(String languageId) async {
    try {
      final String jsonString = await rootBundle.loadString('$_coursesPath/$languageId.json');
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      return CourseModel.fromJson(jsonMap);
    } catch (e) {
      throw Exception('Failed to load course for $languageId: $e');
    }
  }

  // Load lesson by lesson ID
  Future<LessonModel?> loadLesson(String lessonId) async {
    try {
      // Extract language from lesson ID (e.g., "python_intro_01" -> "python")
      final parts = lessonId.split('_');
      if (parts.isEmpty) throw Exception('Invalid lesson ID format');
      
      final language = parts[0];
      final String jsonString = await rootBundle.loadString('$_lessonsPath/$language/$lessonId.json');
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      return LessonModel.fromJson(jsonMap);
    } catch (e) {
      throw Exception('Failed to load lesson $lessonId: $e');
    }
  }

  // Load quiz by quiz ID
  Future<QuizModel?> loadQuiz(String quizId) async {
    try {
      // Determine quiz type and path
      String quizPath;
      if (quizId.contains('_level_')) {
        // Level quiz
        quizPath = '$_quizzesPath/levels/$quizId.json';
      } else {
        // Lesson quiz
        quizPath = '$_quizzesPath/lessons/$quizId.json';
      }

      final String jsonString = await rootBundle.loadString(quizPath);
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      return QuizModel.fromJson(jsonMap);
    } catch (e) {
      throw Exception('Failed to load quiz $quizId: $e');
    }
  }

  // Load lessons by course ID
  Future<List<LessonModel>> loadLessonsByCourse(String courseId) async {
    try {
      final course = await loadCourse(courseId);
      if (course == null) return [];

      final List<LessonModel> lessons = [];
      for (final level in course.levels) {
        for (final lessonId in level.lessons) {
          final lesson = await loadLesson(lessonId);
          if (lesson != null) {
            lessons.add(lesson);
          }
        }
      }
      return lessons;
    } catch (e) {
      throw Exception('Failed to load lessons for course $courseId: $e');
    }
  }
}
