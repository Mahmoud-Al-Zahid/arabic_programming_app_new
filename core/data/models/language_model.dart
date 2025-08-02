class Language {
  final String id;
  final String name;
  final String icon;
  final String image;
  final String estimatedHours;
  final String description;
  final String difficulty;
  final String color;
  final bool isPopular;
  final List<String> features;
  final Map<String, dynamic> metadata;

  const Language({
    required this.id,
    required this.name,
    required this.icon,
    required this.image,
    required this.estimatedHours,
    required this.description,
    required this.difficulty,
    required this.color,
    required this.isPopular,
    required this.features,
    this.metadata = const {},
  });

  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      icon: json['icon'] ?? '',
      image: json['image'] ?? '',
      estimatedHours: json['estimatedHours'] ?? '',
      description: json['description'] ?? '',
      difficulty: json['difficulty'] ?? 'مبتدئ',
      color: json['color'] ?? '#000000',
      isPopular: json['isPopular'] ?? false,
      features: (json['features'] as List<dynamic>?)?.cast<String>() ?? [],
      metadata: json['metadata'] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'image': image,
      'estimatedHours': estimatedHours,
      'description': description,
      'difficulty': difficulty,
      'color': color,
      'isPopular': isPopular,
      'features': features,
      'metadata': metadata,
    };
  }

  Language copyWith({
    String? id,
    String? name,
    String? icon,
    String? image,
    String? estimatedHours,
    String? description,
    String? difficulty,
    String? color,
    bool? isPopular,
    List<String>? features,
    Map<String, dynamic>? metadata,
  }) {
    return Language(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      image: image ?? this.image,
      estimatedHours: estimatedHours ?? this.estimatedHours,
      description: description ?? this.description,
      difficulty: difficulty ?? this.difficulty,
      color: color ?? this.color,
      isPopular: isPopular ?? this.isPopular,
      features: features ?? this.features,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Language && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Language(id: $id, name: $name, difficulty: $difficulty)';
  }
}
