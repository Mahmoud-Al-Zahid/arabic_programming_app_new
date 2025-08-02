import '../repositories/progress_repository_interface.dart';
import '../../services/validation_service.dart';

class CheckLessonAccessUseCase {
  final ProgressRepositoryInterface repository;

  CheckLessonAccessUseCase(this.repository);

  Future<bool> execute({
    required String userId,
    required String languageId,
    required String lessonId,
    required int lessonOrder,
  }) async {
    try {
      // Validate input parameters
      if (!_validateInput(userId, languageId, lessonId, lessonOrder)) {
        return false;
      }

      // Check if user exists
      final user = await repository.getCurrentUser();
      if (user == null || user.id != userId) {
        print('User not found or ID mismatch');
        return lessonOrder == 1; // First lesson is always accessible for new users
      }

      // Check lesson access
      return await repository.canAccessLesson(
        userId,
        languageId,
        lessonId,
        lessonOrder,
      );
    } catch (e) {
      print('Error in CheckLessonAccessUseCase: $e');
      return lessonOrder == 1; // Default to first lesson being accessible
    }
  }

  Future<Map<String, dynamic>> getLessonAccessInfo({
    required String userId,
    required String languageId,
    required String lessonId,
    required int lessonOrder,
  }) async {
    try {
      final canAccess = await execute(
        userId: userId,
        languageId: languageId,
        lessonId: lessonId,
        lessonOrder: lessonOrder,
      );

      final user = await repository.getCurrentUser();
      if (user == null || user.id != userId) {
        return {
          'canAccess': lessonOrder == 1,
          'reason': lessonOrder == 1 ? 'First lesson is always accessible' : 'User not found',
          'requirements': lessonOrder > 1 ? ['Complete previous lessons'] : [],
          'isCompleted': false,
        };
      }

      final languageProgress = user.progress.languages[languageId];
      final lessonProgress = languageProgress?.lessons[lessonId];
      final isCompleted = lessonProgress?.isCompleted ?? false;

      String reason;
      List<String> requirements = [];

      if (canAccess) {
        reason = isCompleted ? 'Lesson already completed' : 'Lesson is accessible';
      } else {
        reason = 'Prerequisites not met';
        if (lessonOrder > 1) {
          requirements.add('Complete lesson ${lessonOrder - 1}');
        }
      }

      return {
        'canAccess': canAccess,
        'reason': reason,
        'requirements': requirements,
        'isCompleted': isCompleted,
        'lessonOrder': lessonOrder,
        'completedLessons': languageProgress?.lessons.values
            .where((lesson) => lesson.isCompleted)
            .length ?? 0,
      };
    } catch (e) {
      print('Error in CheckLessonAccessUseCase.getLessonAccessInfo: $e');
      return {
        'canAccess': lessonOrder == 1,
        'reason': 'Error occurred',
        'requirements': [],
        'isCompleted': false,
      };
    }
  }

  Future<List<String>> getAccessibleLessons({
    required String userId,
    required String languageId,
    required List<String> allLessonIds,
  }) async {
    try {
      if (!ValidationService.isValidUserId(userId) || 
          !ValidationService.isValidLanguageId(languageId)) {
        return [];
      }

      final accessibleLessons = <String>[];
      
      for (int i = 0; i < allLessonIds.length; i++) {
        final lessonId = allLessonIds[i];
        final canAccess = await execute(
          userId: userId,
          languageId: languageId,
          lessonId: lessonId,
          lessonOrder: i + 1,
        );

        if (canAccess) {
          accessibleLessons.add(lessonId);
        }
      }

      return accessibleLessons;
    } catch (e) {
      print('Error in CheckLessonAccessUseCase.getAccessibleLessons: $e');
      return [];
    }
  }

  Future<String?> getNextAccessibleLesson({
    required String userId,
    required String languageId,
    required List<String> allLessonIds,
  }) async {
    try {
      final user = await repository.getCurrentUser();
      if (user == null || user.id != userId) return null;

      final languageProgress = user.progress.languages[languageId];
      if (languageProgress == null) {
        // If no progress, return first lesson
        return allLessonIds.isNotEmpty ? allLessonIds.first : null;
      }

      // Find the first incomplete but accessible lesson
      for (int i = 0; i < allLessonIds.length; i++) {
        final lessonId = allLessonIds[i];
        final lessonProgress = languageProgress.lessons[lessonId];
        
        // If lesson is not completed
        if (lessonProgress == null || !lessonProgress.isCompleted) {
          final canAccess = await execute(
            userId: userId,
            languageId: languageId,
            lessonId: lessonId,
            lessonOrder: i + 1,
          );

          if (canAccess) {
            return lessonId;
          }
        }
      }

      return null; // All lessons completed or none accessible
    } catch (e) {
      print('Error in CheckLessonAccessUseCase.getNextAccessibleLesson: $e');
      return null;
    }
  }

  Future<Map<String, bool>> getLessonAccessMap({
    required String userId,
    required String languageId,
    required List<String> allLessonIds,
  }) async {
    try {
      final accessMap = <String, bool>{};
      
      for (int i = 0; i < allLessonIds.length; i++) {
        final lessonId = allLessonIds[i];
        final canAccess = await execute(
          userId: userId,
          languageId: languageId,
          lessonId: lessonId,
          lessonOrder: i + 1,
        );

        accessMap[lessonId] = canAccess;
      }

      return accessMap;
    } catch (e) {
      print('Error in CheckLessonAccessUseCase.getLessonAccessMap: $e');
      return {};
    }
  }

  Future<int> getAccessibleLessonsCount({
    required String userId,
    required String languageId,
    required List<String> allLessonIds,
  }) async {
    try {
      final accessibleLessons = await getAccessibleLessons(
        userId: userId,
        languageId: languageId,
        allLessonIds: allLessonIds,
      );

      return accessibleLessons.length;
    } catch (e) {
      print('Error in CheckLessonAccessUseCase.getAccessibleLessonsCount: $e');
      return 0;
    }
  }

  // Private helper methods
  bool _validateInput(String userId, String languageId, String lessonId, int lessonOrder) {
    if (!ValidationService.isValidUserId(userId)) {
      print('Invalid user ID: $userId');
      return false;
    }

    if (!ValidationService.isValidLanguageId(languageId)) {
      print('Invalid language ID: $languageId');
      return false;
    }

    if (!ValidationService.isValidLessonId(lessonId)) {
      print('Invalid lesson ID: $lessonId');
      return false;
    }

    if (lessonOrder < 1) {
      print('Invalid lesson order: $lessonOrder');
      return false;
    }

    return true;
  }
}
