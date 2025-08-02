// نموذج شامل للمحتوى التعليمي
class ContentModel {
  final String id;
  final String type;
  final String title;
  final String? description;
  final String languageId;
  final String? courseId;
  final String? levelId;
  final String? lessonId;
  final ContentData data;
  final ContentMetadata metadata;
  final ContentSettings settings;

  const ContentModel({
    required this.id,
    required this.type,
    required this.title,
    this.description,
    required this.languageId,
    this.courseId,
    this.levelId,
    this.lessonId,
    required this.data,
    required this.metadata,
    required this.settings,
  });

  factory ContentModel.fromJson(Map<String, dynamic> json) {
    return ContentModel(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      languageId: json['languageId'] ?? '',
      courseId: json['courseId'],
      levelId: json['levelId'],
      lessonId: json['lessonId'],
      data: ContentData.fromJson(json['data'] ?? {}),
      metadata: ContentMetadata.fromJson(json['metadata'] ?? {}),
      settings: ContentSettings.fromJson(json['settings'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'description': description,
      'languageId': languageId,
      'courseId': courseId,
      'levelId': levelId,
      'lessonId': lessonId,
      'data': data.toJson(),
      'metadata': metadata.toJson(),
      'settings': settings.toJson(),
    };
  }

  ContentModel copyWith({
    String? id,
    String? type,
    String? title,
    String? description,
    String? languageId,
    String? courseId,
    String? levelId,
    String? lessonId,
    ContentData? data,
    ContentMetadata? metadata,
    ContentSettings? settings,
  }) {
    return ContentModel(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      languageId: languageId ?? this.languageId,
      courseId: courseId ?? this.courseId,
      levelId: levelId ?? this.levelId,
      lessonId: lessonId ?? this.lessonId,
      data: data ?? this.data,
      metadata: metadata ?? this.metadata,
      settings: settings ?? this.settings,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ContentModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class ContentData {
  final String? text;
  final String? html;
  final String? markdown;
  final List<String>? images;
  final List<String>? videos;
  final List<String>? audios;
  final List<CodeExample>? codeExamples;
  final List<InteractiveElement>? interactiveElements;
  final Map<String, dynamic>? customData;

  const ContentData({
    this.text,
    this.html,
    this.markdown,
    this.images,
    this.videos,
    this.audios,
    this.codeExamples,
    this.interactiveElements,
    this.customData,
  });

  factory ContentData.fromJson(Map<String, dynamic> json) {
    return ContentData(
      text: json['text'],
      html: json['html'],
      markdown: json['markdown'],
      images: (json['images'] as List<dynamic>?)?.cast<String>(),
      videos: (json['videos'] as List<dynamic>?)?.cast<String>(),
      audios: (json['audios'] as List<dynamic>?)?.cast<String>(),
      codeExamples: (json['codeExamples'] as List<dynamic>?)
          ?.map((example) => CodeExample.fromJson(example))
          .toList(),
      interactiveElements: (json['interactiveElements'] as List<dynamic>?)
          ?.map((element) => InteractiveElement.fromJson(element))
          .toList(),
      customData: json['customData'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'html': html,
      'markdown': markdown,
      'images': images,
      'videos': videos,
      'audios': audios,
      'codeExamples': codeExamples?.map((e) => e.toJson()).toList(),
      'interactiveElements': interactiveElements?.map((e) => e.toJson()).toList(),
      'customData': customData,
    };
  }
}

class CodeExample {
  final String id;
  final String language;
  final String code;
  final String? explanation;
  final String? output;
  final bool isExecutable;
  final bool showLineNumbers;
  final String? theme;

  const CodeExample({
    required this.id,
    required this.language,
    required this.code,
    this.explanation,
    this.output,
    required this.isExecutable,
    required this.showLineNumbers,
    this.theme,
  });

  factory CodeExample.fromJson(Map<String, dynamic> json) {
    return CodeExample(
      id: json['id'] ?? '',
      language: json['language'] ?? '',
      code: json['code'] ?? '',
      explanation: json['explanation'],
      output: json['output'],
      isExecutable: json['isExecutable'] ?? false,
      showLineNumbers: json['showLineNumbers'] ?? true,
      theme: json['theme'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'language': language,
      'code': code,
      'explanation': explanation,
      'output': output,
      'isExecutable': isExecutable,
      'showLineNumbers': showLineNumbers,
      'theme': theme,
    };
  }
}

class InteractiveElement {
  final String id;
  final String type;
  final String title;
  final Map<String, dynamic> config;
  final Map<String, dynamic> data;

  const InteractiveElement({
    required this.id,
    required this.type,
    required this.title,
    required this.config,
    required this.data,
  });

  factory InteractiveElement.fromJson(Map<String, dynamic> json) {
    return InteractiveElement(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      title: json['title'] ?? '',
      config: json['config'] ?? {},
      data: json['data'] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'config': config,
      'data': data,
    };
  }
}

class ContentMetadata {
  final String author;
  final DateTime createdDate;
  final DateTime? updatedDate;
  final String version;
  final List<String> tags;
  final String difficulty;
  final int estimatedTime;
  final String category;
  final Map<String, dynamic> customMetadata;

  const ContentMetadata({
    required this.author,
    required this.createdDate,
    this.updatedDate,
    required this.version,
    required this.tags,
    required this.difficulty,
    required this.estimatedTime,
    required this.category,
    this.customMetadata = const {},
  });

  factory ContentMetadata.fromJson(Map<String, dynamic> json) {
    return ContentMetadata(
      author: json['author'] ?? '',
      createdDate: DateTime.parse(json['createdDate'] ?? DateTime.now().toIso8601String()),
      updatedDate: json['updatedDate'] != null 
          ? DateTime.parse(json['updatedDate']) 
          : null,
      version: json['version'] ?? '1.0.0',
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      difficulty: json['difficulty'] ?? 'beginner',
      estimatedTime: json['estimatedTime'] ?? 0,
      category: json['category'] ?? '',
      customMetadata: json['customMetadata'] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'author': author,
      'createdDate': createdDate.toIso8601String(),
      'updatedDate': updatedDate?.toIso8601String(),
      'version': version,
      'tags': tags,
      'difficulty': difficulty,
      'estimatedTime': estimatedTime,
      'category': category,
      'customMetadata': customMetadata,
    };
  }
}

class ContentSettings {
  final bool isPublic;
  final bool allowComments;
  final bool trackProgress;
  final bool requiresAuth;
  final List<String> prerequisites;
  final Map<String, dynamic> customSettings;

  const ContentSettings({
    required this.isPublic,
    required this.allowComments,
    required this.trackProgress,
    required this.requiresAuth,
    required this.prerequisites,
    this.customSettings = const {},
  });

  factory ContentSettings.fromJson(Map<String, dynamic> json) {
    return ContentSettings(
      isPublic: json['isPublic'] ?? true,
      allowComments: json['allowComments'] ?? false,
      trackProgress: json['trackProgress'] ?? true,
      requiresAuth: json['requiresAuth'] ?? false,
      prerequisites: (json['prerequisites'] as List<dynamic>?)?.cast<String>() ?? [],
      customSettings: json['customSettings'] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isPublic': isPublic,
      'allowComments': allowComments,
      'trackProgress': trackProgress,
      'requiresAuth': requiresAuth,
      'prerequisites': prerequisites,
      'customSettings': customSettings,
    };
  }
}
