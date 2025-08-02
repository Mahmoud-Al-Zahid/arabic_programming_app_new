class Language {
  final String id;
  final String name;
  final String icon;
  final String image;
  final String estimatedHours;
  final String description;
  final String difficulty;
  final int popularity;
  final String color;

  const Language({
    required this.id,
    required this.name,
    required this.icon,
    required this.image,
    required this.estimatedHours,
    required this.description,
    required this.difficulty,
    required this.popularity,
    required this.color,
  });

  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      icon: json['icon'] ?? '',
      image: json['image'] ?? '',
      estimatedHours: json['estimatedHours'] ?? '',
      description: json['description'] ?? '',
      difficulty: json['difficulty'] ?? '',
      popularity: json['popularity'] ?? 0,
      color: json['color'] ?? '#000000',
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
      'popularity': popularity,
      'color': color,
    };
  }
}
