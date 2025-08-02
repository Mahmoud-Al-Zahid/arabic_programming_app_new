class User {
  final String id;
  final String name;
  final String email;
  final String avatar;
  final int level;
  final int xp;
  final int coins;
  final int streak;
  final DateTime joinDate;
  final UserProgress progress;
  final UserStats stats;
  final List<Achievement> achievements;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
    required this.level,
    required this.xp,
    required this.coins,
    required this.streak,
    required this.joinDate,
    required this.progress,
    required this.stats,
    required this.achievements,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      avatar: json['avatar'] ?? '',
      level: json['level'] ?? 1,
      xp: json['xp'] ?? 0,
      coins: json['coins'] ?? 0,
      streak: json['streak'] ?? 0,
      joinDate: DateTime.parse(json['joinDate'] ?? DateTime.now().toIso8601String()),
      progress: UserProgress.fromJson(json['progress'] ?? {}),
      stats: UserStats.fromJson(json['stats'] ?? {}),
      achievements: (json['achievements'] as List<dynamic>?)
          ?.map((achievement) => Achievement.fromJson(achievement))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar': avatar,
      'level': level,
      'xp': xp,
      'coins': coins,
      'streak': streak,
      'joinDate': joinDate.toIso8601String(),
      'progress': progress.toJson(),
      'stats': stats.toJson(),
      'achievements': achievements.map((a) => a.toJson()).toList(),
    };
  }
}

class UserProgress {
  final Map<String, LanguageProgress> languages;
  final String currentLanguage;
  final String currentLevel;
  final String currentLesson;

  const UserProgress({
    required this.languages,
    required this.currentLanguage,
    required this.currentLevel,
    required this.currentLesson,
  });

  factory UserProgress.fromJson(Map<String, dynamic> json) {
    return UserProgress(
      languages: (json['languages'] as Map<String, dynamic>?)
          ?.map((key, value) => MapEntry(key, LanguageProgress.fromJson(value))) ?? {},
      currentLanguage: json['currentLanguage'] ?? '',
      currentLevel: json['currentLevel'] ?? '',
      currentLesson: json['currentLesson'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'languages': languages.map((key, value) => MapEntry(key, value.toJson())),
      'currentLanguage': currentLanguage,
      'currentLevel': currentLevel,
      'currentLesson': currentLesson,
    };
  }
}

class LanguageProgress {
  final String languageId;
  final double overallProgress;
  final Map<String, LevelProgress> levels;
  final Map<String, LessonProgress> lessons;
  final Map<String, QuizResult> quizResults;
  final bool isCompleted;
  final DateTime? completedDate;

  const LanguageProgress({
    required this.languageId,
    required this.overallProgress,
    required this.levels,
    required this.lessons,
    required this.quizResults,
    required this.isCompleted,
    this.completedDate,
  });

  factory LanguageProgress.fromJson(Map<String, dynamic> json) {
    return LanguageProgress(
      languageId: json['languageId'] ?? '',
      overallProgress: (json['overallProgress'] ?? 0.0).toDouble(),
      levels: (json['levels'] as Map<String, dynamic>?)
          ?.map((key, value) => MapEntry(key, LevelProgress.fromJson(value))) ?? {},
      lessons: (json['lessons'] as Map<String, dynamic>?)
          ?.map((key, value) => MapEntry(key, LessonProgress.fromJson(value))) ?? {},
      quizResults: (json['quizResults'] as Map<String, dynamic>?)
          ?.map((key, value) => MapEntry(key, QuizResult.fromJson(value))) ?? {},
      isCompleted: json['isCompleted'] ?? false,
      completedDate: json['completedDate'] != null 
          ? DateTime.parse(json['completedDate']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'languageId': languageId,
      'overallProgress': overallProgress,
      'levels': levels.map((key, value) => MapEntry(key, value.toJson())),
      'lessons': lessons.map((key, value) => MapEntry(key, value.toJson())),
      'quizResults': quizResults.map((key, value) => MapEntry(key, value.toJson())),
      'isCompleted': isCompleted,
      'completedDate': completedDate?.toIso8601String(),
    };
  }
}

class LevelProgress {
  final String levelId;
  final bool isUnlocked;
  final bool isCompleted;
  final double progress;
  final DateTime? completedDate;
  final int score;

  const LevelProgress({
    required this.levelId,
    required this.isUnlocked,
    required this.isCompleted,
    required this.progress,
    this.completedDate,
    required this.score,
  });

  factory LevelProgress.fromJson(Map<String, dynamic> json) {
    return LevelProgress(
      levelId: json['levelId'] ?? '',
      isUnlocked: json['isUnlocked'] ?? false,
      isCompleted: json['isCompleted'] ?? false,
      progress: (json['progress'] ?? 0.0).toDouble(),
      completedDate: json['completedDate'] != null 
          ? DateTime.parse(json['completedDate']) 
          : null,
      score: json['score'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'levelId': levelId,
      'isUnlocked': isUnlocked,
      'isCompleted': isCompleted,
      'progress': progress,
      'completedDate': completedDate?.toIso8601String(),
      'score': score,
    };
  }
}

class LessonProgress {
  final String lessonId;
  final bool isUnlocked;
  final bool isCompleted;
  final DateTime? completedDate;
  final int timeSpent;
  final int attempts;

  const LessonProgress({
    required this.lessonId,
    required this.isUnlocked,
    required this.isCompleted,
    this.completedDate,
    required this.timeSpent,
    required this.attempts,
  });

  factory LessonProgress.fromJson(Map<String, dynamic> json) {
    return LessonProgress(
      lessonId: json['lessonId'] ?? '',
      isUnlocked: json['isUnlocked'] ?? false,
      isCompleted: json['isCompleted'] ?? false,
      completedDate: json['completedDate'] != null 
          ? DateTime.parse(json['completedDate']) 
          : null,
      timeSpent: json['timeSpent'] ?? 0,
      attempts: json['attempts'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lessonId': lessonId,
      'isUnlocked': isUnlocked,
      'isCompleted': isCompleted,
      'completedDate': completedDate?.toIso8601String(),
      'timeSpent': timeSpent,
      'attempts': attempts,
    };
  }
}

class QuizResult {
  final String quizId;
  final int score;
  final int totalQuestions;
  final double percentage;
  final bool passed;
  final DateTime completedDate;
  final int timeSpent;
  final Map<String, dynamic> answers;

  const QuizResult({
    required this.quizId,
    required this.score,
    required this.totalQuestions,
    required this.percentage,
    required this.passed,
    required this.completedDate,
    required this.timeSpent,
    required this.answers,
  });

  factory QuizResult.fromJson(Map<String, dynamic> json) {
    return QuizResult(
      quizId: json['quizId'] ?? '',
      score: json['score'] ?? 0,
      totalQuestions: json['totalQuestions'] ?? 0,
      percentage: (json['percentage'] ?? 0.0).toDouble(),
      passed: json['passed'] ?? false,
      completedDate: DateTime.parse(json['completedDate'] ?? DateTime.now().toIso8601String()),
      timeSpent: json['timeSpent'] ?? 0,
      answers: Map<String, dynamic>.from(json['answers'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quizId': quizId,
      'score': score,
      'totalQuestions': totalQuestions,
      'percentage': percentage,
      'passed': passed,
      'completedDate': completedDate.toIso8601String(),
      'timeSpent': timeSpent,
      'answers': answers,
    };
  }
}

class UserStats {
  final int totalLessonsCompleted;
  final int totalQuizzesPassed;
  final int totalTimeSpent;
  final int longestStreak;
  final double averageQuizScore;
  final Map<String, int> languageStats;

  const UserStats({
    required this.totalLessonsCompleted,
    required this.totalQuizzesPassed,
    required this.totalTimeSpent,
    required this.longestStreak,
    required this.averageQuizScore,
    required this.languageStats,
  });

  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      totalLessonsCompleted: json['totalLessonsCompleted'] ?? 0,
      totalQuizzesPassed: json['totalQuizzesPassed'] ?? 0,
      totalTimeSpent: json['totalTimeSpent'] ?? 0,
      longestStreak: json['longestStreak'] ?? 0,
      averageQuizScore: (json['averageQuizScore'] ?? 0.0).toDouble(),
      languageStats: Map<String, int>.from(json['languageStats'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalLessonsCompleted': totalLessonsCompleted,
      'totalQuizzesPassed': totalQuizzesPassed,
      'totalTimeSpent': totalTimeSpent,
      'longestStreak': longestStreak,
      'averageQuizScore': averageQuizScore,
      'languageStats': languageStats,
    };
  }
}

class Achievement {
  final String id;
  final String title;
  final String description;
  final String icon;
  final String type;
  final bool isUnlocked;
  final DateTime? unlockedDate;
  final int progress;
  final int target;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.type,
    required this.isUnlocked,
    this.unlockedDate,
    required this.progress,
    required this.target,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      icon: json['icon'] ?? '',
      type: json['type'] ?? '',
      isUnlocked: json['isUnlocked'] ?? false,
      unlockedDate: json['unlockedDate'] != null 
          ? DateTime.parse(json['unlockedDate']) 
          : null,
      progress: json['progress'] ?? 0,
      target: json['target'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon': icon,
      'type': type,
      'isUnlocked': isUnlocked,
      'unlockedDate': unlockedDate?.toIso8601String(),
      'progress': progress,
      'target': target,
    };
  }
}
