class Quiz {
  final String id;
  final String lessonId;
  final String question;
  final List<String> options;
  final int correctAnswer;

  const Quiz({
    required this.id,
    required this.lessonId,
    required this.question,
    required this.options,
    required this.correctAnswer,
  });
}

class QuizResult {
  final int score;
  final int total;
  final double percentage;
  final Map<int, dynamic> answers;

  const QuizResult({
    required this.score,
    required this.total,
    required this.percentage,
    required this.answers,
  });
}
