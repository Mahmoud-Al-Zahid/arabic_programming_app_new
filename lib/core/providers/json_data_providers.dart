import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/json_data_service.dart';
import '../services/progress_service.dart';
import '../data/models/language_model.dart';
import '../data/models/course_model.dart';
import '../data/models/lesson_model.dart';
import '../data/models/quiz_model.dart';
import '../data/models/user_model.dart';

// Service Providers
final jsonDataServiceProvider = Provider<JsonDataService>((ref) {
  return JsonDataService();
});

final progressServiceProvider = Provider<ProgressService>((ref) {
  return ProgressService();
});

// Languages Provider
final languagesProvider = FutureProvider<List<Language>>((ref) async {
  final service = ref.read(jsonDataServiceProvider);
  return await service.getLanguages();
});

// Course Provider
final courseProvider = FutureProvider.family<Course?, String>((ref, languageId) async {
  final service = ref.read(jsonDataServiceProvider);
  return await service.getCourse(languageId);
});

// Lesson Provider
final lessonProvider = FutureProvider.family<Lesson?, LessonParams>((ref, params) async {
  final service = ref.read(jsonDataServiceProvider);
  return await service.getLesson(params.languageId, params.lessonId);
});

// Quiz Providers
final lessonQuizProvider = FutureProvider.family<Quiz?, String>((ref, quizId) async {
  final service = ref.read(jsonDataServiceProvider);
  return await service.getLessonQuiz(quizId);
});

final levelQuizProvider = FutureProvider.family<Quiz?, String>((ref, quizId) async {
  final service = ref.read(jsonDataServiceProvider);
  return await service.getLevelQuiz(quizId);
});

// User Progress Provider
final userProgressProvider = FutureProvider<UserProgress?>((ref) async {
  final service = ref.read(progressServiceProvider);
  return await service.loadUserProgress();
});

// User Data Provider
final userDataProvider = FutureProvider<User?>((ref) async {
  final service = ref.read(progressServiceProvider);
  return await service.loadUserData();
});

// Lesson Unlock Status Provider
final lessonUnlockProvider = FutureProvider.family<bool, LessonParams>((ref, params) async {
  final service = ref.read(progressServiceProvider);
  return await service.isLessonUnlocked(params.languageId, params.lessonId);
});

// Level Unlock Status Provider
final levelUnlockProvider = FutureProvider.family<bool, LevelParams>((ref, params) async {
  final service = ref.read(progressServiceProvider);
  return await service.isLevelUnlocked(params.languageId, params.levelId);
});

// Progress Update Notifier
final progressUpdateProvider = StateNotifierProvider<ProgressUpdateNotifier, AsyncValue<void>>((ref) {
  return ProgressUpdateNotifier(ref.read(progressServiceProvider));
});

class ProgressUpdateNotifier extends StateNotifier<AsyncValue<void>> {
  final ProgressService _progressService;

  ProgressUpdateNotifier(this._progressService) : super(const AsyncValue.data(null));

  Future<void> updateLessonProgress(String languageId, String lessonId, bool completed) async {
    state = const AsyncValue.loading();
    try {
      await _progressService.updateLessonProgress(languageId, lessonId, completed);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateQuizResult(String languageId, String quizId, QuizResult result) async {
    state = const AsyncValue.loading();
    try {
      await _progressService.updateQuizResult(languageId, quizId, result);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> initializeLanguageProgress(String languageId) async {
    state = const AsyncValue.loading();
    try {
      await _progressService.initializeLanguageProgress(languageId);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

// Parameter classes for family providers
class LessonParams {
  final String languageId;
  final String lessonId;

  const LessonParams({
    required this.languageId,
    required this.lessonId,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LessonParams &&
          runtimeType == other.runtimeType &&
          languageId == other.languageId &&
          lessonId == other.lessonId;

  @override
  int get hashCode => languageId.hashCode ^ lessonId.hashCode;
}

class LevelParams {
  final String languageId;
  final String levelId;

  const LevelParams({
    required this.languageId,
    required this.levelId,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LevelParams &&
          runtimeType == other.runtimeType &&
          languageId == other.languageId &&
          levelId == other.levelId;

  @override
  int get hashCode => languageId.hashCode ^ levelId.hashCode;
}
