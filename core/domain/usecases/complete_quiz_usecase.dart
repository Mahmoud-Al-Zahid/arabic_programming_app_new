import '../entities/user_entity.dart';
import '../repositories/progress_repository_interface.dart';

class CompleteQuizUseCase {
  final ProgressRepositoryInterface repository;

  CompleteQuizUseCase(this.repository);

  Future<bool> execute({
    required String userId,
    required String languageId,
    required String quizId,
    required QuizResultEntity quizResult,
  }) async {
    try {
      if (userId.isEmpty || languageId.isEmpty || quizId.isEmpty) {
        throw ArgumentError('User ID, Language ID, and Quiz ID cannot be empty');
      }

      if (quizResult.score < 0 || quizResult.score > 100) {
        throw ArgumentError('Quiz score must be between 0 and 100');
      }

      if (quizResult.timeSpent < 0) {
        throw ArgumentError('Time spent cannot be negative');
      }

      return await repository.completeQuiz(
        userId,
        languageId,
        quizId,
        quizResult,
      );
    } catch (e) {
      print('Error in CompleteQuizUseCase: $e');
      return false;
    }
  }
}
