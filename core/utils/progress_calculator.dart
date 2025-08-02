class ProgressCalculator {
  // XP required for each level (exponential growth)
  static const Map<int, int> _levelXPRequirements = {
    1: 0,
    2: 100,
    3: 250,
    4: 450,
    5: 700,
    6: 1000,
    7: 1350,
    8: 1750,
    9: 2200,
    10: 2700,
    11: 3250,
    12: 3850,
    13: 4500,
    14: 5200,
    15: 5950,
    16: 6750,
    17: 7600,
    18: 8500,
    19: 9450,
    20: 10450,
  };

  // XP rewards for different activities
  static const int lessonCompletionXP = 50;
  static const int quizPassXP = 100;
  static const int perfectQuizXP = 150;
  static const int streakBonusXP = 25;
  static const int firstTimeCompletionXP = 25;

  // Coin rewards
  static const int lessonCompletionCoins = 10;
  static const int quizPassCoins = 20;
  static const int perfectQuizCoins = 30;
  static const int streakBonusCoins = 5;
  static const int dailyBonusCoins = 50;

  // Calculate XP required for a specific level
  int calculateXPForLevel(int level) {
    if (level <= 1) return 0;
    if (level <= 20) return _levelXPRequirements[level] ?? _calculateXPForHighLevel(level);
    return _calculateXPForHighLevel(level);
  }

  // Calculate XP for levels above 20 (exponential formula)
  int _calculateXPForHighLevel(int level) {
    if (level <= 20) return _levelXPRequirements[level] ?? 0;
    
    // Exponential growth: XP = 100 * (level - 1)^1.5
    return (100 * math.pow(level - 1, 1.5)).round();
  }

  // Calculate XP required for next level
  int calculateXPForNextLevel(int currentLevel) {
    return calculateXPForLevel(currentLevel + 1);
  }

  // Calculate remaining XP needed for next level
  int calculateRemainingXPForNextLevel(int currentXP, int currentLevel) {
    final nextLevelXP = calculateXPForNextLevel(currentLevel);
    final currentLevelXP = calculateXPForLevel(currentLevel);
    final requiredXP = nextLevelXP - currentLevelXP;
    final earnedXP = currentXP - currentLevelXP;
    
    return math.max(0, requiredXP - earnedXP);
  }

  // Calculate level progress percentage
  double calculateLevelProgress(int currentXP, int currentLevel) {
    final currentLevelXP = calculateXPForLevel(currentLevel);
    final nextLevelXP = calculateXPForNextLevel(currentLevel);
    final requiredXP = nextLevelXP - currentLevelXP;
    
    if (requiredXP <= 0) return 1.0;
    
    final earnedXP = currentXP - currentLevelXP;
    final progress = earnedXP / requiredXP;
    
    return math.max(0.0, math.min(1.0, progress));
  }

  // Calculate level from total XP
  int calculateLevelFromXP(int totalXP) {
    if (totalXP <= 0) return 1;
    
    int level = 1;
    while (calculateXPForLevel(level + 1) <= totalXP) {
      level++;
      if (level > 100) break; // Safety limit
    }
    
    return level;
  }

  // Calculate XP reward for lesson completion
  int calculateLessonXP({
    required bool isFirstTime,
    required int currentStreak,
    double? score,
  }) {
    int xp = lessonCompletionXP;
    
    if (isFirstTime) {
      xp += firstTimeCompletionXP;
    }
    
    if (currentStreak >= 7) {
      xp += streakBonusXP;
    }
    
    // Bonus for high lesson engagement (if score is provided)
    if (score != null && score >= 90) {
      xp += 25;
    }
    
    return xp;
  }

  // Calculate XP reward for quiz completion
  int calculateQuizXP({
    required double score,
    required bool isFirstTime,
    required int currentStreak,
  }) {
    int xp = 0;
    
    if (score >= 70) {
      xp += quizPassXP;
      
      if (score >= 100) {
        xp += perfectQuizXP - quizPassXP; // Additional XP for perfect score
      }
    }
    
    if (isFirstTime && score >= 70) {
      xp += firstTimeCompletionXP;
    }
    
    if (currentStreak >= 7) {
      xp += streakBonusXP;
    }
    
    return xp;
  }

  // Calculate coin reward for lesson completion
  int calculateLessonCoins({
    required bool isFirstTime,
    required int currentStreak,
  }) {
    int coins = lessonCompletionCoins;
    
    if (isFirstTime) {
      coins += 5;
    }
    
    if (currentStreak >= 7) {
      coins += streakBonusCoins;
    }
    
    return coins;
  }

  // Calculate coin reward for quiz completion
  int calculateQuizCoins({
    required double score,
    required bool isFirstTime,
    required int currentStreak,
  }) {
    int coins = 0;
    
    if (score >= 70) {
      coins += quizPassCoins;
      
      if (score >= 100) {
        coins += perfectQuizCoins - quizPassCoins;
      }
    }
    
    if (isFirstTime && score >= 70) {
      coins += 10;
    }
    
    if (currentStreak >= 7) {
      coins += streakBonusCoins;
    }
    
    return coins;
  }

  // Calculate overall progress percentage across all languages
  double calculateOverallProgress(Map<String, double> languageProgresses) {
    if (languageProgresses.isEmpty) return 0.0;
    
    final totalProgress = languageProgresses.values.fold(0.0, (sum, progress) => sum + progress);
    return totalProgress / languageProgresses.length;
  }

  // Calculate language progress percentage
  double calculateLanguageProgress({
    required int completedLessons,
    required int totalLessons,
    required int passedQuizzes,
    required int totalQuizzes,
  }) {
    if (totalLessons == 0 && totalQuizzes == 0) return 0.0;
    
    final lessonProgress = totalLessons > 0 ? completedLessons / totalLessons : 0.0;
    final quizProgress = totalQuizzes > 0 ? passedQuizzes / totalQuizzes : 0.0;
    
    // Weight lessons and quizzes equally
    return (lessonProgress + quizProgress) / 2 * 100;
  }

  // Calculate streak bonus multiplier
  double calculateStreakMultiplier(int streak) {
    if (streak < 3) return 1.0;
    if (streak < 7) return 1.1;
    if (streak < 14) return 1.2;
    if (streak < 30) return 1.3;
    return 1.5; // Max multiplier for 30+ day streak
  }

  // Calculate time-based bonus
  int calculateTimeBonusXP(int timeSpent, int estimatedTime) {
    if (timeSpent <= 0 || estimatedTime <= 0) return 0;
    
    final efficiency = estimatedTime / timeSpent;
    
    if (efficiency >= 1.5) return 50; // Very fast completion
    if (efficiency >= 1.2) return 25; // Fast completion
    if (efficiency >= 0.8) return 10; // Normal completion
    
    return 0; // Slow completion, no bonus
  }

  // Calculate achievement progress
  double calculateAchievementProgress(int current, int target) {
    if (target <= 0) return 1.0;
    return math.min(1.0, current / target);
  }

  // Get level title based on level
  String getLevelTitle(int level) {
    if (level < 5) return 'مبتدئ';
    if (level < 10) return 'متوسط';
    if (level < 15) return 'متقدم';
    if (level < 20) return 'خبير';
    return 'أسطورة';
  }

  // Get level color based on level
  String getLevelColor(int level) {
    if (level < 5) return '#4CAF50'; // Green
    if (level < 10) return '#2196F3'; // Blue
    if (level < 15) return '#FF9800'; // Orange
    if (level < 20) return '#9C27B0'; // Purple
    return '#F44336'; // Red
  }
}
