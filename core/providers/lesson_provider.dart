import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/course_repository.dart';
import '../data/models/lesson_model.dart';
import '../data/models/quiz_model.dart';
import '../services/json_service.dart';

// Lesson Repository Provider
final lessonRepositoryProvider = Provider<CourseRepository>((ref) {
  return CourseRepository();
});

// Lesson by ID Provider
final lessonByIdProvider = FutureProvider.family<Lesson?, String>((ref, lessonId) async {
  final jsonService = ref.read(jsonServiceProvider);
  return await jsonService.loadLesson(lessonId);
});

// Quiz by ID Provider
final quizByIdProvider = FutureProvider.family<Quiz?, String>((ref, quizId) async {
  final jsonService = ref.read(jsonServiceProvider);
  return await jsonService.loadQuiz(quizId);
});

// Lesson Quiz Provider
final lessonQuizProvider = FutureProvider.family<Quiz?, String>((ref, lessonId) async {
  final repository = ref.read(lessonRepositoryProvider);
  return await repository.getLessonQuiz(lessonId);
});

// Level Quiz Provider
final levelQuizProvider = FutureProvider.family<Quiz?, String>((ref, levelId) async {
  final repository = ref.read(lessonRepositoryProvider);
  return await repository.getLevelQuiz(levelId);
});

// Lesson Progress Provider
final lessonProgressProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, lessonId) async {
  // This would typically get progress from user data
  // For now, return mock progress
  return {
    'isCompleted': false,
    'isUnlocked': true,
    'timeSpent': 0,
    'attempts': 0,
    'score': null,
  };
});

// Next Lesson Provider
final nextLessonProvider = FutureProvider.family<Lesson?, Map<String, String>>((ref, params) async {
  final courseId = params['courseId']!;
  final currentLessonId = params['currentLessonId']!;
  
  final lessons = await ref.read(lessonsByCourseIdProvider(courseId).future);
  final currentIndex = lessons.indexWhere((lesson) => lesson.lessonId == currentLessonId);
  
  if (currentIndex == -1 || currentIndex >= lessons.length - 1) {
    return null;
  }
  
  return lessons[currentIndex + 1];
});

// Previous Lesson Provider
final previousLessonProvider = FutureProvider.family<Lesson?, Map<String, String>>((ref, params) async {
  final courseId = params['courseId']!;
  final currentLessonId = params['currentLessonId']!;
  
  final lessons = await ref.read(lessonsByCourseIdProvider(courseId).future);
  final currentIndex = lessons.indexWhere((lesson) => lesson.lessonId == currentLessonId);
  
  if (currentIndex <= 0) {
    return null;
  }
  
  return lessons[currentIndex - 1];
});

// Lesson Access Provider
final lessonAccessProvider = FutureProvider.family<bool, Map<String, dynamic>>((ref, params) async {
  final lessonId = params['lessonId'] as String;
  final lessonOrder = params['lessonOrder'] as int;
  
  // First lesson is always accessible
  if (lessonOrder == 1) return true;
  
  // This would typically check user progress
  // For now, return true for all lessons
  return true;
});

// Lesson Statistics Provider
final lessonStatisticsProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, lessonId) async {
  final lesson = await ref.read(lessonByIdProvider(lessonId).future);
  
  if (lesson == null) {
    return {
      'estimatedMinutes': 0,
      'slidesCount': 0,
      'hasQuiz': false,
      'difficulty': 'مبتدئ',
    };
  }
  
  return {
    'estimatedMinutes': lesson.estimatedMinutes,
    'slidesCount': lesson.slides.length,
    'hasQuiz': lesson.quiz != null,
    'difficulty': lesson.difficulty,
  };
});
