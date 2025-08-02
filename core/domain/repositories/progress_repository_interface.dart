import '../entities/user_entity.dart';
import 'dart:convert';

abstract class ProgressRepositoryInterface {
  /// Get the current user
  Future<UserEntity?> getCurrentUser();

  /// Create a new user
  Future<UserEntity?> createUser(String name, String email);

  /// Complete a lesson and update progress
  Future<bool> completeLesson(
    String userId,
    String languageId,
    String lessonId,
    int timeSpent, {
    double? score,
  });

  /// Complete a quiz and update progress
  Future<bool> completeQuiz(
    String userId,
    String languageId,
    String quizId,
    QuizResultEntity quizResult,
  );

  /// Check if user can access a specific lesson
  Future<bool> canAccessLesson(
    String userId,
    String languageId,
    String lessonId,
    int lessonOrder,
  );

  /// Check if user can access a specific level
  Future<bool> canAccessLevel(
    String userId,
    String languageId,
    String levelId,
    int levelOrder,
  );

  /// Update user profile information
  Future<bool> updateUserProfile({
    required String userId,
    String? name,
    String? email,
    String? avatar,
  }) async {
    // Default implementation - should be overridden
    return false;
  }

  /// Update user preferences
  Future<bool> updateUserPreferences(
    String userId,
    UserPreferencesEntity preferences,
  ) async {
    // Default implementation - should be overridden
    return false;
  }

  /// Add XP to user
  Future<bool> addXP(String userId, int xp) async {
    // Default implementation - should be overridden
    return false;
  }

  /// Add coins to user
  Future<bool> addCoins(String userId, int coins) async {
    // Default implementation - should be overridden
    return false;
  }

  /// Update user streak
  Future<bool> updateStreak(String userId, int streak) async {
    // Default implementation - should be overridden
    return false;
  }

  /// Add achievement to user
  Future<bool> addAchievement(String userId, String achievementId) async {
    // Default implementation - should be overridden
    return false;
  }

  /// Get user progress for a specific language
  Future<LanguageProgressEntity?> getLanguageProgress(
    String userId,
    String languageId,
  ) async {
    final user = await getCurrentUser();
    if (user == null || user.id != userId) return null;
    
    return user.progress.languages[languageId];
  }

  /// Get user lesson progress
  Future<LessonProgressEntity?> getLessonProgress(
    String userId,
    String languageId,
    String lessonId,
  ) async {
    final languageProgress = await getLanguageProgress(userId, languageId);
    return languageProgress?.lessons[lessonId];
  }

  /// Get user quiz result
  Future<QuizResultEntity?> getQuizResult(
    String userId,
    String languageId,
    String quizId,
  ) async {
    final languageProgress = await getLanguageProgress(userId, languageId);
    return languageProgress?.quizResults[quizId];
  }

  /// Check if lesson is completed
  Future<bool> isLessonCompleted(
    String userId,
    String languageId,
    String lessonId,
  ) async {
    final lessonProgress = await getLessonProgress(userId, languageId, lessonId);
    return lessonProgress?.isCompleted ?? false;
  }

  /// Check if quiz is passed
  Future<bool> isQuizPassed(
    String userId,
    String languageId,
    String quizId,
  ) async {
    final quizResult = await getQuizResult(userId, languageId, quizId);
    return quizResult?.passed ?? false;
  }

  /// Get user statistics
  Future<UserStatsEntity?> getUserStats(String userId) async {
    final user = await getCurrentUser();
    if (user == null || user.id != userId) return null;
    
    return user.stats;
  }

  /// Calculate overall progress percentage
  Future<double> getOverallProgress(String userId) async {
    final user = await getCurrentUser();
    if (user == null || user.id != userId) return 0.0;
    
    if (user.progress.languages.isEmpty) return 0.0;
    
    double totalProgress = 0.0;
    for (final languageProgress in user.progress.languages.values) {
      totalProgress += languageProgress.progressPercentage;
    }
    
    return totalProgress / user.progress.languages.length;
  }

  /// Get user level progress
  Future<Map<String, dynamic>> getLevelProgress(String userId) async {
    final user = await getCurrentUser();
    if (user == null || user.id != userId) {
      return {
        'currentLevel': 1,
        'currentXP': 0,
        'xpForNextLevel': 100,
        'progressPercentage': 0.0,
      };
    }
    
    // This would need to be implemented with proper level calculation
    return {
      'currentLevel': user.level,
      'currentXP': user.xp,
      'xpForNextLevel': user.level * 1000, // Simplified calculation
      'progressPercentage': (user.xp % 1000) / 1000 * 100,
    };
  }

  /// Export user data
  Future<Map<String, dynamic>?> exportUserData(String userId) async {
    final user = await getCurrentUser();
    if (user == null || user.id != userId) return null;
    
    return {
      'user': {
        'id': user.id,
        'name': user.name,
        'email': user.email,
        'level': user.level,
        'xp': user.xp,
        'coins': user.coins,
        'streak': user.streak,
        'joinDate': user.joinDate.toIso8601String(),
      },
      'progress': user.progress.languages.map((key, value) => MapEntry(key, {
        'languageId': value.languageId,
        'isCompleted': value.isCompleted,
        'lastAccessed': value.lastAccessed.toIso8601String(),
        'progressPercentage': value.progressPercentage,
        'totalTimeSpent': value.totalTimeSpent,
        'completedLessons': value.lessons.length,
        'passedQuizzes': value.quizResults.values.where((q) => q.passed).length,
      })),
      'stats': {
        'totalLessonsCompleted': user.stats.totalLessonsCompleted,
        'totalQuizzesPassed': user.stats.totalQuizzesPassed,
        'totalTimeSpent': user.stats.totalTimeSpent,
        'averageQuizScore': user.stats.averageQuizScore,
        'longestStreak': user.stats.longestStreak,
      },
      'achievements': user.achievements,
      'exportDate': DateTime.now().toIso8601String(),
    };
  }

  /// Clear all user data
  Future<bool> clearUserData(String userId) async {
    // Default implementation - should be overridden
    return false;
  }

  /// Backup user data
  Future<String?> backupUserData(String userId) async {
    final userData = await exportUserData(userId);
    if (userData == null) return null;
    
    // Convert to JSON string for backup
    return jsonEncode(userData);
  }

  /// Restore user data from backup
  Future<bool> restoreUserData(String userId, String backupData) async {
    // Default implementation - should be overridden
    return false;
  }

  Future<bool> saveUserProgress(UserEntity user);
}
