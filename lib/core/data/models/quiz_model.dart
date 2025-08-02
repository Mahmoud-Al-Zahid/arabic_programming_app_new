class QuizQuestion {
  final String id;
  final String question;
  final List<String> options;
  final int correctAnswer;
  final String? explanation;
  final String? code;
  final String type; // multiple_choice, fill_blank, drag_drop

  const QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
    this.explanation,
    this.code,
    this.type = 'multiple_choice',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'options': options,
      'correctAnswer': correctAnswer,
      'explanation': explanation,
      'code': code,
      'type': type,
    };
  }

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      id: json['id'],
      question: json['question'],
      options: List<String>.from(json['options']),
      correctAnswer: json['correctAnswer'],
      explanation: json['explanation'],
      code: json['code'],
      type: json['type'] ?? 'multiple_choice',
    );
  }
}

class Quiz {
  final String id;
  final String lessonId;
  final String title;
  final List<QuizQuestion> questions;
  final int timeLimit; // in minutes

  const Quiz({
    required this.id,
    required this.lessonId,
    required this.title,
    required this.questions,
    this.timeLimit = 10,
  });

  // Legacy constructor for backward compatibility
  const Quiz.legacy({
    required this.id,
    required this.lessonId,
    required String question,
    required List<String> options,
    required int correctAnswer,
  }) : title = 'Quiz',
       questions = const [],
       timeLimit = 10;

  // Legacy getters for backward compatibility
  String get question => questions.isNotEmpty ? questions.first.question : '';
  List<String> get options => questions.isNotEmpty ? questions.first.options : [];
  int get correctAnswer => questions.isNotEmpty ? questions.first.correctAnswer : 0;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lessonId': lessonId,
      'title': title,
      'questions': questions.map((q) => q.toJson()).toList(),
      'timeLimit': timeLimit,
    };
  }

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'],
      lessonId: json['lessonId'],
      title: json['title'] ?? 'Quiz',
      questions: json['questions'] != null
          ? (json['questions'] as List).map((q) => QuizQuestion.fromJson(q)).toList()
          : [],
      timeLimit: json['timeLimit'] ?? 10,
    );
  }

  @override
  String toString() {
    return 'Quiz(id: $id, title: $title, questions: ${questions.length})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Quiz && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
