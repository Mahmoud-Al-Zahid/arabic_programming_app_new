class UnlockValidator {
  // Check if lesson is unlocked based on prerequisites
  static bool isLessonUnlocked({
    required String lessonId,
    required int lessonOrder,
    required Map<String, bool> completedLessons,
    required Map<String, double> quizScores,
    String? prerequisiteLessonId,
    double? minimumQuizScore,
  }) {
    // First lesson is always unlocked
    if (lessonOrder == 1) return true;
    
    // Check if prerequisite lesson is completed
    if (prerequisiteLessonId != null) {
      final isPrerequisiteCompleted = completedLessons[prerequisiteLessonId] ?? false;
      if (!isPrerequisiteCompleted) return false;
    }
    
    // Check if minimum quiz score is met (if required)
    if (minimumQuizScore != null && prerequisiteLessonId != null) {
      final score = quizScores[prerequisiteLessonId] ?? 0.0;
      if (score < minimumQuizScore) return false;
    }
    
    // Check if previous lessons in sequence are completed
    return _areSequentialLessonsCompleted(lessonOrder, completedLessons);
  }

  // Check if quiz is unlocked
  static bool isQuizUnlocked({
    required String quizId,
    required String associatedLessonId,
    required Map<String, bool> completedLessons,
    bool requireLessonCompletion = true,
  }) {
    if (!requireLessonCompletion) return true;
    
    // Quiz is unlocked if associated lesson is completed
    return completedLessons[associatedLessonId] ?? false;
  }

  // Check if level is unlocked
  static bool isLevelUnlocked({
    required String levelId,
    required int levelOrder,
    required Map<String, Map<String, bool>> levelCompletionStatus,
    double? minimumCompletionPercentage,
  }) {
    // First level is always unlocked
    if (levelOrder == 1) return true;
    
    // Check if previous level meets completion requirements
    final previousLevelId = _getPreviousLevelId(levelId, levelOrder);
    if (previousLevelId == null) return true;
    
    final previousLevelLessons = levelCompletionStatus[previousLevelId] ?? {};
    final completionPercentage = _calculateLevelCompletionPercentage(previousLevelLessons);
    
    final requiredPercentage = minimumCompletionPercentage ?? 80.0;
    return completionPercentage >= requiredPercentage;
  }

  // Check if course is unlocked
  static bool isCourseUnlocked({
    required String courseId,
    required int userLevel,
    required List<String> completedCourses,
    int? minimumLevel,
    List<String>? prerequisiteCourses,
  }) {
    // Check minimum level requirement
    if (minimumLevel != null && userLevel < minimumLevel) {
      return false;
    }
    
    // Check prerequisite courses
    if (prerequisiteCourses != null && prerequisiteCourses.isNotEmpty) {
      for (final prerequisite in prerequisiteCourses) {
        if (!completedCourses.contains(prerequisite)) {
          return false;
        }
      }
    }
    
    return true;
  }

  // Check if feature is unlocked
  static bool isFeatureUnlocked({
    required String featureId,
    required int userLevel,
    required int userXP,
    required List<String> unlockedAchievements,
    int? minimumLevel,
    int? minimumXP,
    List<String>? requiredAchievements,
  }) {
    // Check minimum level
    if (minimumLevel != null && userLevel < minimumLevel) {
      return false;
    }
    
    // Check minimum XP
    if (minimumXP != null && userXP < minimumXP) {
      return false;
    }
    
    // Check required achievements
    if (requiredAchievements != null && requiredAchievements.isNotEmpty) {
      for (final achievement in requiredAchievements) {
        if (!unlockedAchievements.contains(achievement)) {
          return false;
        }
      }
    }
    
    return true;
  }

  // Get unlock requirements for lesson
  static Map<String, dynamic> getLessonUnlockRequirements({
    required String lessonId,
    required int lessonOrder,
    String? prerequisiteLessonId,
    double? minimumQuizScore,
  }) {
    final requirements = <String, dynamic>{};
    
    if (lessonOrder > 1) {
      requirements['previousLessons'] = lessonOrder - 1;
    }
    
    if (prerequisiteLessonId != null) {
      requirements['prerequisiteLesson'] = prerequisiteLessonId;
    }
    
    if (minimumQuizScore != null) {
      requirements['minimumQuizScore'] = minimumQuizScore;
    }
    
    return requirements;
  }

  // Get unlock requirements for level
  static Map<String, dynamic> getLevelUnlockRequirements({
    required String levelId,
    required int levelOrder,
    double? minimumCompletionPercentage,
  }) {
    final requirements = <String, dynamic>{};
    
    if (levelOrder > 1) {
      requirements['previousLevelCompletion'] = minimumCompletionPercentage ?? 80.0;
    }
    
    return requirements;
  }

  // Get unlock status with detailed information
  static Map<String, dynamic> getDetailedUnlockStatus({
    required String itemId,
    required String itemType,
    required Map<String, dynamic> userProgress,
    required Map<String, dynamic> requirements,
  }) {
    final status = <String, dynamic>{
      'isUnlocked': false,
      'requirements': requirements,
      'missingRequirements': <String, dynamic>{},
      'progress': <String, dynamic>{},
    };
    
    switch (itemType.toLowerCase()) {
      case 'lesson':
        status.addAll(_getLessonUnlockStatus(itemId, userProgress, requirements));
        break;
      case 'quiz':
        status.addAll(_getQuizUnlockStatus(itemId, userProgress, requirements));
        break;
      case 'level':
        status.addAll(_getLevelUnlockStatus(itemId, userProgress, requirements));
        break;
      case 'course':
        status.addAll(_getCourseUnlockStatus(itemId, userProgress, requirements));
        break;
    }
    
    return status;
  }

  // Helper method to check sequential lesson completion
  static bool _areSequentialLessonsCompleted(int currentOrder, Map<String, bool> completedLessons) {
    // This is a simplified check - in a real implementation, you'd need lesson ordering data
    final completedCount = completedLessons.values.where((completed) => completed).length;
    return completedCount >= currentOrder - 1;
  }

  // Helper method to get previous level ID
  static String? _getPreviousLevelId(String currentLevelId, int currentOrder) {
    if (currentOrder <= 1) return null;
    
    // This is a simplified implementation - you'd need actual level ordering data
    final levelNumber = currentOrder - 1;
    return currentLevelId.replaceAll(RegExp(r'\d+'), levelNumber.toString());
  }

  // Helper method to calculate level completion percentage
  static double _calculateLevelCompletionPercentage(Map<String, bool> lessons) {
    if (lessons.isEmpty) return 0.0;
    
    final completedCount = lessons.values.where((completed) => completed).length;
    return (completedCount / lessons.length) * 100;
  }

  // Helper methods for detailed unlock status
  static Map<String, dynamic> _getLessonUnlockStatus(
    String lessonId,
    Map<String, dynamic> userProgress,
    Map<String, dynamic> requirements,
  ) {
    // Implementation would check specific lesson requirements
    return {
      'isUnlocked': true, // Simplified
      'missingRequirements': <String, dynamic>{},
    };
  }

  static Map<String, dynamic> _getQuizUnlockStatus(
    String quizId,
    Map<String, dynamic> userProgress,
    Map<String, dynamic> requirements,
  ) {
    // Implementation would check specific quiz requirements
    return {
      'isUnlocked': true, // Simplified
      'missingRequirements': <String, dynamic>{},
    };
  }

  static Map<String, dynamic> _getLevelUnlockStatus(
    String levelId,
    Map<String, dynamic> userProgress,
    Map<String, dynamic> requirements,
  ) {
    // Implementation would check specific level requirements
    return {
      'isUnlocked': true, // Simplified
      'missingRequirements': <String, dynamic>{},
    };
  }

  static Map<String, dynamic> _getCourseUnlockStatus(
    String courseId,
    Map<String, dynamic> userProgress,
    Map<String, dynamic> requirements,
  ) {
    // Implementation would check specific course requirements
    return {
      'isUnlocked': true, // Simplified
      'missingRequirements': <String, dynamic>{},
    };
  }
}
