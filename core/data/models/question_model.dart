// نموذج منفصل للأسئلة مع مميزات إضافية
class QuestionModel {
  final String id;
  final String quizId;
  final String type;
  final String text;
  final String? description;
  final int points;
  final int order;
  final String difficulty;
  final List<String> tags;
  final QuestionContentModel content;
  final QuestionValidation validation;
  final QuestionFeedback feedback;
  final Map<String, dynamic> metadata;

  const QuestionModel({
    required this.id,
    required this.quizId,
    required this.type,
    required this.text,
    this.description,
    required this.points,
    required this.order,
    required this.difficulty,
    required this.tags,
    required this.content,
    required this.validation,
    required this.feedback,
    this.metadata = const {},
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'] ?? '',
      quizId: json['quizId'] ?? '',
      type: json['type'] ?? '',
      text: json['text'] ?? '',
      description: json['description'],
      points: json['points'] ?? 1,
      order: json['order'] ?? 0,
      difficulty: json['difficulty'] ?? 'easy',
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      content: QuestionContentModel.fromJson(json['content'] ?? {}),
      validation: QuestionValidation.fromJson(json['validation'] ?? {}),
      feedback: QuestionFeedback.fromJson(json['feedback'] ?? {}),
      metadata: json['metadata'] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quizId': quizId,
      'type': type,
      'text': text,
      'description': description,
      'points': points,
      'order': order,
      'difficulty': difficulty,
      'tags': tags,
      'content': content.toJson(),
      'validation': validation.toJson(),
      'feedback': feedback.toJson(),
      'metadata': metadata,
    };
  }

  QuestionModel copyWith({
    String? id,
    String? quizId,
    String? type,
    String? text,
    String? description,
    int? points,
    int? order,
    String? difficulty,
    List<String>? tags,
    QuestionContentModel? content,
    QuestionValidation? validation,
    QuestionFeedback? feedback,
    Map<String, dynamic>? metadata,
  }) {
    return QuestionModel(
      id: id ?? this.id,
      quizId: quizId ?? this.quizId,
      type: type ?? this.type,
      text: text ?? this.text,
      description: description ?? this.description,
      points: points ?? this.points,
      order: order ?? this.order,
      difficulty: difficulty ?? this.difficulty,
      tags: tags ?? this.tags,
      content: content ?? this.content,
      validation: validation ?? this.validation,
      feedback: feedback ?? this.feedback,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is QuestionModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class QuestionContentModel {
  final String? image;
  final String? video;
  final String? audio;
  final CodeSnippetModel? codeSnippet;
  final List<OptionModel>? options;
  final List<String>? correctAnswers;
  final String? expectedOutput;
  final Map<String, dynamic>? customData;

  const QuestionContentModel({
    this.image,
    this.video,
    this.audio,
    this.codeSnippet,
    this.options,
    this.correctAnswers,
    this.expectedOutput,
    this.customData,
  });

  factory QuestionContentModel.fromJson(Map<String, dynamic> json) {
    return QuestionContentModel(
      image: json['image'],
      video: json['video'],
      audio: json['audio'],
      codeSnippet: json['codeSnippet'] != null 
          ? CodeSnippetModel.fromJson(json['codeSnippet']) 
          : null,
      options: (json['options'] as List<dynamic>?)
          ?.map((option) => OptionModel.fromJson(option))
          .toList(),
      correctAnswers: (json['correctAnswers'] as List<dynamic>?)?.cast<String>(),
      expectedOutput: json['expectedOutput'],
      customData: json['customData'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'video': video,
      'audio': audio,
      'codeSnippet': codeSnippet?.toJson(),
      'options': options?.map((o) => o.toJson()).toList(),
      'correctAnswers': correctAnswers,
      'expectedOutput': expectedOutput,
      'customData': customData,
    };
  }
}

class OptionModel {
  final String id;
  final String text;
  final bool isCorrect;
  final String? explanation;
  final String? image;

  const OptionModel({
    required this.id,
    required this.text,
    required this.isCorrect,
    this.explanation,
    this.image,
  });

  factory OptionModel.fromJson(Map<String, dynamic> json) {
    return OptionModel(
      id: json['id'] ?? '',
      text: json['text'] ?? '',
      isCorrect: json['isCorrect'] ?? false,
      explanation: json['explanation'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'isCorrect': isCorrect,
      'explanation': explanation,
      'image': image,
    };
  }
}

class QuestionValidation {
  final bool caseSensitive;
  final bool trimWhitespace;
  final List<String>? acceptableAnswers;
  final String? validationRegex;
  final int? minLength;
  final int? maxLength;

  const QuestionValidation({
    required this.caseSensitive,
    required this.trimWhitespace,
    this.acceptableAnswers,
    this.validationRegex,
    this.minLength,
    this.maxLength,
  });

  factory QuestionValidation.fromJson(Map<String, dynamic> json) {
    return QuestionValidation(
      caseSensitive: json['caseSensitive'] ?? false,
      trimWhitespace: json['trimWhitespace'] ?? true,
      acceptableAnswers: (json['acceptableAnswers'] as List<dynamic>?)?.cast<String>(),
      validationRegex: json['validationRegex'],
      minLength: json['minLength'],
      maxLength: json['maxLength'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'caseSensitive': caseSensitive,
      'trimWhitespace': trimWhitespace,
      'acceptableAnswers': acceptableAnswers,
      'validationRegex': validationRegex,
      'minLength': minLength,
      'maxLength': maxLength,
    };
  }
}

class QuestionFeedback {
  final String? correctFeedback;
  final String? incorrectFeedback;
  final String? partialFeedback;
  final List<String>? hints;
  final String? explanation;

  const QuestionFeedback({
    this.correctFeedback,
    this.incorrectFeedback,
    this.partialFeedback,
    this.hints,
    this.explanation,
  });

  factory QuestionFeedback.fromJson(Map<String, dynamic> json) {
    return QuestionFeedback(
      correctFeedback: json['correctFeedback'],
      incorrectFeedback: json['incorrectFeedback'],
      partialFeedback: json['partialFeedback'],
      hints: (json['hints'] as List<dynamic>?)?.cast<String>(),
      explanation: json['explanation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'correctFeedback': correctFeedback,
      'incorrectFeedback': incorrectFeedback,
      'partialFeedback': partialFeedback,
      'hints': hints,
      'explanation': explanation,
    };
  }
}
