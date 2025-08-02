import '../entities/course_entity.dart';
import '../entities/language_entity.dart';
import '../repositories/course_repository_interface.dart';

class GetCourseUseCase {
  final CourseRepositoryInterface repository;

  GetCourseUseCase(this.repository);

  Future<CourseEntity?> execute(String languageId) async {
    try {
      if (languageId.isEmpty) {
        throw ArgumentError('Language ID cannot be empty');
      }

      // Validate that the language exists
      final languageExists = await repository.languageExists(languageId);
      if (!languageExists) {
        throw ArgumentError('Language with ID $languageId does not exist');
      }

      final course = await repository.getCourse(languageId);
      if (course == null) {
        print('Course not found for language: $languageId');
        return null;
      }

      // Validate course data integrity
      final isValid = await repository.validateCourseData(languageId);
      if (!isValid) {
        print('Course data validation failed for language: $languageId');
        return null;
      }

      return course;
    } catch (e) {
      print('Error in GetCourseUseCase: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>> getCourseStatistics(String languageId) async {
    try {
      if (languageId.isEmpty) {
        throw ArgumentError('Language ID cannot be empty');
      }

      return await repository.getCourseStatistics(languageId);
    } catch (e) {
      print('Error in GetCourseUseCase.getCourseStatistics: $e');
      return {
        'totalLevels': 0,
        'totalLessons': 0,
        'totalQuizzes': 0,
        'estimatedHours': 0,
      };
    }
  }

  Future<List<LevelEntity>> getCourseLevels(String languageId) async {
    try {
      final course = await execute(languageId);
      return course?.levels ?? [];
    } catch (e) {
      print('Error in GetCourseUseCase.getCourseLevels: $e');
      return [];
    }
  }

  Future<LevelEntity?> getCourseLevel(String languageId, String levelId) async {
    try {
      final levels = await getCourseLevels(languageId);
      try {
        return levels.firstWhere((level) => level.levelId == levelId);
      } catch (e) {
        return null;
      }
    } catch (e) {
      print('Error in GetCourseUseCase.getCourseLevel: $e');
      return null;
    }
  }

  Future<List<LessonEntity>> getAllLessons(String languageId) async {
    try {
      final course = await execute(languageId);
      if (course == null) return [];

      final allLessons = <LessonEntity>[];
      for (final level in course.levels) {
        allLessons.addAll(level.lessons);
      }

      // Sort lessons by order
      allLessons.sort((a, b) => a.order.compareTo(b.order));
      
      return allLessons;
    } catch (e) {
      print('Error in GetCourseUseCase.getAllLessons: $e');
      return [];
    }
  }

  Future<LessonEntity?> getLesson(String languageId, String lessonId) async {
    try {
      final allLessons = await getAllLessons(languageId);
      try {
        return allLessons.firstWhere((lesson) => lesson.lessonId == lessonId);
      } catch (e) {
        return null;
      }
    } catch (e) {
      print('Error in GetCourseUseCase.getLesson: $e');
      return null;
    }
  }

  Future<LessonEntity?> getNextLesson(String languageId, String currentLessonId) async {
    try {
      final allLessons = await getAllLessons(languageId);
      final currentIndex = allLessons.indexWhere((lesson) => lesson.lessonId == currentLessonId);
      
      if (currentIndex == -1 || currentIndex >= allLessons.length - 1) {
        return null; // Current lesson not found or is the last lesson
      }
      
      return allLessons[currentIndex + 1];
    } catch (e) {
      print('Error in GetCourseUseCase.getNextLesson: $e');
      return null;
    }
  }

  Future<LessonEntity?> getPreviousLesson(String languageId, String currentLessonId) async {
    try {
      final allLessons = await getAllLessons(languageId);
      final currentIndex = allLessons.indexWhere((lesson) => lesson.lessonId == currentLessonId);
      
      if (currentIndex <= 0) {
        return null; // Current lesson not found or is the first lesson
      }
      
      return allLessons[currentIndex - 1];
    } catch (e) {
      print('Error in GetCourseUseCase.getPreviousLesson: $e');
      return null;
    }
  }

  Future<int> getTotalEstimatedTime(String languageId) async {
    try {
      return await repository.getEstimatedCompletionTime(languageId);
    } catch (e) {
      print('Error in GetCourseUseCase.getTotalEstimatedTime: $e');
      return 0;
    }
  }

  Future<Map<String, dynamic>> getCourseProgress(
    String languageId,
    Map<String, bool> completedLessons,
    Map<String, bool> passedQuizzes,
  ) async {
    try {
      final course = await execute(languageId);
      if (course == null) {
        return {
          'overallProgress': 0.0,
          'levelProgress': <String, double>{},
          'completedLessons': 0,
          'totalLessons': 0,
          'passedQuizzes': 0,
          'totalQuizzes': 0,
        };
      }

      final totalLessons = course.levels.fold(0, (sum, level) => sum + level.lessons.length);
      final completedCount = completedLessons.values.where((completed) => completed).length;
      final passedQuizzesCount = passedQuizzes.values.where((passed) => passed).length;
      
      final levelProgress = <String, double>{};
      for (final level in course.levels) {
        final levelCompletedLessons = level.lessons
            .where((lesson) => completedLessons[lesson.lessonId] == true)
            .length;
        levelProgress[level.levelId] = level.lessons.isNotEmpty
            ? (levelCompletedLessons / level.lessons.length) * 100
            : 0.0;
      }

      return {
        'overallProgress': totalLessons > 0 ? (completedCount / totalLessons) * 100 : 0.0,
        'levelProgress': levelProgress,
        'completedLessons': completedCount,
        'totalLessons': totalLessons,
        'passedQuizzes': passedQuizzesCount,
        'totalQuizzes': await repository.getTotalQuizzesCount(languageId),
      };
    } catch (e) {
      print('Error in GetCourseUseCase.getCourseProgress: $e');
      return {
        'overallProgress': 0.0,
        'levelProgress': <String, double>{},
        'completedLessons': 0,
        'totalLessons': 0,
        'passedQuizzes': 0,
        'totalQuizzes': 0,
      };
    }
  }

  Future<bool> isCourseCompleted(
    String languageId,
    Map<String, bool> completedLessons,
  ) async {
    try {
      final allLessons = await getAllLessons(languageId);
      if (allLessons.isEmpty) return false;

      return allLessons.every((lesson) => completedLessons[lesson.lessonId] == true);
    } catch (e) {
      print('Error in GetCourseUseCase.isCourseCompleted: $e');
      return false;
    }
  }

  Future<List<LessonEntity>> getRecommendedLessons(
    String languageId,
    Map<String, bool> completedLessons,
    {int limit = 3}
  ) async {
    try {
      final allLessons = await getAllLessons(languageId);
      
      // Get incomplete lessons that are unlocked
      final incompleteLessons = allLessons
          .where((lesson) => completedLessons[lesson.lessonId] != true)
          .where((lesson) => lesson.isUnlocked)
          .take(limit)
          .toList();

      return incompleteLessons;
    } catch (e) {
      print('Error in GetCourseUseCase.getRecommendedLessons: $e');
      return [];
    }
  }
}
