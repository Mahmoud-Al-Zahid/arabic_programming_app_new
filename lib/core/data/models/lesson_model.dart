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
  final String? backgroundImage;

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
    this.backgroundImage,
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
    String? backgroundImage,
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
      backgroundImage: backgroundImage ?? this.backgroundImage,
    );
  }
}

class Slide {
  final String title;
  final String content;
  final String? code;
  final bool hasCode;

  const Slide({
    required this.title,
    required this.content,
    this.code,
    this.hasCode = false,
  });
}
