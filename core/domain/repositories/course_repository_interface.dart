import '../entities/language_entity.dart';
import '../entities/course_entity.dart';
import '../entities/lesson_entity.dart';

abstract class CourseRepositoryInterface {
  /// Get all available programming languages
  Future<List<LanguageEntity>> getLanguages();

  /// Get course details for a specific language
  Future<CourseEntity?> getCourse(String languageId);

  /// Get a lesson for a specific language and lesson ID
  Future<LessonEntity?> getLesson(String languageId, String lessonId);

  /// Get all lessons for a specific level of a language
  Future<List<LessonEntity>> getLessonsForLevel(String languageId, String levelId);

  /// Search for content across languages, courses, and lessons
  Future<List<dynamic>> searchContent(String query, {String? languageId});

  /// Check if a language is available
  Future<bool> isLanguageAvailable(String languageId);

  /// Check if a lesson is available for a specific language
  Future<bool> isLessonAvailable(String languageId, String lessonId);

  /// Get the content of a specific lesson
  Future<Map<String, dynamic>?> getLessonContent(String languageId, String lessonId);

  /// Clear the cache
  Future<void> clearCache();

  /// Preload a course for a specific language
  Future<void> preloadCourse(String languageId);

  /// Get a specific language by ID
  Future<LanguageEntity?> getLanguage(String languageId) async {
    final languages = await getLanguages();
    try {
      return languages.firstWhere((lang) => lang.id == languageId);
    } catch (e) {
      return null;
    }
  }

  /// Check if a language exists
  Future<bool> languageExists(String languageId) async {
    final language = await getLanguage(languageId);
    return language != null;
  }

  /// Get popular languages
  Future<List<LanguageEntity>> getPopularLanguages() async {
    final languages = await getLanguages();
    return languages.where((lang) => lang.isPopular).toList();
  }

  /// Get languages by difficulty level
  Future<List<LanguageEntity>> getLanguagesByDifficulty(String difficulty) async {
    final languages = await getLanguages();
    return languages.where((lang) => lang.difficulty == difficulty).toList();
  }

  /// Get total number of lessons for a language
  Future<int> getTotalLessonsCount(String languageId) async {
    final course = await getCourse(languageId);
    if (course == null) return 0;
    
    return course.levels.fold(0, (total, level) => total + level.lessons.length);
  }

  /// Get total number of quizzes for a language
  Future<int> getTotalQuizzesCount(String languageId) async {
    final course = await getCourse(languageId);
    if (course == null) return 0;
    
    int totalQuizzes = 0;
    for (final level in course.levels) {
      // Count lesson quizzes
      totalQuizzes += level.lessons.where((lesson) => lesson.quizId != null).length;
      // Add level quiz (assuming each level has one)
      totalQuizzes += 1;
    }
    
    return totalQuizzes;
  }

  /// Get estimated completion time for a language
  Future<int> getEstimatedCompletionTime(String languageId) async {
    final course = await getCourse(languageId);
    return course?.estimatedHours ?? 0;
  }

  /// Validate course data integrity
  Future<bool> validateCourseData(String languageId) async {
    try {
      final course = await getCourse(languageId);
      if (course == null) return false;

      // Check if course has levels
      if (course.levels.isEmpty) return false;

      // Check if each level has lessons
      for (final level in course.levels) {
        if (level.lessons.isEmpty) return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get course statistics
  Future<Map<String, dynamic>> getCourseStatistics(String languageId) async {
    final course = await getCourse(languageId);
    if (course == null) {
      return {
        'totalLevels': 0,
        'totalLessons': 0,
        'totalQuizzes': 0,
        'estimatedHours': 0,
      };
    }

    return {
      'totalLevels': course.levels.length,
      'totalLessons': await getTotalLessonsCount(languageId),
      'totalQuizzes': await getTotalQuizzesCount(languageId),
      'estimatedHours': course.estimatedHours,
    };
  }
}
