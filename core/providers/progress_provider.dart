import 'package:flutter/material.dart';
import '../domain/entities/user_entity.dart';
import '../domain/usecases/complete_lesson_usecase.dart';
import '../domain/usecases/complete_quiz_usecase.dart';
import '../domain/usecases/get_user_progress_usecase.dart';
import '../data/repositories/progress_repository.dart';
import '../utils/progress_calculator.dart';

class ProgressProvider extends ChangeNotifier {
  final CompleteLessonUseCase _completeLessonUseCase;
  final CompleteQuizUseCase _completeQuizUseCase;
  final GetUserProgressUseCase _getUserProgressUseCase;
  final ProgressCalculator _progressCalculator;

  // State
  bool _isLoading = false;
  String? _error;
  UserEntity? _currentUser;
  Map<String, double> _languageProgressCache = {};

  ProgressProvider()
      : _completeLessonUseCase = CompleteLessonUseCase(ProgressRepository()),
        _completeQuizUseCase = CompleteQuizUseCase(ProgressRepository()),
        _getUserProgressUseCase = GetUserProgressUseCase(ProgressRepository()),
        _progressCalculator = ProgressCalculator() {
    _loadUserProgress();
  }

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  UserEntity? get currentUser => _currentUser;
  bool get hasUser => _currentUser != null;

  // User stats getters
  int get userLevel => _currentUser?.level ?? 1;
  int get userXP => _currentUser?.xp ?? 0;
  int get userCoins => _currentUser?.coins ?? 0;
  int get userStreak => _currentUser?.streak ?? 0;
  int get totalLessonsCompleted => _currentUser?.stats.totalLessonsCompleted ?? 0;
  int get totalQuizzesPassed => _currentUser?.stats.totalQuizzesPassed ?? 0;
  int get totalTimeSpent => _currentUser?.stats.totalTimeSpent ?? 0;
  double get averageQuizScore => _currentUser?.stats.averageQuizScore ?? 0.0;

  // Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Set error state
  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _setError(null);
  }

  // Load user progress
  Future<void> _loadUserProgress() async {
    try {
      _setLoading(true);
      _setError(null);

      _currentUser = await _getUserProgressUseCase.execute();
      _updateLanguageProgressCache();
      
      notifyListeners();
    } catch (e) {
      _setError('خطأ في تحميل تقدم المستخدم: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Update language progress cache
  void _updateLanguageProgressCache() {
    if (_currentUser == null) return;

    _languageProgressCache.clear();
    for (final entry in _currentUser!.progress.languages.entries) {
      final languageId = entry.key;
      final languageProgress = entry.value;
      
      final completedLessons = languageProgress.lessons.values
          .where((lesson) => lesson.isCompleted)
          .length;
      
      final totalLessons = languageProgress.lessons.length;
      final progress = totalLessons > 0 ? (completedLessons / totalLessons) * 100 : 0.0;
      
      _languageProgressCache[languageId] = progress;
    }
  }

  // Complete lesson
  Future<bool> completeLesson({
    required String languageId,
    required String lessonId,
    required int timeSpent,
    double? score,
  }) async {
    if (_currentUser == null) return false;

    try {
      _setLoading(true);
      _setError(null);

      final success = await _completeLessonUseCase.execute(
        userId: _currentUser!.id,
        languageId: languageId,
        lessonId: lessonId,
        timeSpent: timeSpent,
        score: score,
      );

      if (success) {
        // Reload user progress to get updated data
        await _loadUserProgress();
      }

      return success;
    } catch (e) {
      _setError('خطأ في إكمال الدرس: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Complete quiz
  Future<bool> completeQuiz({
    required String languageId,
    required String quizId,
    required QuizResultEntity quizResult,
  }) async {
    if (_currentUser == null) return false;

    try {
      _setLoading(true);
      _setError(null);

      final success = await _completeQuizUseCase.execute(
        userId: _currentUser!.id,
        languageId: languageId,
        quizId: quizId,
        quizResult: quizResult,
      );

      if (success) {
        // Reload user progress to get updated data
        await _loadUserProgress();
      }

      return success;
    } catch (e) {
      _setError('خطأ في إكمال الاختبار: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Get language progress
  double getLanguageProgress(String languageId) {
    return _languageProgressCache[languageId] ?? 0.0;
  }

  // Get language progress entity
  LanguageProgressEntity? getLanguageProgressEntity(String languageId) {
    return _currentUser?.progress.languages[languageId];
  }

  // Check if lesson is completed
  bool isLessonCompleted(String languageId, String lessonId) {
    final languageProgress = getLanguageProgressEntity(languageId);
    return languageProgress?.lessons[lessonId]?.isCompleted ?? false;
  }

  // Check if quiz is passed
  bool isQuizPassed(String languageId, String quizId) {
    final languageProgress = getLanguageProgressEntity(languageId);
    return languageProgress?.quizResults[quizId]?.passed ?? false;
  }

  // Get lesson attempts
  int getLessonAttempts(String languageId, String lessonId) {
    final languageProgress = getLanguageProgressEntity(languageId);
    return languageProgress?.lessons[lessonId]?.attempts ?? 0;
  }

  // Get lesson time spent
  int getLessonTimeSpent(String languageId, String lessonId) {
    final languageProgress = getLanguageProgressEntity(languageId);
    return languageProgress?.lessons[lessonId]?.timeSpent ?? 0;
  }

  // Get quiz result
  QuizResultEntity? getQuizResult(String languageId, String quizId) {
    final languageProgress = getLanguageProgressEntity(languageId);
    return languageProgress?.quizResults[quizId];
  }

  // Calculate XP for next level
  int getXPForNextLevel() {
    return _progressCalculator.calculateXPForNextLevel(userLevel);
  }

  // Calculate remaining XP for next level
  int getRemainingXPForNextLevel() {
    return _progressCalculator.calculateRemainingXPForNextLevel(userXP, userLevel);
  }

  // Calculate level progress percentage
  double getLevelProgressPercentage() {
    return _progressCalculator.calculateLevelProgress(userXP, userLevel);
  }

  // Get overall progress across all languages
  double getOverallProgress() {
    if (_languageProgressCache.isEmpty) return 0.0;

    final totalProgress = _languageProgressCache.values.fold(0.0, (sum, progress) => sum + progress);
    return totalProgress / _languageProgressCache.length;
  }

  // Get completed lessons count for language
  int getCompletedLessonsCount(String languageId) {
    final languageProgress = getLanguageProgressEntity(languageId);
    if (languageProgress == null) return 0;

    return languageProgress.lessons.values
        .where((lesson) => lesson.isCompleted)
        .length;
  }

  // Get passed quizzes count for language
  int getPassedQuizzesCount(String languageId) {
    final languageProgress = getLanguageProgressEntity(languageId);
    if (languageProgress == null) return 0;

    return languageProgress.quizResults.values
        .where((quiz) => quiz.passed)
        .length;
  }

  // Get language statistics
  Map<String, dynamic> getLanguageStatistics(String languageId) {
    final languageProgress = getLanguageProgressEntity(languageId);
    if (languageProgress == null) {
      return {
        'progress': 0.0,
        'completedLessons': 0,
        'passedQuizzes': 0,
        'timeSpent': 0,
        'isCompleted': false,
      };
    }

    final completedLessons = languageProgress.lessons.values
        .where((lesson) => lesson.isCompleted)
        .length;
    
    final passedQuizzes = languageProgress.quizResults.values
        .where((quiz) => quiz.passed)
        .length;
    
    final timeSpent = languageProgress.lessons.values
        .fold(0, (sum, lesson) => sum + lesson.timeSpent) +
        languageProgress.quizResults.values
        .fold(0, (sum, quiz) => sum + quiz.timeSpent);

    return {
      'languageId': languageId,
      'progress': getLanguageProgress(languageId),
      'completedLessons': completedLessons,
      'totalLessons': languageProgress.lessons.length,
      'passedQuizzes': passedQuizzes,
      'totalQuizzes': languageProgress.quizResults.length,
      'timeSpent': timeSpent,
      'isCompleted': languageProgress.isCompleted,
      'lastAccessed': languageProgress.lastAccessed,
    };
  }

  // Refresh progress data
  Future<void> refreshProgress() async {
    await _loadUserProgress();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
