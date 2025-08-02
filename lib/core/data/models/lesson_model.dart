class Lesson {
  final String lessonId;
  final String lessonTitle;
  final String lessonDescription;
  final int estimatedMinutes;
  final List<Slide> slides;
  final String quizles;
  final List<Resource> resources;
  final List<CommonMistake> commonMistakes;

  const Lesson({
    required this.lessonId,
    required this.lessonTitle,
    required this.lessonDescription,
    required this.estimatedMinutes,
    required this.slides,
    required this.quizles,
    required this.resources,
    required this.commonMistakes,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      lessonId: json['lessonId'] ?? '',
      lessonTitle: json['lessonTitle'] ?? '',
      lessonDescription: json['lessonDescription'] ?? '',
      estimatedMinutes: json['estimatedMinutes'] ?? 0,
      slides: (json['slides'] as List<dynamic>?)
          ?.map((slide) => Slide.fromJson(slide))
          .toList() ?? [],
      quizles: json['quizles'] ?? '',
      resources: (json['resources'] as List<dynamic>?)
          ?.map((resource) => Resource.fromJson(resource))
          .toList() ?? [],
      commonMistakes: (json['commonMistakes'] as List<dynamic>?)
          ?.map((mistake) => CommonMistake.fromJson(mistake))
          .toList() ?? [],
    );
  }
}

class Slide {
  final String slideId;
  final String type;
  final String title;
  final int order;
  final SlideContent content;

  const Slide({
    required this.slideId,
    required this.type,
    required this.title,
    required this.order,
    required this.content,
  });

  factory Slide.fromJson(Map<String, dynamic> json) {
    return Slide(
      slideId: json['slideId'] ?? '',
      type: json['type'] ?? '',
      title: json['title'] ?? '',
      order: json['order'] ?? 0,
      content: SlideContent.fromJson(json['content'] ?? {}),
    );
  }
}

class SlideContent {
  final String? text;
  final String? image;
  final VideoContent? video;
  final CodeSnippet? codeSnippet;
  final InteractiveContent? interactive;
  final List<Link>? links;
  final List<String>? notes;
  final List<String>? highlights;
  final List<UseCase>? useCases;
  final List<DataType>? dataTypes;
  final Analogy? analogy;
  final List<String>? summary;
  final List<String>? nextSteps;
  final String? encouragement;
  final List<String>? keyTakeaways;
  final String? nextLesson;
  final List<Rule>? rules;
  final List<String>? bestPractices;

  const SlideContent({
    this.text,
    this.image,
    this.video,
    this.codeSnippet,
    this.interactive,
    this.links,
    this.notes,
    this.highlights,
    this.useCases,
    this.dataTypes,
    this.analogy,
    this.summary,
    this.nextSteps,
    this.encouragement,
    this.keyTakeaways,
    this.nextLesson,
    this.rules,
    this.bestPractices,
  });

  factory SlideContent.fromJson(Map<String, dynamic> json) {
    return SlideContent(
      text: json['text'],
      image: json['image'],
      video: json['video'] != null ? VideoContent.fromJson(json['video']) : null,
      codeSnippet: json['codeSnippet'] != null ? CodeSnippet.fromJson(json['codeSnippet']) : null,
      interactive: json['interactive'] != null ? InteractiveContent.fromJson(json['interactive']) : null,
      links: (json['links'] as List<dynamic>?)?.map((link) => Link.fromJson(link)).toList(),
      notes: (json['notes'] as List<dynamic>?)?.cast<String>(),
      highlights: (json['highlights'] as List<dynamic>?)?.cast<String>(),
      useCases: (json['useCases'] as List<dynamic>?)?.map((useCase) => UseCase.fromJson(useCase)).toList(),
      dataTypes: (json['dataTypes'] as List<dynamic>?)?.map((dataType) => DataType.fromJson(dataType)).toList(),
      analogy: json['analogy'] != null ? Analogy.fromJson(json['analogy']) : null,
      summary: (json['summary'] as List<dynamic>?)?.cast<String>(),
      nextSteps: (json['nextSteps'] as List<dynamic>?)?.cast<String>(),
      encouragement: json['encouragement'],
      keyTakeaways: (json['keyTakeaways'] as List<dynamic>?)?.cast<String>(),
      nextLesson: json['nextLesson'],
      rules: (json['rules'] as List<dynamic>?)?.map((rule) => Rule.fromJson(rule)).toList(),
      bestPractices: (json['bestPractices'] as List<dynamic>?)?.cast<String>(),
    );
  }
}

class VideoContent {
  final String url;
  final String duration;
  final String? subtitles;

  const VideoContent({
    required this.url,
    required this.duration,
    this.subtitles,
  });

  factory VideoContent.fromJson(Map<String, dynamic> json) {
    return VideoContent(
      url: json['url'] ?? '',
      duration: json['duration'] ?? '',
      subtitles: json['subtitles'],
    );
  }
}

class CodeSnippet {
  final String code;
  final String language;
  final String explanation;
  final String output;
  final bool isExecutable;

  const CodeSnippet({
    required this.code,
    required this.language,
    required this.explanation,
    required this.output,
    required this.isExecutable,
  });

  factory CodeSnippet.fromJson(Map<String, dynamic> json) {
    return CodeSnippet(
      code: json['code'] ?? '',
      language: json['language'] ?? '',
      explanation: json['explanation'] ?? '',
      output: json['output'] ?? '',
      isExecutable: json['isExecutable'] ?? false,
    );
  }
}

class InteractiveContent {
  final String type;
  final String instruction;
  final String? template;
  final String? solution;
  final List<String> hints;

  const InteractiveContent({
    required this.type,
    required this.instruction,
    this.template,
    this.solution,
    required this.hints,
  });

  factory InteractiveContent.fromJson(Map<String, dynamic> json) {
    return InteractiveContent(
      type: json['type'] ?? '',
      instruction: json['instruction'] ?? '',
      template: json['template'],
      solution: json['solution'],
      hints: (json['hints'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }
}

class Link {
  final String title;
  final String url;
  final String type;

  const Link({
    required this.title,
    required this.url,
    required this.type,
  });

  factory Link.fromJson(Map<String, dynamic> json) {
    return Link(
      title: json['title'] ?? '',
      url: json['url'] ?? '',
      type: json['type'] ?? '',
    );
  }
}

class UseCase {
  final String title;
  final String description;
  final String icon;

  const UseCase({
    required this.title,
    required this.description,
    required this.icon,
  });

  factory UseCase.fromJson(Map<String, dynamic> json) {
    return UseCase(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      icon: json['icon'] ?? '',
    );
  }
}

class DataType {
  final String type;
  final String description;
  final String example;
  final String color;

  const DataType({
    required this.type,
    required this.description,
    required this.example,
    required this.color,
  });

  factory DataType.fromJson(Map<String, dynamic> json) {
    return DataType(
      type: json['type'] ?? '',
      description: json['description'] ?? '',
      example: json['example'] ?? '',
      color: json['color'] ?? '#000000',
    );
  }
}

class Analogy {
  final String title;
  final String description;

  const Analogy({
    required this.title,
    required this.description,
  });

  factory Analogy.fromJson(Map<String, dynamic> json) {
    return Analogy(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
    );
  }
}

class Rule {
  final String rule;
  final String valid;
  final String invalid;
  final String status;

  const Rule({
    required this.rule,
    required this.valid,
    required this.invalid,
    required this.status,
  });

  factory Rule.fromJson(Map<String, dynamic> json) {
    return Rule(
      rule: json['rule'] ?? '',
      valid: json['valid'] ?? '',
      invalid: json['invalid'] ?? '',
      status: json['status'] ?? '',
    );
  }
}

class Resource {
  final String title;
  final String url;
  final String type;

  const Resource({
    required this.title,
    required this.url,
    required this.type,
  });

  factory Resource.fromJson(Map<String, dynamic> json) {
    return Resource(
      title: json['title'] ?? '',
      url: json['url'] ?? '',
      type: json['type'] ?? '',
    );
  }
}

class CommonMistake {
  final String mistake;
  final String correction;
  final String example;

  const CommonMistake({
    required this.mistake,
    required this.correction,
    required this.example,
  });

  factory CommonMistake.fromJson(Map<String, dynamic> json) {
    return CommonMistake(
      mistake: json['mistake'] ?? '',
      correction: json['correction'] ?? '',
      example: json['example'] ?? '',
    );
  }
}
