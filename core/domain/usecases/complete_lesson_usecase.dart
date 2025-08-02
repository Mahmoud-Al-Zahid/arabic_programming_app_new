import '../entities/user_entity.dart';
import '../repositories/progress_repository_interface.dart';
import '../../services/validation_service.dart';

class CompleteLessonUseCase {
  final ProgressRepositoryInterface repository;

  CompleteLessonUseCase(this.repository);

  Future<bool> execute({
    required String userId,
    required String languageId,
    required String lessonId,
    required int timeSpent,
    double? score,
  }) async {
    try {
      // Validate input parameters
      if (!_validateInput(userId, languageId, lessonId, timeSpent)) {
        return false;
      }

      // Check if user exists
      final user = await repository.getCurrentUser();
      if (user == null || user.id != userId) {
        print('User not found or ID mismatch');
        return false;
      }

      // Validate time spent
      if (!ValidationService.isValidTimeSpent(timeSpent)) {
        print('Invalid time spent: $timeSpent');
        return false;
      }

      // Validate score if provided
      if (score != null && !ValidationService.isValidQuizScore(score)) {
        print('Invalid score: $score');
        return false;
      }

      // Complete the lesson
      final success = await repository.completeLesson(
        userId,
        languageId,
        lessonId,
        timeSpent,
        score: score,
      );

      if (success) {
        print('Lesson completed successfully: $lessonId');
        
        // Check for achievements or milestones
        await _checkForAchievements(userId, languageId, lessonId);
      } else {
        print('Failed to complete lesson: $lessonId');
      }

      return success;
    } catch (e) {
      print('Error in CompleteLessonUseCase: $e');
      return false;
    }
  }

  Future<bool> canCompleteLesson({
    required String userId,
    required String languageId,
    required String lessonId,
    required int lessonOrder,
  }) async {
    try {
      if (!_validateBasicInput(userId, languageId, lessonId)) {
        return false;
      }

      return await repository.canAccessLesson(
        userId,
        languageId,
        lessonId,
        lessonOrder,
      );
    } catch (e) {
      print('Error in CompleteLessonUseCase.canCompleteLesson: $e');
      return false;
    }
  }

  Future<bool> isLessonCompleted({
    required String userId,
    required String languageId,
    required String lessonId,
  }) async {
    try {
      if (!_validateBasicInput(userId, languageId, lessonId)) {
        return false;
      }

      return await repository.isLessonCompleted(userId, languageId, lessonId);
    } catch (e) {
      print('Error in CompleteLessonUseCase.isLessonCompleted: $e');
      return false;
    }
  }

  Future<LessonProgressEntity?> getLessonProgress({
    required String userId,
    required String languageId,
    required String lessonId,
  }) async {
    try {
      if (!_validateBasicInput(userId, languageId, lessonId)) {
        return null;
      }

      return await repository.getLessonProgress(userId, languageId, lessonId);
    } catch (e) {
      print('Error in CompleteLessonUseCase.getLessonProgress: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>> getLessonStatistics({
    required String userId,
    required String languageId,
    required String lessonId,
  }) async {
    try {
      final progress = await getLessonProgress(
        userId: userId,
        languageId: languageId,
        lessonId: lessonId,
      );

      if (progress == null) {
        return {
          'isCompleted': false,
          'timeSpent': 0,
          'attempts': 0,
          'score': null,
          'completedAt': null,
        };
      }

      return {
        'isCompleted': progress.isCompleted,
        'timeSpent': progress.timeSpent,
        'attempts': progress.attempts,
        'score': progress.score,
        'completedAt': progress.completedAt?.toIso8601String(),
      };
    } catch (e) {
      print('Error in CompleteLessonUseCase.getLessonStatistics: $e');
      return {
        'isCompleted': false,
        'timeSpent': 0,
        'attempts': 0,
        'score': null,
        'completedAt': null,
      };
    }
  }

  // Private helper methods
  bool _validateInput(String userId, String languageId, String lessonId, int timeSpent) {
    if (!_validateBasicInput(userId, languageId, lessonId)) {
      return false;
    }

    if (timeSpent < 0) {
      print('Time spent cannot be negative');
      return false;
    }

    if (timeSpent > 86400) { // More than 24 hours
      print('Time spent seems unrealistic: $timeSpent seconds');
      return false;
    }

    return true;
  }

  bool _validateBasicInput(String userId, String languageId, String lessonId) {
    if (!ValidationService.isValidUserId(userId)) {
      print('Invalid user ID: $userId');
      return false;
    }

      {
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

    return true;
  }

  Future<void> _checkForAchievements(String userId, String languageId, String lessonId) async {
    try {
      // Check for first lesson completion achievement
      final user = await repository.getCurrentUser();
      if (user == null) return;

      final languageProgress = user.progress.languages[languageId];
      if (languageProgress == null) return;

      final completedLessons = languageProgress.lessons.values
          .where((lesson) => lesson.isCompleted)
          .length;

      // First lesson achievement
      if (completedLessons == 1) {
        await repository.addAchievement(userId, 'first_lesson_completed');
      }

      // Multiple lesson milestones
      if (completedLessons == 5) {
        await repository.addAchievement(userId, 'five_lessons_completed');
      } else if (completedLessons == 10) {
        await repository.addAchievement(userId, 'ten_lessons_completed');
      } else if (completedLessons == 25) {
        await repository.addAchievement(userId, 'twenty_five_lessons_completed');
      }

      // Check for level completion
      // This would require additional logic to determine if a level is completed
    } catch (e) {
      print('Error checking for achievements: $e');
    }
  }
}
