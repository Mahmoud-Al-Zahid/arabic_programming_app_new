class Slide {
  final String title;
  final String content;
  final String? code;
  final bool hasCode;
  final String? imageUrl;

  const Slide({
    required this.title,
    required this.content,
    this.code,
    this.hasCode = false,
    this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'code': code,
      'hasCode': hasCode,
      'imageUrl': imageUrl,
    };
  }

  factory Slide.fromJson(Map<String, dynamic> json) {
    return Slide(
      title: json['title'],
      content: json['content'],
      code: json['code'],
      hasCode: json['hasCode'] ?? false,
      imageUrl: json['imageUrl'],
    );
  }
}

class Lesson {
  final String id;
  final String title;
  final String description;
  final String content;
  final String trackId;
  final bool isUnlocked;
  final bool isCompleted;
  final int order;
  final List<Slide>? slides;
  final String? imageUrl;
  final int duration; // in minutes

  const Lesson({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.trackId,
    required this.isUnlocked,
    required this.isCompleted,
    required this.order,
    this.slides,
    this.imageUrl,
    this.duration = 15,
  });

  Lesson copyWith({
    String? id,
    String? title,
    String? description,
    String? content,
    String? trackId,
    bool? isUnlocked,
    bool? isCompleted,
    int? order,
    List<Slide>? slides,
    String? imageUrl,
    int? duration,
  }) {
    return Lesson(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      content: content ?? this.content,
      trackId: trackId ?? this.trackId,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      isCompleted: isCompleted ?? this.isCompleted,
      order: order ?? this.order,
      slides: slides ?? this.slides,
      imageUrl: imageUrl ?? this.imageUrl,
      duration: duration ?? this.duration,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'content': content,
      'trackId': trackId,
      'isUnlocked': isUnlocked,
      'isCompleted': isCompleted,
      'order': order,
      'slides': slides?.map((slide) => slide.toJson()).toList(),
      'imageUrl': imageUrl,
      'duration': duration,
    };
  }

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      content: json['content'],
      trackId: json['trackId'],
      isUnlocked: json['isUnlocked'] ?? false,
      isCompleted: json['isCompleted'] ?? false,
      order: json['order'] ?? 0,
      slides: json['slides'] != null
          ? (json['slides'] as List).map((slide) => Slide.fromJson(slide)).toList()
          : null,
      imageUrl: json['imageUrl'],
      duration: json['duration'] ?? 15,
    );
  }

  @override
  String toString() {
    return 'Lesson(id: $id, title: $title, order: $order)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Lesson && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
