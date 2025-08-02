import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/course_repository.dart';
import '../data/models/course_model.dart';
import '../data/models/lesson_model.dart';
import '../services/json_service.dart';

// Course Repository Provider
final courseRepositoryProvider = Provider<CourseRepository>((ref) {
  return CourseRepository();
});

// JSON Service Provider
final jsonServiceProvider = Provider<JsonService>((ref) {
  return JsonService();
});

// Course by ID Provider
final courseByIdProvider = FutureProvider.family<Course?, String>((ref, courseId) async {
  final repository = ref.read(courseRepositoryProvider);
  return await repository.getCourse(courseId);
});

// Lessons by Course ID Provider
final lessonsByCourseIdProvider = FutureProvider.family<List<Lesson>, String>((ref, courseId) async {
  final jsonService = ref.read(jsonServiceProvider);
  return await jsonService.loadLessonsByCourse(courseId);
});

// All Courses Provider
final allCoursesProvider = FutureProvider<List<Course>>((ref) async {
  final repository = ref.read(courseRepositoryProvider);
  final languages = await repository.getLanguages();
  
  final courses = <Course>[];
  for (final language in languages) {
    final course = await repository.getCourse(language.id);
    if (course != null) {
      courses.add(course);
    }
  }
  
  return courses;
});

// Course Statistics Provider
final courseStatisticsProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, courseId) async {
  final repository = ref.read(courseRepositoryProvider);
  final course = await repository.getCourse(courseId);
  
  if (course == null) {
    return {
      'totalLevels': 0,
      'totalLessons': 0,
      'estimatedHours': 0,
    };
  }
  
  final totalLessons = course.levels.fold(0, (sum, level) => sum + level.lessons.length);
  
  return {
    'totalLevels': course.levels.length,
    'totalLessons': totalLessons,
    'estimatedHours': course.estimatedHours,
  };
});

// Search Courses Provider
final searchCoursesProvider = FutureProvider.family<List<Course>, String>((ref, query) async {
  if (query.isEmpty) return [];
  
  final allCourses = await ref.read(allCoursesProvider.future);
  
  return allCourses.where((course) {
    return course.languageName.toLowerCase().contains(query.toLowerCase()) ||
           course.description.toLowerCase().contains(query.toLowerCase());
  }).toList();
});

// Course Progress Provider
final courseProgressProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, courseId) async {
  // This would typically get progress from user data
  // For now, return mock progress
  return {
    'completedLessons': 0,
    'totalLessons': 10,
    'progressPercentage': 0.0,
    'currentLesson': null,
  };
});
