class Course {
  final String languageId;
  final String languageName;
  final String helloLanguage;
  final String description;
  final int totalLessons;
  final String estimatedDuration;
  final List<Level> levels;
  final String finalExam;
  final String courseCertificate;
  final Map<String, String> resources;

  const Course({
    required this.languageId,
    required this.languageName,
    required this.helloLanguage,
    required this.description,
    required this.totalLessons,
    required this.estimatedDuration,
    required this.levels,
    required this.finalExam,
    required this.courseCertificate,
    required this.resources,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      languageId: json['languageId'] ?? '',
      languageName: json['languageName'] ?? '',
      helloLanguage: json['helloLanguage'] ?? '',
      description: json['description'] ?? '',
      totalLessons: json['totalLessons'] ?? 0,
      estimatedDuration: json['estimatedDuration'] ?? '',
      levels: (json['levels'] as List<dynamic>?)
          ?.map((level) => Level.fromJson(level))
          .toList() ?? [],
      finalExam: json['finalExam'] ?? '',
      courseCertificate: json['courseCertificate'] ?? '',
      resources: Map<String, String>.from(json['resources'] ?? {}),
    );
  }
}

class Level {
  final String levelId;
  final String levelName;
  final String levelDescription;
  final int levelOrder;
  final String estimatedHours;
  final List<LessonInfo> lessons;
  final String quizlv;
  final bool isLocked;

  const Level({
    required this.levelId,
    required this.levelName,
    required this.levelDescription,
    required this.levelOrder,
    required this.estimatedHours,
    required this.lessons,
    required this.quizlv,
    required this.isLocked,
  });

  factory Level.fromJson(Map<String, dynamic> json) {
    return Level(
      levelId: json['levelId'] ?? '',
      levelName: json['levelName'] ?? '',
      levelDescription: json['levelDescription'] ?? '',
      levelOrder: json['levelOrder'] ?? 0,
      estimatedHours: json['estimatedHours'] ?? '',
      lessons: (json['lessons'] as List<dynamic>?)
          ?.map((lesson) => LessonInfo.fromJson(lesson))
          .toList() ?? [],
      quizlv: json['quizlv'] ?? '',
      isLocked: json['isLocked'] ?? true,
    );
  }
}

class LessonInfo {
  final String lessonId;
  final String lessonTitle;
  final int lessonOrder;
  final int estimatedMinutes;
  final String cardImage;
  final String quizId;
  final bool isLocked;

  const LessonInfo({
    required this.lessonId,
    required this.lessonTitle,
    required this.lessonOrder,
    required this.estimatedMinutes,
    required this.cardImage,
    required this.quizId,
    required this.isLocked,
  });

  factory LessonInfo.fromJson(Map<String, dynamic> json) {
    return LessonInfo(
      lessonId: json['lessonId'] ?? '',
      lessonTitle: json['lessonTitle'] ?? '',
      lessonOrder: json['lessonOrder'] ?? 0,
      estimatedMinutes: json['estimatedMinutes'] ?? 0,
      cardImage: json['cardImage'] ?? '',
      quizId: json['quizId'] ?? '',
      isLocked: json['isLocked'] ?? true,
    );
  }
}
