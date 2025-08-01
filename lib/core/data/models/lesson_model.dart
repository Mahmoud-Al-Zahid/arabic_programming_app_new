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
  });
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
    required this.hasCode,
  });
}
