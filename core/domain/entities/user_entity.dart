class UserEntity {
  final String id;
  final String name;
  final String email;
  final String avatar;
  final int level;
  final int xp;
  final int coins;
  final int streak;
  final DateTime joinDate;
  final UserProgressEntity progress;
  final UserStatsEntity stats;
  final List<String> achievements;
  final UserPreferencesEntity preferences;

  const UserEntity({
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
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserEntity &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        other.avatar == avatar &&
        other.level == level &&
        other.xp == xp &&
        other.coins == coins &&
        other.streak == streak &&
        other.joinDate == joinDate &&
        other.progress == progress &&
        other.stats == stats &&
        _listEquals(other.achievements, achievements) &&
        other.preferences == preferences;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      email,
      avatar,
      level,
      xp,
      coins,
      streak,
      joinDate,
      progress,
      stats,
      Object.hashAll(achievements),
      preferences,
    );
  }

  @override
  String toString() {
    return 'UserEntity(id: $id, name: $name, level: $level, xp: $xp)';
  }

  UserEntity copyWith({
    String? id,
    String? name,
    String? email,
    String? avatar,
    int? level,
    int? xp,
    int? coins,
    int? streak,
    DateTime? joinDate,
    UserProgressEntity? progress,
    UserStatsEntity? stats,
    List<String>? achievements,
    UserPreferencesEntity? preferences,
  }) {
    return UserEntity(
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
    );
  }

  bool _listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    if (identical(a, b)) return true;
    for (int index = 0; index < a.length; index += 1) {
      if (a[index] != b[index]) return false;
    }
    return true;
  }
}

class UserProgressEntity {
  final String currentLanguage;
  final Map<String, LanguageProgressEntity> languages;

  const UserProgressEntity({
    required this.currentLanguage,
    required this.languages,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserProgressEntity &&
        other.currentLanguage == currentLanguage &&
        _mapEquals(other.languages, languages);
  }

  @override
  int get hashCode {
    return Object.hash(
      currentLanguage,
      Object.hashAll(languages.entries.map((e) => Object.hash(e.key, e.value))),
    );
  }

  @override
  String toString() {
    return 'UserProgressEntity(currentLanguage: $currentLanguage, languages: ${languages.length})';
  }

  UserProgressEntity copyWith({
    String? currentLanguage,
    Map<String, LanguageProgressEntity>? languages,
  }) {
    return UserProgressEntity(
      currentLanguage: currentLanguage ?? this.currentLanguage,
      languages: languages ?? this.languages,
    );
  }

  bool _mapEquals<K, V>(Map<K, V>? a, Map<K, V>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    if (identical(a, b)) return true;
    for (final key in a.keys) {
      if (!b.containsKey(key) || a[key] != b[key]) return false;
    }
    return true;
  }
}

class LanguageProgressEntity {
  final String languageId;
  final bool isCompleted;
  final DateTime lastAccessed;
  final Map<String, LessonProgressEntity> lessons;
  final Map<String, QuizResultEntity> quizResults;

  const LanguageProgressEntity({
    required this.languageId,
    required this.isCompleted,
    required this.lastAccessed,
    required this.lessons,
    required this.quizResults,
  });

  double get progressPercentage {
    if (lessons.isEmpty) return 0.0;
    final completedLessons = lessons.values.where((lesson) => lesson.isCompleted).length;
    return (completedLessons / lessons.length) * 100;
  }

  int get totalTimeSpent {
    return lessons.values.fold(0, (sum, lesson) => sum + lesson.timeSpent) +
           quizResults.values.fold(0, (sum, quiz) => sum + quiz.timeSpent);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LanguageProgressEntity &&
        other.languageId == languageId &&
        other.isCompleted == isCompleted &&
        other.lastAccessed == lastAccessed &&
        _mapEquals(other.lessons, lessons) &&
        _mapEquals(other.quizResults, quizResults);
  }

  @override
  int get hashCode {
    return Object.hash(
      languageId,
      isCompleted,
      lastAccessed,
      Object.hashAll(lessons.entries.map((e) => Object.hash(e.key, e.value))),
      Object.hashAll(quizResults.entries.map((e) => Object.hash(e.key, e.value))),
    );
  }

  @override
  String toString() {
    return 'LanguageProgressEntity(languageId: $languageId, lessons: ${lessons.length}, quizzes: ${quizResults.length})';
  }

  LanguageProgressEntity copyWith({
    String? languageId,
    bool? isCompleted,
    DateTime? lastAccessed,
    Map<String, LessonProgressEntity>? lessons,
    Map<String, QuizResultEntity>? quizResults,
  }) {
    return LanguageProgressEntity(
      languageId: languageId ?? this.languageId,
      isCompleted: isCompleted ?? this.isCompleted,
      lastAccessed: lastAccessed ?? this.lastAccessed,
      lessons: lessons ?? this.lessons,
      quizResults: quizResults ?? this.quizResults,
    );
  }

  bool _mapEquals<K, V>(Map<K, V>? a, Map<K, V>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    if (identical(a, b)) return true;
    for (final key in a.keys) {
      if (!b.containsKey(key) || a[key] != b[key]) return false;
    }
    return true;
  }
}

class LessonProgressEntity {
  final String lessonId;
  final bool isCompleted;
  final DateTime? completedAt;
  final int timeSpent;
  final int attempts;
  final double? score;

  const LessonProgressEntity({
    required this.lessonId,
    required this.isCompleted,
    this.completedAt,
    required this.timeSpent,
    required this.attempts,
    this.score,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LessonProgressEntity &&
        other.lessonId == lessonId &&
        other.isCompleted == isCompleted &&
        other.completedAt == completedAt &&
        other.timeSpent == timeSpent &&
        other.attempts == attempts &&
        other.score == score;
  }

  @override
  int get hashCode {
    return Object.hash(
      lessonId,
      isCompleted,
      completedAt,
      timeSpent,
      attempts,
      score,
    );
  }

  @override
  String toString() {
    return 'LessonProgressEntity(lessonId: $lessonId, isCompleted: $isCompleted, attempts: $attempts)';
  }

  LessonProgressEntity copyWith({
    String? lessonId,
    bool? isCompleted,
    DateTime? completedAt,
    int? timeSpent,
    int? attempts,
    double? score,
  }) {
    return LessonProgressEntity(
      lessonId: lessonId ?? this.lessonId,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      timeSpent: timeSpent ?? this.timeSpent,
      attempts: attempts ?? this.attempts,
      score: score ?? this.score,
    );
  }
}

class QuizResultEntity {
  final String quizId;
  final double score;
  final bool passed;
  final DateTime completedAt;
  final int timeSpent;
  final int attempts;
  final Map<String, dynamic> answers;

  const QuizResultEntity({
    required this.quizId,
    required this.score,
    required this.passed,
    required this.completedAt,
    required this.timeSpent,
    required this.attempts,
    required this.answers,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is QuizResultEntity &&
        other.quizId == quizId &&
        other.score == score &&
        other.passed == passed &&
        other.completedAt == completedAt &&
        other.timeSpent == timeSpent &&
        other.attempts == attempts &&
        _mapEquals(other.answers, answers);
  }

  @override
  int get hashCode {
    return Object.hash(
      quizId,
      score,
      passed,
      completedAt,
      timeSpent,
      attempts,
      Object.hashAll(answers.entries.map((e) => Object.hash(e.key, e.value))),
    );
  }

  @override
  String toString() {
    return 'QuizResultEntity(quizId: $quizId, score: $score, passed: $passed)';
  }

  QuizResultEntity copyWith({
    String? quizId,
    double? score,
    bool? passed,
    DateTime? completedAt,
    int? timeSpent,
    int? attempts,
    Map<String, dynamic>? answers,
  }) {
    return QuizResultEntity(
      quizId: quizId ?? this.quizId,
      score: score ?? this.score,
      passed: passed ?? this.passed,
      completedAt: completedAt ?? this.completedAt,
      timeSpent: timeSpent ?? this.timeSpent,
      attempts: attempts ?? this.attempts,
      answers: answers ?? this.answers,
    );
  }

  bool _mapEquals<K, V>(Map<K, V>? a, Map<K, V>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    if (identical(a, b)) return true;
    for (final key in a.keys) {
      if (!b.containsKey(key) || a[key] != b[key]) return false;
    }
    return true;
  }
}

class UserStatsEntity {
  final int totalLessonsCompleted;
  final int totalQuizzesPassed;
  final int totalTimeSpent;
  final double averageQuizScore;
  final int longestStreak;

  const UserStatsEntity({
    required this.totalLessonsCompleted,
    required this.totalQuizzesPassed,
    required this.totalTimeSpent,
    required this.averageQuizScore,
    required this.longestStreak,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserStatsEntity &&
        other.totalLessonsCompleted == totalLessonsCompleted &&
        other.totalQuizzesPassed == totalQuizzesPassed &&
        other.totalTimeSpent == totalTimeSpent &&
        other.averageQuizScore == averageQuizScore &&
        other.longestStreak == longestStreak;
  }

  @override
  int get hashCode {
    return Object.hash(
      totalLessonsCompleted,
      totalQuizzesPassed,
      totalTimeSpent,
      averageQuizScore,
      longestStreak,
    );
  }

  @override
  String toString() {
    return 'UserStatsEntity(lessons: $totalLessonsCompleted, quizzes: $totalQuizzesPassed, time: $totalTimeSpent)';
  }

  UserStatsEntity copyWith({
    int? totalLessonsCompleted,
    int? totalQuizzesPassed,
    int? totalTimeSpent,
    double? averageQuizScore,
    int? longestStreak,
  }) {
    return UserStatsEntity(
      totalLessonsCompleted: totalLessonsCompleted ?? this.totalLessonsCompleted,
      totalQuizzesPassed: totalQuizzesPassed ?? this.totalQuizzesPassed,
      totalTimeSpent: totalTimeSpent ?? this.totalTimeSpent,
      averageQuizScore: averageQuizScore ?? this.averageQuizScore,
      longestStreak: longestStreak ?? this.longestStreak,
    );
  }
}

class UserPreferencesEntity {
  final String language;
  final String theme;
  final bool soundEnabled;
  final bool notificationsEnabled;
  final int dailyGoalMinutes;

  const UserPreferencesEntity({
    required this.language,
    required this.theme,
    required this.soundEnabled,
    required this.notificationsEnabled,
    required this.dailyGoalMinutes,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserPreferencesEntity &&
        other.language == language &&
        other.theme == theme &&
        other.soundEnabled == soundEnabled &&
        other.notificationsEnabled == notificationsEnabled &&
        other.dailyGoalMinutes == dailyGoalMinutes;
  }

  @override
  int get hashCode {
    return Object.hash(
      language,
      theme,
      soundEnabled,
      notificationsEnabled,
      dailyGoalMinutes,
    );
  }

  @override
  String toString() {
    return 'UserPreferencesEntity(language: $language, theme: $theme, dailyGoal: $dailyGoalMinutes)';
  }

  UserPreferencesEntity copyWith({
    String? language,
    String? theme,
    bool? soundEnabled,
    bool? notificationsEnabled,
    int? dailyGoalMinutes,
  }) {
    return UserPreferencesEntity(
      language: language ?? this.language,
      theme: theme ?? this.theme,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      dailyGoalMinutes: dailyGoalMinutes ?? this.dailyGoalMinutes,
    );
  }
}
