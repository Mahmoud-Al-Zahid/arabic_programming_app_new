class Course {
  final String languageId;
  final String languageName;
  final String helloLanguage;
  final String description;
  final int totalLevels;
  final int estimatedHours;
  final List<Level> levels;
  final String finalExam;
  final String courseCertificate;
  final Map<String, String> resources;
  final Map<String, dynamic> metadata;

  const Course({
    required this.languageId,
    required this.languageName,
    required this.helloLanguage,
    required this.description,
    required this.totalLevels,
    required this.estimatedHours,
    required this.levels,
    required this.finalExam,
    required this.courseCertificate,
    required this.resources,
    this.metadata = const {},
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      languageId: json['languageId'] ?? '',
      languageName: json['languageName'] ?? '',
      helloLanguage: json['helloLanguage'] ?? '',
      description: json['description'] ?? '',
      totalLevels: json['totalLevels'] ?? 0,
      estimatedHours: json['estimatedHours'] ?? 0,
      levels: (json['levels'] as List<dynamic>?)
          ?.map((level) => Level.fromJson(level))
          .toList() ?? [],
      finalExam: json['finalExam'] ?? '',
      courseCertificate: json['courseCertificate'] ?? '',
      resources: Map<String, String>.from(json['resources'] ?? {}),
      metadata: json['metadata'] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'languageId': languageId,
      'languageName': languageName,
      'helloLanguage': helloLanguage,
      'description': description,
      'totalLevels': totalLevels,
      'estimatedHours': estimatedHours,
      'levels': levels.map((level) => level.toJson()).toList(),
      'finalExam': finalExam,
      'courseCertificate': courseCertificate,
      'resources': resources,
      'metadata': metadata,
    };
  }

  Course copyWith({
    String? languageId,
    String? languageName,
    String? helloLanguage,
    String? description,
    int? totalLevels,
    int? estimatedHours,
    List<Level>? levels,
    String? finalExam,
    String? courseCertificate,
    Map<String, String>? resources,
    Map<String, dynamic>? metadata,
  }) {
    return Course(
      languageId: languageId ?? this.languageId,
      languageName: languageName ?? this.languageName,
      helloLanguage: helloLanguage ?? this.helloLanguage,
      description: description ?? this.description,
      totalLevels: totalLevels ?? this.totalLevels,
      estimatedHours: estimatedHours ?? this.estimatedHours,
      levels: levels ?? this.levels,
      finalExam: finalExam ?? this.finalExam,
      courseCertificate: courseCertificate ?? this.courseCertificate,
      resources: resources ?? this.resources,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Course && other.languageId == languageId;
  }

  @override
  int get hashCode => languageId.hashCode;
}

class Level {
  final String levelId;
  final String levelName;
  final String levelDescription;
  final int levelOrder;
  final int estimatedHours;
  final List<LessonInfo> lessons;
  final String quizlv;
  final Map<String, dynamic> metadata;

  const Level({
    required this.levelId,
    required this.levelName,
    required this.levelDescription,
    required this.levelOrder,
    required this.estimatedHours,
    required this.lessons,
    required this.quizlv,
    this.metadata = const {},
  });

  factory Level.fromJson(Map<String, dynamic> json) {
    return Level(
      levelId: json['levelId'] ?? '',
      levelName: json['levelName'] ?? '',
      levelDescription: json['levelDescription'] ?? '',
      levelOrder: json['levelOrder'] ?? 0,
      estimatedHours: json['estimatedHours'] ?? 0,
      lessons: (json['lessons'] as List<dynamic>?)
          ?.map((lesson) => LessonInfo.fromJson(lesson))
          .toList() ?? [],
      quizlv: json['quizlv'] ?? '',
      metadata: json['metadata'] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'levelId': levelId,
      'levelName': levelName,
      'levelDescription': levelDescription,
      'levelOrder': levelOrder,
      'estimatedHours': estimatedHours,
      'lessons': lessons.map((lesson) => lesson.toJson()).toList(),
      'quizlv': quizlv,
      'metadata': metadata,
    };
  }

  Level copyWith({
    String? levelId,
    String? levelName,
    String? levelDescription,
    int? levelOrder,
    int? estimatedHours,
    List<LessonInfo>? lessons,
    String? quizlv,
    Map<String, dynamic>? metadata,
  }) {
    return Level(
      levelId: levelId ?? this.levelId,
      levelName: levelName ?? this.levelName,
      levelDescription: levelDescription ?? this.levelDescription,
      levelOrder: levelOrder ?? this.levelOrder,
      estimatedHours: estimatedHours ?? this.estimatedHours,
      lessons: lessons ?? this.lessons,
      quizlv: quizlv ?? this.quizlv,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Level && other.levelId == levelId;
  }

  @override
  int get hashCode => levelId.hashCode;
}

class LessonInfo {
  final String lessonId;
  final String lessonTitle;
  final int lessonOrder;
  final String cardImage;
  final String quizId;
  final int estimatedMinutes;
  final String difficulty;
  final Map<String, dynamic> metadata;

  const LessonInfo({
    required this.lessonId,
    required this.lessonTitle,
    required this.lessonOrder,
    required this.cardImage,
    required this.quizId,
    required this.estimatedMinutes,
    required this.difficulty,
    this.metadata = const {},
  });

  factory LessonInfo.fromJson(Map<String, dynamic> json) {
    return LessonInfo(
      lessonId: json['lessonId'] ?? '',
      lessonTitle: json['lessonTitle'] ?? '',
      lessonOrder: json['lessonOrder'] ?? 0,
      cardImage: json['cardImage'] ?? '',
      quizId: json['quizId'] ?? '',
      estimatedMinutes: json['estimatedMinutes'] ?? 0,
      difficulty: json['difficulty'] ?? 'مبتدئ',
      metadata: json['metadata'] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lessonId': lessonId,
      'lessonTitle': lessonTitle,
      'lessonOrder': lessonOrder,
      'cardImage': cardImage,
      'quizId': quizId,
      'estimatedMinutes': estimatedMinutes,
      'difficulty': difficulty,
      'metadata': metadata,
    };
  }

  LessonInfo copyWith({
    String? lessonId,
    String? lessonTitle,
    int? lessonOrder,
    String? cardImage,
    String? quizId,
    int? estimatedMinutes,
    String? difficulty,
    Map<String, dynamic>? metadata,
  }) {
    return LessonInfo(
      lessonId: lessonId ?? this.lessonId,
      lessonTitle: lessonTitle ?? this.lessonTitle,
      lessonOrder: lessonOrder ?? this.lessonOrder,
      cardImage: cardImage ?? this.cardImage,
      quizId: quizId ?? this.quizId,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      difficulty: difficulty ?? this.difficulty,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LessonInfo && other.lessonId == lessonId;
  }

  @override
  int get hashCode => lessonId.hashCode;
}
