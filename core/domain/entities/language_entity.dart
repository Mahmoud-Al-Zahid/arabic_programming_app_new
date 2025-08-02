class LanguageEntity {
  final String id;
  final String name;
  final String description;
  final String icon;
  final String color;
  final bool isPopular;
  final String difficulty;
  final int estimatedHours;
  final List<String> features;
  final String image;

  const LanguageEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.isPopular,
    required this.difficulty,
    required this.estimatedHours,
    required this.features,
    required this.image,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LanguageEntity &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.icon == icon &&
        other.color == color &&
        other.isPopular == isPopular &&
        other.difficulty == difficulty &&
        other.estimatedHours == estimatedHours &&
        _listEquals(other.features, features) &&
        other.image == image;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      description,
      icon,
      color,
      isPopular,
      difficulty,
      estimatedHours,
      Object.hashAll(features),
      image,
    );
  }

  @override
  String toString() {
    return 'LanguageEntity(id: $id, name: $name, difficulty: $difficulty, estimatedHours: $estimatedHours)';
  }

  LanguageEntity copyWith({
    String? id,
    String? name,
    String? description,
    String? icon,
    String? color,
    bool? isPopular,
    String? difficulty,
    int? estimatedHours,
    List<String>? features,
    String? image,
  }) {
    return LanguageEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      isPopular: isPopular ?? this.isPopular,
      difficulty: difficulty ?? this.difficulty,
      estimatedHours: estimatedHours ?? this.estimatedHours,
      features: features ?? this.features,
      image: image ?? this.image,
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
