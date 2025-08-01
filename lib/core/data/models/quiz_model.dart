class QuizModel {
  final String id;
  final String title;
  final String lessonId;
  final List<QuestionModel> questions;

  const QuizModel({
    required this.id,
    required this.title,
    required this.lessonId,
    required this.questions,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      id: json['id'] as String,
      title: json['title'] as String,
      lessonId: json['lessonId'] as String,
      questions: (json['questions'] as List)
          .map((q) => QuestionModel.fromJson(q as Map<String, dynamic>))
          .toList(),
    );
  }
}

class QuestionModel {
  final String id;
  final String type;
  final String question;
  final List<String>? options;
  final dynamic correctAnswer;
  final String? code;
  final List<String>? codeBlocks;
  final List<int>? correctOrder;

  const QuestionModel({
    required this.id,
    required this.type,
    required this.question,
    this.options,
    required this.correctAnswer,
    this.code,
    this.codeBlocks,
    this.correctOrder,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'] as String,
      type: json['type'] as String,
      question: json['question'] as String,
      options: (json['options'] as List<dynamic>?)?.cast<String>(),
      correctAnswer: json['correctAnswer'],
      code: json['code'] as String?,
      codeBlocks: (json['codeBlocks'] as List<dynamic>?)?.cast<String>(),
      correctOrder: (json['correctOrder'] as List<dynamic>?)?.cast<int>(),
    );
  }
}
