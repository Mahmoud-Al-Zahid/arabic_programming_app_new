class LessonModel {
  final String id;
  final String title;
  final String trackId;
  final List<SlideModel> slides;

  const LessonModel({
    required this.id,
    required this.title,
    required this.trackId,
    required this.slides,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['id'] as String,
      title: json['title'] as String,
      trackId: json['trackId'] as String,
      slides: (json['slides'] as List)
          .map((slide) => SlideModel.fromJson(slide as Map<String, dynamic>))
          .toList(),
    );
  }
}

class SlideModel {
  final String title;
  final String content;
  final String? code;
  final bool hasCode;

  const SlideModel({
    required this.title,
    required this.content,
    this.code,
    required this.hasCode,
  });

  factory SlideModel.fromJson(Map<String, dynamic> json) {
    return SlideModel(
      title: json['title'] as String,
      content: json['content'] as String,
      code: json['code'] as String?,
      hasCode: json['hasCode'] as bool,
    );
  }
}
