class Quiz {
  final String id;
  final String type;
  final String title;
  final String? description;
  final int timeLimit;
  final int passingScore;
  final bool randomizeQuestions;
  final String showResults;
  final List<Question> questions;
  final QuizFeedback feedback;
  final LevelRequirements? levelRequirements;
  final Map<String, dynamic> metadata;

  const Quiz({
    required this.id,
    required this.type,
    required this.title,
    this.description,
    required this.timeLimit,
    required this.passingScore,
    required this.randomizeQuestions,
    required this.showResults,
    required this.questions,
    required this.feedback,
    this.levelRequirements,
    this.metadata = const {},
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      timeLimit: json['timeLimit'] ?? 0,
      passingScore: json['passingScore'] ?? 70,
      randomizeQuestions: json['randomizeQuestions'] ?? false,
      showResults: json['showResults'] ?? 'immediate',
      questions: (json['questions'] as List<dynamic>?)
          ?.map((question) => Question.fromJson(question))
          .toList() ?? [],
      feedback: QuizFeedback.fromJson(json['feedback'] ?? {}),
      levelRequirements: json['levelRequirements'] != null 
          ? LevelRequirements.fromJson(json['levelRequirements']) 
          : null,
      metadata: json['metadata'] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'description': description,
      'timeLimit': timeLimit,
      'passingScore': passingScore,
      'randomizeQuestions': randomizeQuestions,
      'showResults': showResults,
      'questions': questions.map((q) => q.toJson()).toList(),
      'feedback': feedback.toJson(),
      'levelRequirements': levelRequirements?.toJson(),
      'metadata': metadata,
    };
  }

  Quiz copyWith({
    String? id,
    String? type,
    String? title,
    String? description,
    int? timeLimit,
    int? passingScore,
    bool? randomizeQuestions,
    String? showResults,
    List<Question>? questions,
    QuizFeedback? feedback,
    LevelRequirements? levelRequirements,
    Map<String, dynamic>? metadata,
  }) {
    return Quiz(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      timeLimit: timeLimit ?? this.timeLimit,
      passingScore: passingScore ?? this.passingScore,
      randomizeQuestions: randomizeQuestions ?? this.randomizeQuestions,
      showResults: showResults ?? this.showResults,
      questions: questions ?? this.questions,
      feedback: feedback ?? this.feedback,
      levelRequirements: levelRequirements ?? this.levelRequirements,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Quiz && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class Question {
  final String questionId;
  final String questionType;
  final String questionText;
  final int points;
  final String? codeSnippet;
  final String? image;
  final List<QuestionOption>? options;
  final dynamic correctAnswer;
  final String? explanation;
  final List<String>? hints;
  final List<String>? commonWrongAnswers;
  final List<DragItem>? dragItems;
  final List<DropZone>? dropZones;
  final List<Blank>? blanks;
  final String? expectedOutput;
  final String? sampleSolution;
  final String? template;
  final String? error;
  final String? correctCode;
  final String? codeExample;
  final List<LeftItem>? leftItems;
  final List<RightItem>? rightItems;
  final List<CorrectMatch>? correctMatches;
  final Map<String, dynamic> metadata;

  const Question({
    required this.questionId,
    required this.questionType,
    required this.questionText,
    required this.points,
    this.codeSnippet,
    this.image,
    this.options,
    this.correctAnswer,
    this.explanation,
    this.hints,
    this.commonWrongAnswers,
    this.dragItems,
    this.dropZones,
    this.blanks,
    this.expectedOutput,
    this.sampleSolution,
    this.template,
    this.error,
    this.correctCode,
    this.codeExample,
    this.leftItems,
    this.rightItems,
    this.correctMatches,
    this.metadata = const {},
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      questionId: json['questionId'] ?? '',
      questionType: json['questionType'] ?? '',
      questionText: json['questionText'] ?? '',
      points: json['points'] ?? 1,
      codeSnippet: json['codeSnippet'],
      image: json['image'],
      options: (json['options'] as List<dynamic>?)
          ?.map((option) => QuestionOption.fromJson(option))
          .toList(),
      correctAnswer: json['correctAnswer'],
      explanation: json['explanation'],
      hints: (json['hints'] as List<dynamic>?)?.cast<String>(),
      commonWrongAnswers: (json['commonWrongAnswers'] as List<dynamic>?)?.cast<String>(),
      dragItems: (json['dragItems'] as List<dynamic>?)
          ?.map((item) => DragItem.fromJson(item))
          .toList(),
      dropZones: (json['dropZones'] as List<dynamic>?)
          ?.map((zone) => DropZone.fromJson(zone))
          .toList(),
      blanks: (json['blanks'] as List<dynamic>?)
          ?.map((blank) => Blank.fromJson(blank))
          .toList(),
      expectedOutput: json['expectedOutput'],
      sampleSolution: json['sampleSolution'],
      template: json['template'],
      error: json['error'],
      correctCode: json['correctCode'],
      codeExample: json['codeExample'],
      leftItems: (json['leftItems'] as List<dynamic>?)
          ?.map((item) => LeftItem.fromJson(item))
          .toList(),
      rightItems: (json['rightItems'] as List<dynamic>?)
          ?.map((item) => RightItem.fromJson(item))
          .toList(),
      correctMatches: (json['correctMatches'] as List<dynamic>?)
          ?.map((match) => CorrectMatch.fromJson(match))
          .toList(),
      metadata: json['metadata'] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'questionType': questionType,
      'questionText': questionText,
      'points': points,
      'codeSnippet': codeSnippet,
      'image': image,
      'options': options?.map((o) => o.toJson()).toList(),
      'correctAnswer': correctAnswer,
      'explanation': explanation,
      'hints': hints,
      'commonWrongAnswers': commonWrongAnswers,
      'dragItems': dragItems?.map((d) => d.toJson()).toList(),
      'dropZones': dropZones?.map((d) => d.toJson()).toList(),
      'blanks': blanks?.map((b) => b.toJson()).toList(),
      'expectedOutput': expectedOutput,
      'sampleSolution': sampleSolution,
      'template': template,
      'error': error,
      'correctCode': correctCode,
      'codeExample': codeExample,
      'leftItems': leftItems?.map((l) => l.toJson()).toList(),
      'rightItems': rightItems?.map((r) => r.toJson()).toList(),
      'correctMatches': correctMatches?.map((c) => c.toJson()).toList(),
      'metadata': metadata,
    };
  }

  Question copyWith({
    String? questionId,
    String? questionType,
    String? questionText,
    int? points,
    String? codeSnippet,
    String? image,
    List<QuestionOption>? options,
    dynamic correctAnswer,
    String? explanation,
    List<String>? hints,
    List<String>? commonWrongAnswers,
    List<DragItem>? dragItems,
    List<DropZone>? dropZones,
    List<Blank>? blanks,
    String? expectedOutput,
    String? sampleSolution,
    String? template,
    String? error,
    String? correctCode,
    String? codeExample,
    List<LeftItem>? leftItems,
    List<RightItem>? rightItems,
    List<CorrectMatch>? correctMatches,
    Map<String, dynamic>? metadata,
  }) {
    return Question(
      questionId: questionId ?? this.questionId,
      questionType: questionType ?? this.questionType,
      questionText: questionText ?? this.questionText,
      points: points ?? this.points,
      codeSnippet: codeSnippet ?? this.codeSnippet,
      image: image ?? this.image,
      options: options ?? this.options,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      explanation: explanation ?? this.explanation,
      hints: hints ?? this.hints,
      commonWrongAnswers: commonWrongAnswers ?? this.commonWrongAnswers,
      dragItems: dragItems ?? this.dragItems,
      dropZones: dropZones ?? this.dropZones,
      blanks: blanks ?? this.blanks,
      expectedOutput: expectedOutput ?? this.expectedOutput,
      sampleSolution: sampleSolution ?? this.sampleSolution,
      template: template ?? this.template,
      error: error ?? this.error,
      correctCode: correctCode ?? this.correctCode,
      codeExample: codeExample ?? this.codeExample,
      leftItems: leftItems ?? this.leftItems,
      rightItems: rightItems ?? this.rightItems,
      correctMatches: correctMatches ?? this.correctMatches,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Question && other.questionId == questionId;
  }

  @override
  int get hashCode => questionId.hashCode;
}

class QuestionOption {
  final String optionId;
  final String text;
  final bool isCorrect;
  final String? explanation;

  const QuestionOption({
    required this.optionId,
    required this.text,
    required this.isCorrect,
    this.explanation,
  });

  factory QuestionOption.fromJson(Map<String, dynamic> json) {
    return QuestionOption(
      optionId: json['optionId'] ?? '',
      text: json['text'] ?? '',
      isCorrect: json['isCorrect'] ?? false,
      explanation: json['explanation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'optionId': optionId,
      'text': text,
      'isCorrect': isCorrect,
      'explanation': explanation,
    };
  }
}

class DragItem {
  final String id;
  final String text;
  final String correctZone;

  const DragItem({
    required this.id,
    required this.text,
    required this.correctZone,
  });

  factory DragItem.fromJson(Map<String, dynamic> json) {
    return DragItem(
      id: json['id'] ?? '',
      text: json['text'] ?? '',
      correctZone: json['correctZone'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'correctZone': correctZone,
    };
  }
}

class DropZone {
  final String id;
  final String label;

  const DropZone({
    required this.id,
    required this.label,
  });

  factory DropZone.fromJson(Map<String, dynamic> json) {
    return DropZone(
      id: json['id'] ?? '',
      label: json['label'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
    };
  }
}

class Blank {
  final int position;
  final String correctAnswer;
  final String type;

  const Blank({
    required this.position,
    required this.correctAnswer,
    required this.type,
  });

  factory Blank.fromJson(Map<String, dynamic> json) {
    return Blank(
      position: json['position'] ?? 0,
      correctAnswer: json['correctAnswer'] ?? '',
      type: json['type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'position': position,
      'correctAnswer': correctAnswer,
      'type': type,
    };
  }
}

class LeftItem {
  final String id;
  final String text;

  const LeftItem({
    required this.id,
    required this.text,
  });

  factory LeftItem.fromJson(Map<String, dynamic> json) {
    return LeftItem(
      id: json['id'] ?? '',
      text: json['text'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
    };
  }
}

class RightItem {
  final String id;
  final String text;

  const RightItem({
    required this.id,
    required this.text,
  });

  factory RightItem.fromJson(Map<String, dynamic> json) {
    return RightItem(
      id: json['id'] ?? '',
      text: json['text'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
    };
  }
}

class CorrectMatch {
  final String left;
  final String right;

  const CorrectMatch({
    required this.left,
    required this.right,
  });

  factory CorrectMatch.fromJson(Map<String, dynamic> json) {
    return CorrectMatch(
      left: json['left'] ?? '',
      right: json['right'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'left': left,
      'right': right,
    };
  }
}

class QuizFeedback {
  final List<String> excellent;
  final List<String> good;
  final List<String> average;
  final List<String> needsImprovement;

  const QuizFeedback({
    required this.excellent,
    required this.good,
    required this.average,
    required this.needsImprovement,
  });

  factory QuizFeedback.fromJson(Map<String, dynamic> json) {
    return QuizFeedback(
      excellent: (json['excellent'] as List<dynamic>?)?.cast<String>() ?? [],
      good: (json['good'] as List<dynamic>?)?.cast<String>() ?? [],
      average: (json['average'] as List<dynamic>?)?.cast<String>() ?? [],
      needsImprovement: (json['needsImprovement'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'excellent': excellent,
      'good': good,
      'average': average,
      'needsImprovement': needsImprovement,
    };
  }
}

class LevelRequirements {
  final List<String> completedLessons;
  final int minimumScore;
  final bool unlockNextLevel;

  const LevelRequirements({
    required this.completedLessons,
    required this.minimumScore,
    required this.unlockNextLevel,
  });

  factory LevelRequirements.fromJson(Map<String, dynamic> json) {
    return LevelRequirements(
      completedLessons: (json['completedLessons'] as List<dynamic>?)?.cast<String>() ?? [],
      minimumScore: json['minimumScore'] ?? 0,
      unlockNextLevel: json['unlockNextLevel'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'completedLessons': completedLessons,
      'minimumScore': minimumScore,
      'unlockNextLevel': unlockNextLevel,
    };
  }
}
