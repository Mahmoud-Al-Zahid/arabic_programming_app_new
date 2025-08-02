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
  final UserPreferences preferences;
  final Map<String, dynamic> metadata;

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
    required this.preferences,
    this.metadata = const {},
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
      preferences: UserPreferences.fromJson(json['preferences'] ?? {}),
      metadata: json['metadata'] ?? {},
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
      'preferences': preferences.toJson(),
      'metadata': metadata,
    };
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? avatar,
    int? level,
    int? xp,
    int? coins,
    int? streak,
    DateTime? joinDate,
    UserProgress? progress,
    UserStats? stats,
    List<Achievement>? achievements,
    UserPreferences? preferences,
    Map<String, dynamic>? metadata,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      level: level ?? this.level,
      xp: xp ?? this.xp,
      coins: coins ?? this.coins,
      streak: streak ?? this.streak,
      joinDate: joinDate ?? this.joinDate,
      progress: progress ?? this.progress,
      stats: stats ?? this.stats,
      achievements: achievements ?? this.achievements,
      preferences: preferences ?? this.preferences,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class UserProgress {
  final Map<String, LanguageProgress> languages;
  final String currentLanguage;
  final String currentLevel;
  final String currentLesson;
  final DateTime? lastActivity;

  const UserProgress({
    required this.languages,
    required this.currentLanguage,
    required this.currentLevel,
    required this.currentLesson,
    this.lastActivity,
  });

  factory UserProgress.fromJson(Map<String, dynamic> json) {
    return UserProgress(
      languages: (json['languages'] as Map<String, dynamic>?)?.map(
        (key, value) => MapEntry(key, LanguageProgress.fromJson(value)),
      ) ?? {},
      currentLanguage: json['currentLanguage'] ?? '',
      currentLevel: json['currentLevel'] ?? '',
      currentLesson: json['currentLesson'] ?? '',
      lastActivity: json['lastActivity'] != null 
          ? DateTime.parse(json['lastActivity']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'languages': languages.map((key, value) => MapEntry(key, value.toJson())),
      'currentLanguage': currentLanguage,
      'currentLevel': currentLevel,
      'currentLesson': currentLesson,
      'lastActivity': lastActivity?.toIso8601String(),
    };
  }

  UserProgress copyWith({
    Map<String, LanguageProgress>? languages,
    String? currentLanguage,
    String? currentLevel,
    String? currentLesson,
    DateTime? lastActivity,
  }) {
    return UserProgress(
      languages: languages ?? this.languages,
      currentLanguage: currentLanguage ?? this.currentLanguage,
      currentLevel: currentLevel ?? this.currentLevel,
      currentLesson: currentLesson ?? this.currentLesson,
      lastActivity: lastActivity ?? this.lastActivity,
    );
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
  final DateTime? lastAccessed;

  const LanguageProgress({
    required this.languageId,
    required this.overallProgress,
    required this.levels,
    required this.lessons,
    required this.quizResults,
    required this.isCompleted,
    this.completedDate,
    this.lastAccessed,
  });

  factory LanguageProgress.fromJson(Map<String, dynamic> json) {
    return LanguageProgress(
      languageId: json['languageId'] ?? '',
      overallProgress: (json['overallProgress'] ?? 0.0).toDouble(),
      levels: (json['levels'] as Map<String, dynamic>?)?.map(
        (key, value) => MapEntry(key, LevelProgress.fromJson(value)),
      ) ?? {},
      lessons: (json['lessons'] as Map<String, dynamic>?)?.map(
        (key, value) => MapEntry(key, LessonProgress.fromJson(value)),
      ) ?? {},
      quizResults: (json['quizResults'] as Map<String, dynamic>?)?.map(
        (key, value) => MapEntry(key, QuizResult.fromJson(value)),
      ) ?? {},
      isCompleted: json['isCompleted'] ?? false,
      completedDate: json['completedDate'] != null 
          ? DateTime.parse(json['completedDate']) 
          : null,
      lastAccessed: json['lastAccessed'] != null 
          ? DateTime.parse(json['lastAccessed']) 
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
      'lastAccessed': lastAccessed?.toIso8601String(),
    };
  }
}

class LevelProgress {
  final String levelId;
  final bool isUnlocked;
  final bool isCompleted;
  final DateTime? completedDate;
  final double progress;
  final int timeSpent;

  const LevelProgress({
    required this.levelId,
    required this.isUnlocked,
    required this.isCompleted,
    this.completedDate,
    required this.progress,
    required this.timeSpent,
  });

  factory LevelProgress.fromJson(Map<String, dynamic> json) {
    return LevelProgress(
      levelId: json['levelId'] ?? '',
      isUnlocked: json['isUnlocked'] ?? false,
      isCompleted: json['isCompleted'] ?? false,
      completedDate: json['completedDate'] != null 
          ? DateTime.parse(json['completedDate']) 
          : null,
      progress: (json['progress'] ?? 0.0).toDouble(),
      timeSpent: json['timeSpent'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'levelId': levelId,
      'isUnlocked': isUnlocked,
      'isCompleted': isCompleted,
      'completedDate': completedDate?.toIso8601String(),
      'progress': progress,
      'timeSpent': timeSpent,
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
  final double? lastScore;

  const LessonProgress({
    required this.lessonId,
    required this.isUnlocked,
    required this.isCompleted,
    this.completedDate,
    required this.timeSpent,
    required this.attempts,
    this.lastScore,
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
      lastScore: json['lastScore']?.toDouble(),
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
      'lastScore': lastScore,
    };
  }
}

class QuizResult {
  final String quizId;
  final int score;
  final int totalQuestions;
  final double percentage;
  final bool passed;
  final int timeSpent;
  final DateTime completedDate;
  final List<QuestionResult> questionResults;

  const QuizResult({
    required this.quizId,
    required this.score,
    required this.totalQuestions,
    required this.percentage,
    required this.passed,
    required this.timeSpent,
    required this.completedDate,
    required this.questionResults,
  });

  factory QuizResult.fromJson(Map<String, dynamic> json) {
    return QuizResult(
      quizId: json['quizId'] ?? '',
      score: json['score'] ?? 0,
      totalQuestions: json['totalQuestions'] ?? 0,
      percentage: (json['percentage'] ?? 0.0).toDouble(),
      passed: json['passed'] ?? false,
      timeSpent: json['timeSpent'] ?? 0,
      completedDate: DateTime.parse(json['completedDate'] ?? DateTime.now().toIso8601String()),
      questionResults: (json['questionResults'] as List<dynamic>?)
          ?.map((result) => QuestionResult.fromJson(result))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quizId': quizId,
      'score': score,
      'totalQuestions': totalQuestions,
      'percentage': percentage,
      'passed': passed,
      'timeSpent': timeSpent,
      'completedDate': completedDate.toIso8601String(),
      'questionResults': questionResults.map((r) => r.toJson()).toList(),
    };
  }
}

class QuestionResult {
  final String questionId;
  final bool isCorrect;
  final String userAnswer;
  final String correctAnswer;
  final int timeSpent;

  const QuestionResult({
    required this.questionId,
    required this.isCorrect,
    required this.userAnswer,
    required this.correctAnswer,
    required this.timeSpent,
  });

  factory QuestionResult.fromJson(Map<String, dynamic> json) {
    return QuestionResult(
      questionId: json['questionId'] ?? '',
      isCorrect: json['isCorrect'] ?? false,
      userAnswer: json['userAnswer'] ?? '',
      correctAnswer: json['correctAnswer'] ?? '',
      timeSpent: json['timeSpent'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'isCorrect': isCorrect,
      'userAnswer': userAnswer,
      'correctAnswer': correctAnswer,
      'timeSpent': timeSpent,
    };
  }
}

class UserStats {
  final int totalLessonsCompleted;
  final int totalQuizzesPassed;
  final int totalTimeSpent;
  final int longestStreak;
  final double averageQuizScore;
  final Map<String, LanguageStats> languageStats;

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
      languageStats: (json['languageStats'] as Map<String, dynamic>?)?.map(
        (key, value) => MapEntry(key, LanguageStats.fromJson(value)),
      ) ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalLessonsCompleted': totalLessonsCompleted,
      'totalQuizzesPassed': totalQuizzesPassed,
      'totalTimeSpent': totalTimeSpent,
      'longestStreak': longestStreak,
      'averageQuizScore': averageQuizScore,
      'languageStats': languageStats.map((key, value) => MapEntry(key, value.toJson())),
    };
  }
}

class LanguageStats {
  final String languageId;
  final int lessonsCompleted;
  final int quizzesPassed;
  final int timeSpent;
  final double averageScore;

  const LanguageStats({
    required this.languageId,
    required this.lessonsCompleted,
    required this.quizzesPassed,
    required this.timeSpent,
    required this.averageScore,
  });

  factory LanguageStats.fromJson(Map<String, dynamic> json) {
    return LanguageStats(
      languageId: json['languageId'] ?? '',
      lessonsCompleted: json['lessonsCompleted'] ?? 0,
      quizzesPassed: json['quizzesPassed'] ?? 0,
      timeSpent: json['timeSpent'] ?? 0,
      averageScore: (json['averageScore'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'languageId': languageId,
      'lessonsCompleted': lessonsCompleted,
      'quizzesPassed': quizzesPassed,
      'timeSpent': timeSpent,
      'averageScore': averageScore,
    };
  }
}

class Achievement {
  final String id;
  final String title;
  final String description;
  final String icon;
  final DateTime unlockedDate;
  final String category;
  final int points;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.unlockedDate,
    required this.category,
    required this.points,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      icon: json['icon'] ?? '',
      unlockedDate: DateTime.parse(json['unlockedDate'] ?? DateTime.now().toIso8601String()),
      category: json['category'] ?? '',
      points: json['points'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon': icon,
      'unlockedDate': unlockedDate.toIso8601String(),
      'category': category,
      'points': points,
    };
  }
}

class UserPreferences {
  final String language;
  final bool darkMode;
  final bool soundEnabled;
  final bool notificationsEnabled;
  final int dailyGoal;
  final String difficulty;

  const UserPreferences({
    required this.language,
    required this.darkMode,
    required this.soundEnabled,
    required this.notificationsEnabled,
    required this.dailyGoal,
    required this.difficulty,
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      language: json['language'] ?? 'ar',
      darkMode: json['darkMode'] ?? false,
      soundEnabled: json['soundEnabled'] ?? true,
      notificationsEnabled: json['notificationsEnabled'] ?? true,
      dailyGoal: json['dailyGoal'] ?? 15,
      difficulty: json['difficulty'] ?? 'beginner',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'language': language,
      'darkMode': darkMode,
      'soundEnabled': soundEnabled,
      'notificationsEnabled': notificationsEnabled,
      'dailyGoal': dailyGoal,
      'difficulty': difficulty,
    };
  }
}
