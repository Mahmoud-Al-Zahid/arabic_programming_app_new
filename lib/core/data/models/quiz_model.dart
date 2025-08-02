class Quiz {
  final String id;
  final String type;
  final String title;
  final int timeLimit;
  final int passingScore;
  final bool randomizeQuestions;
  final String showResults;
  final List<Question> questions;
  final QuizFeedback feedback;
  final LevelRequirements? levelRequirements;

  const Quiz({
    required this.id,
    required this.type,
    required this.title,
    required this.timeLimit,
    required this.passingScore,
    required this.randomizeQuestions,
    required this.showResults,
    required this.questions,
    required this.feedback,
    this.levelRequirements,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      title: json['title'] ?? '',
      timeLimit: json['timeLimit'] ?? 0,
      passingScore: json['passingScore'] ?? 0,
      randomizeQuestions: json['randomizeQuestions'] ?? false,
      showResults: json['showResults'] ?? '',
      questions: (json['questions'] as List<dynamic>?)
          ?.map((question) => Question.fromJson(question))
          .toList() ?? [],
      feedback: QuizFeedback.fromJson(json['feedback'] ?? {}),
      levelRequirements: json['levelRequirements'] != null 
          ? LevelRequirements.fromJson(json['levelRequirements']) 
          : null,
    );
  }
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
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      questionId: json['questionId'] ?? '',
      questionType: json['questionType'] ?? '',
      questionText: json['questionText'] ?? '',
      points: json['points'] ?? 0,
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
    );
  }
}

class QuestionOption {
  final String optionId;
  final String text;
  final bool isCorrect;

  const QuestionOption({
    required this.optionId,
    required this.text,
    required this.isCorrect,
  });

  factory QuestionOption.fromJson(Map<String, dynamic> json) {
    return QuestionOption(
      optionId: json['optionId'] ?? '',
      text: json['text'] ?? '',
      isCorrect: json['isCorrect'] ?? false,
    );
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
}
