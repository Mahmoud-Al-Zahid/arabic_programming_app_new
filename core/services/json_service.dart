import 'dart:convert';
import 'package:flutter/services.dart';
import '../data/models/language_model.dart';
import '../data/models/course_model.dart';
import '../data/models/lesson_model.dart';
import '../data/models/quiz_model.dart';

class JsonService {
  Future<List<LanguageModel>> loadLanguages() async {
    try {
      final String response = await rootBundle.loadString('assets/languages/languages.json');
      final Map<String, dynamic> data = json.decode(response);
      final List<dynamic> languagesJson = data['languages'];
      return languagesJson.map((json) => LanguageModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load languages: $e');
    }
  }

  Future<CourseModel?> loadCourse(String courseId) async {
    try {
      final String response = await rootBundle.loadString('assets/courses/$courseId.json');
      final Map<String, dynamic> data = json.decode(response);
      return CourseModel.fromJson(data);
    } catch (e) {
      return null;
    }
  }

  Future<List<CourseModel>> loadCoursesByLanguage(String languageId) async {
    try {
      // This would typically load multiple courses for a language
      final course = await loadCourse(languageId);
      return course != null ? [course] : [];
    } catch (e) {
      return [];
    }
  }

  Future<List<LessonModel>> loadLessonsByCourse(String courseId) async {
    try {
      // Load course first to get lesson IDs
      final course = await loadCourse(courseId);
      if (course?.levels == null) return [];

      List<LessonModel> lessons = [];
      
      for (final level in course!.levels!) {
        if (level.lessons != null) {
          for (final lessonId in level.lessons!) {
            final lesson = await loadLesson(lessonId);
            if (lesson != null) {
              lessons.add(lesson);
            }
          }
        }
      }
      
      return lessons;
    } catch (e) {
      return [];
    }
  }

  Future<LessonModel?> loadLesson(String lessonId) async {
    try {
      // Try different paths for lesson files
      final paths = [
        'assets/lessons/python/$lessonId.json',
        'assets/lessons/$lessonId.json',
      ];
      
      for (final path in paths) {
        try {
          final String response = await rootBundle.loadString(path);
          final Map<String, dynamic> data = json.decode(response);
          return LessonModel.fromJson(data);
        } catch (e) {
          continue;
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<QuizModel?> loadQuiz(String quizId) async {
    try {
      // Try different paths for quiz files
      final paths = [
        'assets/quizzes/lessons/$quizId.json',
        'assets/quizzes/levels/$quizId.json',
        'assets/quizzes/$quizId.json',
      ];
      
      for (final path in paths) {
        try {
          final String response = await rootBundle.loadString(path);
          final Map<String, dynamic> data = json.decode(response);
          return QuizModel.fromJson(data);
        } catch (e) {
          continue;
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
