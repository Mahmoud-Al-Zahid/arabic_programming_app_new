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
  final DateTime createdAt;
  final DateTime lastActiveAt;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    required this.level,
    required this.xp,
    required this.coins,
    required this.completedLessons,
    required this.unlockedTracks,
    required this.createdAt,
    required this.lastActiveAt,
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
    DateTime? createdAt,
    DateTime? lastActiveAt,
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
      createdAt: createdAt ?? this.createdAt,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
    );
  }
}
