class Quiz {
  final String id;
  final String lessonId;
  final String question;
  final List<String> options;
  final int correctAnswer;
  final String? explanation;
  final String type;
  final String? code;
  final List<String>? codeBlocks;
  final List<int>? correctOrder;

  const Quiz({
    required this.id,
    required this.lessonId,
    required this.question,
    required this.options,
    required this.correctAnswer,
    this.explanation,
    this.type = 'multiple_choice',
    this.code,
    this.codeBlocks,
    this.correctOrder,
  });

  Quiz copyWith({
    String? id,
    String? lessonId,
    String? question,
    List<String>? options,
    int? correctAnswer,
    String? explanation,
    String? type,
    String? code,
    List<String>? codeBlocks,
    List<int>? correctOrder,
  }) {
    return Quiz(
      id: id ?? this.id,
      lessonId: lessonId ?? this.lessonId,
      question: question ?? this.question,
      options: options ?? this.options,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      explanation: explanation ?? this.explanation,
      type: type ?? this.type,
      code: code ?? this.code,
      codeBlocks: codeBlocks ?? this.codeBlocks,
      correctOrder: correctOrder ?? this.correctOrder,
    );
  }
}
