import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/progress_repository.dart';
import '../domain/entities/user_entity.dart';
import '../domain/usecases/get_user_progress_usecase.dart';
import '../domain/usecases/complete_lesson_usecase.dart';
import '../domain/usecases/complete_quiz_usecase.dart';

// Progress Repository Provider
final progressRepositoryProvider = Provider<ProgressRepository>((ref) {
  return ProgressRepository();
});

// User Progress Use Case Provider
final getUserProgressUseCaseProvider = Provider<GetUserProgressUseCase>((ref) {
  final repository = ref.read(progressRepositoryProvider);
  return GetUserProgressUseCase(repository);
});

// Complete Lesson Use Case Provider
final completeLessonUseCaseProvider = Provider<CompleteLessonUseCase>((ref) {
  final repository = ref.read(progressRepositoryProvider);
  return CompleteLessonUseCase(repository);
});

// Complete Quiz Use Case Provider
final completeQuizUseCaseProvider = Provider<CompleteQuizUseCase>((ref) {
  final repository = ref.read(progressRepositoryProvider);
  return CompleteQuizUseCase(repository);
});

// Current User Provider
final currentUserProvider = FutureProvider<UserEntity?>((ref) async {
  final useCase = ref.read(getUserProgressUseCaseProvider);
  return await useCase.execute();
});

// User Progress Provider
final userProgressProvider = FutureProvider.family<UserProgressEntity?, String>((ref, userId) async {
  final useCase = ref.read(getUserProgressUseCaseProvider);
  return await useCase.getUserProgress(userId);
});

// Language Progress Provider
final languageProgressProvider = FutureProvider.family<LanguageProgressEntity?, Map<String, String>>((ref, params) async {
  final userId = params['userId']!;
  final languageId = params['languageId']!;
  
  final useCase = ref.read(getUserProgressUseCaseProvider);
  return await useCase.getLanguageProgress(userId: userId, languageId: languageId);
});

// User Stats Provider
final userStatsProvider = FutureProvider.family<UserStatsEntity?, String>((ref, userId) async {
  final useCase = ref.read(getUserProgressUseCaseProvider);
  return await useCase.getUserStats(userId);
});

// Overall Progress Provider
final overallProgressProvider = FutureProvider.family<double, String>((ref, userId) async {
  final useCase = ref.read(getUserProgressUseCaseProvider);
  return await useCase.getOverallProgress(userId);
});

// Level Progress Provider
final levelProgressProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, userId) async {
  final useCase = ref.read(getUserProgressUseCaseProvider);
  return await useCase.getLevelProgress(userId);
});

// Progress Summary Provider
final progressSummaryProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, userId) async {
  final useCase = ref.read(getUserProgressUseCaseProvider);
  return await useCase.getProgressSummary(userId);
});

// Recent Activity Provider
final recentActivityProvider = FutureProvider.family<List<Map<String, dynamic>>, Map<String, dynamic>>((ref, params) async {
  final userId = params['userId'] as String;
  final limit = params['limit'] as int? ?? 10;
  
  final useCase = ref.read(getUserProgressUseCaseProvider);
  return await useCase.getRecentActivity(userId, limit: limit);
});

// Streak Info Provider
final streakInfoProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, userId) async {
  final useCase = ref.read(getUserProgressUseCaseProvider);
  return await useCase.getStreakInfo(userId);
});

// Complete Lesson Provider
final completeLessonProvider = FutureProvider.family<bool, Map<String, dynamic>>((ref, params) async {
  final userId = params['userId'] as String;
  final languageId = params['languageId'] as String;
  final lessonId = params['lessonId'] as String;
  final timeSpent = params['timeSpent'] as int;
  final score = params['score'] as double?;
  
  final useCase = ref.read(completeLessonUseCaseProvider);
  return await useCase.execute(
    userId: userId,
    languageId: languageId,
    lessonId: lessonId,
    timeSpent: timeSpent,
    score: score,
  );
});

// Complete Quiz Provider
final completeQuizProvider = FutureProvider.family<bool, Map<String, dynamic>>((ref, params) async {
  final userId = params['userId'] as String;
  final languageId = params['languageId'] as String;
  final quizId = params['quizId'] as String;
  final quizResult = params['quizResult'] as QuizResultEntity;
  
  final useCase = ref.read(completeQuizUseCaseProvider);
  return await useCase.execute(
    userId: userId,
    languageId: languageId,
    quizId: quizId,
    quizResult: quizResult,
  );
});

// Can Access Lesson Provider
final canAccessLessonProvider = FutureProvider.family<bool, Map<String, dynamic>>((ref, params) async {
  final userId = params['userId'] as String;
  final languageId = params['languageId'] as String;
  final lessonId = params['lessonId'] as String;
  final lessonOrder = params['lessonOrder'] as int;
  
  final repository = ref.read(progressRepositoryProvider);
  return await repository.canAccessLesson(userId, languageId, lessonId, lessonOrder);
});

// Export User Data Provider
final exportUserDataProvider = FutureProvider.family<Map<String, dynamic>?, String>((ref, userId) async {
  final useCase = ref.read(getUserProgressUseCaseProvider);
  return await useCase.exportUserData(userId);
});
