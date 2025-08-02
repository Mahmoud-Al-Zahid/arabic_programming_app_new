// نموذج منفصل للشرائح مع مميزات إضافية
class SlideModel {
  final String id;
  final String lessonId;
  final String type;
  final String title;
  final String? subtitle;
  final int order;
  final SlideContentModel content;
  final SlideNavigation navigation;
  final SlideInteraction interaction;
  final Map<String, dynamic> metadata;

  const SlideModel({
    required this.id,
    required this.lessonId,
    required this.type,
    required this.title,
    this.subtitle,
    required this.order,
    required this.content,
    required this.navigation,
    required this.interaction,
    this.metadata = const {},
  });

  factory SlideModel.fromJson(Map<String, dynamic> json) {
    return SlideModel(
      id: json['id'] ?? '',
      lessonId: json['lessonId'] ?? '',
      type: json['type'] ?? '',
      title: json['title'] ?? '',
      subtitle: json['subtitle'],
      order: json['order'] ?? 0,
      content: SlideContentModel.fromJson(json['content'] ?? {}),
      navigation: SlideNavigation.fromJson(json['navigation'] ?? {}),
      interaction: SlideInteraction.fromJson(json['interaction'] ?? {}),
      metadata: json['metadata'] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lessonId': lessonId,
      'type': type,
      'title': title,
      'subtitle': subtitle,
      'order': order,
      'content': content.toJson(),
      'navigation': navigation.toJson(),
      'interaction': interaction.toJson(),
      'metadata': metadata,
    };
  }

  SlideModel copyWith({
    String? id,
    String? lessonId,
    String? type,
    String? title,
    String? subtitle,
    int? order,
    SlideContentModel? content,
    SlideNavigation? navigation,
    SlideInteraction? interaction,
    Map<String, dynamic>? metadata,
  }) {
    return SlideModel(
      id: id ?? this.id,
      lessonId: lessonId ?? this.lessonId,
      type: type ?? this.type,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      order: order ?? this.order,
      content: content ?? this.content,
      navigation: navigation ?? this.navigation,
      interaction: interaction ?? this.interaction,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SlideModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class SlideContentModel {
  final String? text;
  final String? image;
  final String? video;
  final String? audio;
  final CodeSnippetModel? codeSnippet;
  final List<String>? bulletPoints;
  final List<String>? highlights;
  final String? callToAction;
  final Map<String, dynamic>? customData;

  const SlideContentModel({
    this.text,
    this.image,
    this.video,
    this.audio,
    this.codeSnippet,
    this.bulletPoints,
    this.highlights,
    this.callToAction,
    this.customData,
  });

  factory SlideContentModel.fromJson(Map<String, dynamic> json) {
    return SlideContentModel(
      text: json['text'],
      image: json['image'],
      video: json['video'],
      audio: json['audio'],
      codeSnippet: json['codeSnippet'] != null 
          ? CodeSnippetModel.fromJson(json['codeSnippet']) 
          : null,
      bulletPoints: (json['bulletPoints'] as List<dynamic>?)?.cast<String>(),
      highlights: (json['highlights'] as List<dynamic>?)?.cast<String>(),
      callToAction: json['callToAction'],
      customData: json['customData'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'image': image,
      'video': video,
      'audio': audio,
      'codeSnippet': codeSnippet?.toJson(),
      'bulletPoints': bulletPoints,
      'highlights': highlights,
      'callToAction': callToAction,
      'customData': customData,
    };
  }
}

class CodeSnippetModel {
  final String code;
  final String language;
  final String? explanation;
  final String? output;
  final bool isExecutable;
  final bool showLineNumbers;
  final String? theme;

  const CodeSnippetModel({
    required this.code,
    required this.language,
    this.explanation,
    this.output,
    required this.isExecutable,
    required this.showLineNumbers,
    this.theme,
  });

  factory CodeSnippetModel.fromJson(Map<String, dynamic> json) {
    return CodeSnippetModel(
      code: json['code'] ?? '',
      language: json['language'] ?? '',
      explanation: json['explanation'],
      output: json['output'],
      isExecutable: json['isExecutable'] ?? false,
      showLineNumbers: json['showLineNumbers'] ?? true,
      theme: json['theme'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'language': language,
      'explanation': explanation,
      'output': output,
      'isExecutable': isExecutable,
      'showLineNumbers': showLineNumbers,
      'theme': theme,
    };
  }
}

class SlideNavigation {
  final bool canGoNext;
  final bool canGoPrevious;
  final bool autoAdvance;
  final int? autoAdvanceDelay;
  final String? nextSlideId;
  final String? previousSlideId;

  const SlideNavigation({
    required this.canGoNext,
    required this.canGoPrevious,
    required this.autoAdvance,
    this.autoAdvanceDelay,
    this.nextSlideId,
    this.previousSlideId,
  });

  factory SlideNavigation.fromJson(Map<String, dynamic> json) {
    return SlideNavigation(
      canGoNext: json['canGoNext'] ?? true,
      canGoPrevious: json['canGoPrevious'] ?? true,
      autoAdvance: json['autoAdvance'] ?? false,
      autoAdvanceDelay: json['autoAdvanceDelay'],
      nextSlideId: json['nextSlideId'],
      previousSlideId: json['previousSlideId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'canGoNext': canGoNext,
      'canGoPrevious': canGoPrevious,
      'autoAdvance': autoAdvance,
      'autoAdvanceDelay': autoAdvanceDelay,
      'nextSlideId': nextSlideId,
      'previousSlideId': previousSlideId,
    };
  }
}

class SlideInteraction {
  final bool requiresUserAction;
  final String? actionType;
  final Map<String, dynamic>? actionData;
  final bool trackViewTime;
  final int? minimumViewTime;

  const SlideInteraction({
    required this.requiresUserAction,
    this.actionType,
    this.actionData,
    required this.trackViewTime,
    this.minimumViewTime,
  });

  factory SlideInteraction.fromJson(Map<String, dynamic> json) {
    return SlideInteraction(
      requiresUserAction: json['requiresUserAction'] ?? false,
      actionType: json['actionType'],
      actionData: json['actionData'],
      trackViewTime: json['trackViewTime'] ?? true,
      minimumViewTime: json['minimumViewTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'requiresUserAction': requiresUserAction,
      'actionType': actionType,
      'actionData': actionData,
      'trackViewTime': trackViewTime,
      'minimumViewTime': minimumViewTime,
    };
  }
}
