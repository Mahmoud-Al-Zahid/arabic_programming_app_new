class User {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final int level;
  final int xp;
  final int coins;
  final List<String> completedLessons;
  final List<String> unlockedTracks;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.level = 1,
    this.xp = 0,
    this.coins = 0,
    this.completedLessons = const [],
    this.unlockedTracks = const [],
  });

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? avatarUrl,
    int? level,
    int? xp,
    int? coins,
    List<String>? completedLessons,
    List<String>? unlockedTracks,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      level: level ?? this.level,
      xp: xp ?? this.xp,
      coins: coins ?? this.coins,
      completedLessons: completedLessons ?? this.completedLessons,
      unlockedTracks: unlockedTracks ?? this.unlockedTracks,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
      'level': level,
      'xp': xp,
      'coins': coins,
      'completedLessons': completedLessons,
      'unlockedTracks': unlockedTracks,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      avatarUrl: json['avatarUrl'],
      level: json['level'] ?? 1,
      xp: json['xp'] ?? 0,
      coins: json['coins'] ?? 0,
      completedLessons: List<String>.from(json['completedLessons'] ?? []),
      unlockedTracks: List<String>.from(json['unlockedTracks'] ?? []),
    );
  }

  @override
  String toString() {
    return 'User(id: $id, name: $name, level: $level)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
