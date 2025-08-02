// هذا الملف يحتوي على نماذج المستوى المنفصلة عن الكورس
class LevelModel {
  final String id;
  final String name;
  final String description;
  final int order;
  final String languageId;
  final String courseId;
  final int estimatedHours;
  final List<String> lessonIds;
  final String quizId;
  final LevelRequirements requirements;
  final LevelRewards rewards;
  final Map<String, dynamic> metadata;

  const LevelModel({
    required this.id,
    required this.name,
    required this.description,
    required this.order,
    required this.languageId,
    required this.courseId,
    required this.estimatedHours,
    required this.lessonIds,
    required this.quizId,
    required this.requirements,
    required this.rewards,
    this.metadata = const {},
  });

  factory LevelModel.fromJson(Map<String, dynamic> json) {
    return LevelModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      order: json['order'] ?? 0,
      languageId: json['languageId'] ?? '',
      courseId: json['courseId'] ?? '',
      estimatedHours: json['estimatedHours'] ?? 0,
      lessonIds: (json['lessonIds'] as List<dynamic>?)?.cast<String>() ?? [],
      quizId: json['quizId'] ?? '',
      requirements: LevelRequirements.fromJson(json['requirements'] ?? {}),
      rewards: LevelRewards.fromJson(json['rewards'] ?? {}),
      metadata: json['metadata'] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'order': order,
      'languageId': languageId,
      'courseId': courseId,
      'estimatedHours': estimatedHours,
      'lessonIds': lessonIds,
      'quizId': quizId,
      'requirements': requirements.toJson(),
      'rewards': rewards.toJson(),
      'metadata': metadata,
    };
  }

  LevelModel copyWith({
    String? id,
    String? name,
    String? description,
    int? order,
    String? languageId,
    String? courseId,
    int? estimatedHours,
    List<String>? lessonIds,
    String? quizId,
    LevelRequirements? requirements,
    LevelRewards? rewards,
    Map<String, dynamic>? metadata,
  }) {
    return LevelModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      order: order ?? this.order,
      languageId: languageId ?? this.languageId,
      courseId: courseId ?? this.courseId,
      estimatedHours: estimatedHours ?? this.estimatedHours,
      lessonIds: lessonIds ?? this.lessonIds,
      quizId: quizId ?? this.quizId,
      requirements: requirements ?? this.requirements,
      rewards: rewards ?? this.rewards,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LevelModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class LevelRequirements {
  final List<String> completedLessons;
  final List<String> completedQuizzes;
  final int minimumScore;
  final int minimumXp;
  final bool unlockNextLevel;

  const LevelRequirements({
    required this.completedLessons,
    required this.completedQuizzes,
    required this.minimumScore,
    required this.minimumXp,
    required this.unlockNextLevel,
  });

  factory LevelRequirements.fromJson(Map<String, dynamic> json) {
    return LevelRequirements(
      completedLessons: (json['completedLessons'] as List<dynamic>?)?.cast<String>() ?? [],
      completedQuizzes: (json['completedQuizzes'] as List<dynamic>?)?.cast<String>() ?? [],
      minimumScore: json['minimumScore'] ?? 0,
      minimumXp: json['minimumXp'] ?? 0,
      unlockNextLevel: json['unlockNextLevel'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'completedLessons': completedLessons,
      'completedQuizzes': completedQuizzes,
      'minimumScore': minimumScore,
      'minimumXp': minimumXp,
      'unlockNextLevel': unlockNextLevel,
    };
  }
}

class LevelRewards {
  final int xp;
  final int coins;
  final List<String> badges;
  final List<String> unlockedFeatures;

  const LevelRewards({
    required this.xp,
    required this.coins,
    required this.badges,
    required this.unlockedFeatures,
  });

  factory LevelRewards.fromJson(Map<String, dynamic> json) {
    return LevelRewards(
      xp: json['xp'] ?? 0,
      coins: json['coins'] ?? 0,
      badges: (json['badges'] as List<dynamic>?)?.cast<String>() ?? [],
      unlockedFeatures: (json['unlockedFeatures'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'xp': xp,
      'coins': coins,
      'badges': badges,
      'unlockedFeatures': unlockedFeatures,
    };
  }
}
