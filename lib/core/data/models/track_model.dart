class TrackModel {
  final String id;
  final String title;
  final String icon;
  final bool isAccessible;
  final double progress;
  final int lessonsCount;
  final String description;

  const TrackModel({
    required this.id,
    required this.title,
    required this.icon,
    required this.isAccessible,
    required this.progress,
    required this.lessonsCount,
    required this.description,
  });

  factory TrackModel.fromJson(Map<String, dynamic> json) {
    return TrackModel(
      id: json['id'] as String,
      title: json['title'] as String,
      icon: json['icon'] as String,
      isAccessible: json['isAccessible'] as bool,
      progress: (json['progress'] as num).toDouble(),
      lessonsCount: json['lessonsCount'] as int,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'icon': icon,
      'isAccessible': isAccessible,
      'progress': progress,
      'lessonsCount': lessonsCount,
      'description': description,
    };
  }
}
