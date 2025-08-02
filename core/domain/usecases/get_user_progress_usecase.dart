import '../entities/user_entity.dart';
import '../repositories/progress_repository_interface.dart';
import '../../services/validation_service.dart';

class GetUserProgressUseCase {
  final ProgressRepositoryInterface repository;

  GetUserProgressUseCase(this.repository);

  Future<UserEntity?> execute() async {
    try {
      return await repository.getCurrentUser();
    } catch (e) {
      print('Error in GetUserProgressUseCase: $e');
      return null;
    }
  }

  Future<UserProgressEntity?> getUserProgress(String userId) async {
    try {
      if (!ValidationService.isValidUserId(userId)) {
        print('Invalid user ID: $userId');
        return null;
      }

      final user = await repository.getCurrentUser();
      if (user == null || user.id != userId) {
        print('User not found or ID mismatch');
        return null;
      }

      return user.progress;
    } catch (e) {
      print('Error in GetUserProgressUseCase.getUserProgress: $e');
      return null;
    }
  }

  Future<LanguageProgressEntity?> getLanguageProgress({
    required String userId,
    required String languageId,
  }) async {
    try {
      if (!ValidationService.isValidUserId(userId) || 
          !ValidationService.isValidLanguageId(languageId)) {
        return null;
      }

      return await repository.getLanguageProgress(userId, languageId);
    } catch (e) {
      print('Error in GetUserProgressUseCase.getLanguageProgress: $e');
      return null;
    }
  }

  Future<UserStatsEntity?> getUserStats(String userId) async {
    try {
      if (!ValidationService.isValidUserId(userId)) {
        print('Invalid user ID: $userId');
        return null;
      }

      return await repository.getUserStats(userId);
    } catch (e) {
      print('Error in GetUserProgressUseCase.getUserStats: $e');
      return null;
    }
  }

  Future<double> getOverallProgress(String userId) async {
    try {
      if (!ValidationService.isValidUserId(userId)) {
        print('Invalid user ID: $userId');
        return 0.0;
      }

      return await repository.getOverallProgress(userId);
    } catch (e) {
      print('Error in GetUserProgressUseCase.getOverallProgress: $e');
      return 0.0;
    }
  }

  Future<Map<String, dynamic>> getLevelProgress(String userId) async {
    try {
      if (!ValidationService.isValidUserId(userId)) {
        print('Invalid user ID: $userId');
        return {
          'currentLevel': 1,
          'currentXP': 0,
          'xpForNextLevel': 100,
          'progressPercentage': 0.0,
        };
      }

      return await repository.getLevelProgress(userId);
    } catch (e) {
      print('Error in GetUserProgressUseCase.getLevelProgress: $e');
      return {
        'currentLevel': 1,
        'currentXP': 0,
        'xpForNextLevel': 100,
        'progressPercentage': 0.0,
      };
    }
  }

  Future<Map<String, dynamic>> getProgressSummary(String userId) async {
    try {
      final user = await repository.getCurrentUser();
      if (user == null || user.id != userId) {
        return _getEmptyProgressSummary();
      }

      final overallProgress = await getOverallProgress(userId);
      final levelProgress = await getLevelProgress(userId);
      
      // Calculate language-specific progress
      final languageProgress = <String, Map<String, dynamic>>{};
      for (final entry in user.progress.languages.entries) {
        final languageId = entry.key;
        final progress = entry.value;
        
        languageProgress[languageId] = {
          'progressPercentage': progress.progressPercentage,
          'completedLessons': progress.lessons.values.where((l) => l.isCompleted).length,
          'totalLessons': progress.lessons.length,
          'passedQuizzes': progress.quizResults.values.where((q) => q.passed).length,
          'totalQuizzes': progress.quizResults.length,
          'timeSpent': progress.totalTimeSpent,
          'lastAccessed': progress.lastAccessed.toIso8601String(),
          'isCompleted': progress.isCompleted,
        };
      }

      return {
        'user': {
          'id': user.id,
          'name': user.name,
          'level': user.level,
          'xp': user.xp,
          'coins': user.coins,
          'streak': user.streak,
          'joinDate': user.joinDate.toIso8601String(),
        },
        'overallProgress': overallProgress,
        'levelProgress': levelProgress,
        'languageProgress': languageProgress,
        'stats': {
          'totalLessonsCompleted': user.stats.totalLessonsCompleted,
          'totalQuizzesPassed': user.stats.totalQuizzesPassed,
          'totalTimeSpent': user.stats.totalTimeSpent,
          'averageQuizScore': user.stats.averageQuizScore,
          'longestStreak': user.stats.longestStreak,
        },
        'achievements': user.achievements,
        'currentLanguage': user.progress.currentLanguage,
        'totalLanguages': user.progress.languages.length,
        'completedLanguages': user.progress.languages.values
            .where((lang) => lang.isCompleted)
            .length,
      };
    } catch (e) {
      print('Error in GetUserProgressUseCase.getProgressSummary: $e');
      return _getEmptyProgressSummary();
    }
  }

  Future<List<Map<String, dynamic>>> getRecentActivity(String userId, {int limit = 10}) async {
    try {
      final user = await repository.getCurrentUser();
      if (user == null || user.id != userId) {
        return [];
      }

      final activities = <Map<String, dynamic>>[];

      // Collect recent lesson completions
      for (final languageEntry in user.progress.languages.entries) {
        final languageId = languageEntry.key;
        final languageProgress = languageEntry.value;

        for (final lessonEntry in languageProgress.lessons.entries) {
          final lessonId = lessonEntry.key;
          final lessonProgress = lessonEntry.value;

          if (lessonProgress.isCompleted && lessonProgress.completedAt != null) {
            activities.add({
              'type': 'lesson_completed',
              'languageId': languageId,
              'itemId': lessonId,
              'completedAt': lessonProgress.completedAt!,
              'timeSpent': lessonProgress.timeSpent,
              'score': lessonProgress.score,
            });
          }
        }

        // Collect recent quiz completions
        for (final quizEntry in languageProgress.quizResults.entries) {
          final quizId = quizEntry.key;
          final quizResult = quizEntry.value;

          activities.add({
            'type': 'quiz_completed',
            'languageId': languageId,
            'itemId': quizId,
            'completedAt': quizResult.completedAt,
            'score': quizResult.score,
            'passed': quizResult.passed,
            'timeSpent': quizResult.timeSpent,
          });
        }
      }

      // Sort by completion date (most recent first)
      activities.sort((a, b) => (b['completedAt'] as DateTime).compareTo(a['completedAt'] as DateTime));

      // Return limited results
      return activities.take(limit).toList();
    } catch (e) {
      print('Error in GetUserProgressUseCase.getRecentActivity: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> getStreakInfo(String userId) async {
    try {
      final user = await repository.getCurrentUser();
      if (user == null || user.id != userId) {
        return {
          'currentStreak': 0,
          'longestStreak': 0,
          'lastActivityDate': null,
          'streakStatus': 'inactive',
        };
      }

      final now = DateTime.now();
      final activities = await getRecentActivity(userId, limit: 100);
      
      // Calculate current streak
      int currentStreak = 0;
      DateTime? lastActivityDate;
      
      if (activities.isNotEmpty) {
        lastActivityDate = activities.first['completedAt'] as DateTime;
        
        // Check if activity was today or yesterday
        final daysSinceLastActivity = now.difference(lastActivityDate).inDays;
        
        if (daysSinceLastActivity <= 1) {
          // Count consecutive days with activity
          final activityDates = activities
              .map((activity) => activity['completedAt'] as DateTime)
              .map((date) => DateTime(date.year, date.month, date.day))
              .toSet()
              .toList();
          
          activityDates.sort((a, b) => b.compareTo(a));
          
          DateTime currentDate = DateTime(now.year, now.month, now.day);
          for (final activityDate in activityDates) {
            if (activityDate == currentDate || 
                activityDate == currentDate.subtract(const Duration(days: 1))) {
              currentStreak++;
              currentDate = activityDate.subtract(const Duration(days: 1));
            } else {
              break;
            }
          }
        }
      }

      String streakStatus;
      if (currentStreak == 0) {
        streakStatus = 'inactive';
      } else if (currentStreak >= 7) {
        streakStatus = 'fire';
      } else if (currentStreak >= 3) {
        streakStatus = 'good';
      } else {
        streakStatus = 'building';
      }

      return {
        'currentStreak': currentStreak,
        'longestStreak': user.stats.longestStreak,
        'lastActivityDate': lastActivityDate?.toIso8601String(),
        'streakStatus': streakStatus,
      };
    } catch (e) {
      print('Error in GetUserProgressUseCase.getStreakInfo: $e');
      return {
        'currentStreak': 0,
        'longestStreak': 0,
        'lastActivityDate': null,
        'streakStatus': 'inactive',
      };
    }
  }

  Future<Map<String, dynamic>?> exportUserData(String userId) async {
    try {
      if (!ValidationService.isValidUserId(userId)) {
        print('Invalid user ID: $userId');
        return null;
      }

      return await repository.exportUserData(userId);
    } catch (e) {
      print('Error in GetUserProgressUseCase.exportUserData: $e');
      return null;
    }
  }

  Map<String, dynamic> _getEmptyProgressSummary() {
    return {
      'user': {
        'id': '',
        'name': '',
        'level': 1,
        'xp': 0,
        'coins': 0,
        'streak': 0,
        'joinDate': DateTime.now().toIso8601String(),
      },
      'overallProgress': 0.0,
      'levelProgress': {
        'currentLevel': 1,
        'currentXP': 0,
        'xpForNextLevel': 100,
        'progressPercentage': 0.0,
      },
      'languageProgress': <String, Map<String, dynamic>>{},
      'stats': {
        'totalLessonsCompleted': 0,
        'totalQuizzesPassed': 0,
        'totalTimeSpent': 0,
        'averageQuizScore': 0.0,
        'longestStreak': 0,
      },
      'achievements': <String>[],
      'currentLanguage': '',
      'totalLanguages': 0,
      'completedLanguages': 0,
    };
  }
}
