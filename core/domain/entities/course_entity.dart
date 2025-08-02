class CourseEntity {
  final String languageId;
  final String languageName;
  final String description;
  final int estimatedHours;
  final List<LevelEntity> levels;
  final int totalLessons;
  final int totalQuizzes;

  const CourseEntity({
    required this.languageId,
    required this.languageName,
    required this.description,
    required this.estimatedHours,
    required this.levels,
    required this.totalLessons,
    required this.totalQuizzes,
  });

  int get totalLevels => levels.length;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CourseEntity &&
        other.languageId == languageId &&
        other.languageName == languageName &&
        other.description == description &&
        other.estimatedHours == estimatedHours &&
        _listEquals(other.levels, levels) &&
        other.totalLessons == totalLessons &&
        other.totalQuizzes == totalQuizzes;
  }

  @override
  int get hashCode {
    return Object.hash(
      languageId,
      languageName,
      description,
      estimatedHours,
      Object.hashAll(levels),
      totalLessons,
      totalQuizzes,
    );
  }

  @override
  String toString() {
    return 'CourseEntity(languageId: $languageId, languageName: $languageName, levels: ${levels.length})';
  }

  CourseEntity copyWith({
    String? languageId,
    String? languageName,
    String? description,
    int? estimatedHours,
    List<LevelEntity>? levels,
    int? totalLessons,
    int? totalQuizzes,
  }) {
    return CourseEntity(
      languageId: languageId ?? this.languageId,
      languageName: languageName ?? this.languageName,
      description: description ?? this.description,
      estimatedHours: estimatedHours ?? this.estimatedHours,
      levels: levels ?? this.levels,
      totalLessons: totalLessons ?? this.totalLessons,
      totalQuizzes: totalQuizzes ?? this.totalQuizzes,
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

class LevelEntity {
  final String levelId;
  final String levelName;
  final String description;
  final int order;
  final int estimatedHours;
  final List<LessonEntity> lessons;
  final bool isUnlocked;
  final bool isCompleted;

  const LevelEntity({
    required this.levelId,
    required this.levelName,
    required this.description,
    required this.order,
    required this.estimatedHours,
    required this.lessons,
    this.isUnlocked = false,
    this.isCompleted = false,
  });

  int get totalLessons => lessons.length;
  int get completedLessons => lessons.where((lesson) => lesson.isCompleted).length;
  double get progressPercentage => totalLessons > 0 ? (completedLessons / totalLessons) * 100 : 0.0;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LevelEntity &&
        other.levelId == levelId &&
        other.levelName == levelName &&
        other.description == description &&
        other.order == order &&
        other.estimatedHours == estimatedHours &&
        _listEquals(other.lessons, lessons) &&
        other.isUnlocked == isUnlocked &&
        other.isCompleted == isCompleted;
  }

  @override
  int get hashCode {
    return Object.hash(
      levelId,
      levelName,
      description,
      order,
      estimatedHours,
      Object.hashAll(lessons),
      isUnlocked,
      isCompleted,
    );
  }

  @override
  String toString() {
    return 'LevelEntity(levelId: $levelId, levelName: $levelName, lessons: ${lessons.length})';
  }

  LevelEntity copyWith({
    String? levelId,
    String? levelName,
    String? description,
    int? order,
    int? estimatedHours,
    List<LessonEntity>? lessons,
    bool? isUnlocked,
    bool? isCompleted,
  }) {
    return LevelEntity(
      levelId: levelId ?? this.levelId,
      levelName: levelName ?? this.levelName,
      description: description ?? this.description,
      order: order ?? this.order,
      estimatedHours: estimatedHours ?? this.estimatedHours,
      lessons: lessons ?? this.lessons,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      isCompleted: isCompleted ?? this.isCompleted,
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

class LessonEntity {
  final String lessonId;
  final String lessonTitle;
  final String description;
  final int estimatedMinutes;
  final String difficulty;
  final int order;
  final bool isUnlocked;
  final bool isCompleted;
  final String? quizId;
  final String? cardImage;

  const LessonEntity({
    required this.lessonId,
    required this.lessonTitle,
    required this.description,
    required this.estimatedMinutes,
    required this.difficulty,
    required this.order,
    this.isUnlocked = false,
    this.isCompleted = false,
    this.quizId,
    this.cardImage,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LessonEntity &&
        other.lessonId == lessonId &&
        other.lessonTitle == lessonTitle &&
        other.description == description &&
        other.estimatedMinutes == estimatedMinutes &&
        other.difficulty == difficulty &&
        other.order == order &&
        other.isUnlocked == isUnlocked &&
        other.isCompleted == isCompleted &&
        other.quizId == quizId &&
        other.cardImage == cardImage;
  }

  @override
  int get hashCode {
    return Object.hash(
      lessonId,
      lessonTitle,
      description,
      estimatedMinutes,
      difficulty,
      order,
      isUnlocked,
      isCompleted,
      quizId,
      cardImage,
    );
  }

  @override
  String toString() {
    return 'LessonEntity(lessonId: $lessonId, lessonTitle: $lessonTitle, order: $order)';
  }

  LessonEntity copyWith({
    String? lessonId,
    String? lessonTitle,
    String? description,
    int? estimatedMinutes,
    String? difficulty,
    int? order,
    bool? isUnlocked,
    bool? isCompleted,
    String? quizId,
    String? cardImage,
  }) {
    return LessonEntity(
      lessonId: lessonId ?? this.lessonId,
      lessonTitle: lessonTitle ?? this.lessonTitle,
      description: description ?? this.description,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      difficulty: difficulty ?? this.difficulty,
      order: order ?? this.order,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      isCompleted: isCompleted ?? this.isCompleted,
      quizId: quizId ?? this.quizId,
      cardImage: cardImage ?? this.cardImage,
    );
  }
}
