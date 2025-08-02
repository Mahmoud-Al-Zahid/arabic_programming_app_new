import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/user_model.dart';

class ProgressService {
  static final ProgressService _instance = ProgressService._internal();
  factory ProgressService() => _instance;
  ProgressService._internal();

  static const String _userProgressKey = 'user_progress';
  static const String _userDataKey = 'user_data';

  // Save user progress
  Future<void> saveUserProgress(UserProgress progress) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(progress.toJson());
    await prefs.setString(_userProgressKey, jsonString);
  }

  // Load user progress
  Future<UserProgress?> loadUserProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_userProgressKey);
    
    if (jsonString != null) {
      final jsonMap = json.decode(jsonString);
      return UserProgress.fromJson(jsonMap);
    }
    
    return null;
  }

  // Save user data
  Future<void> saveUserData(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(user.toJson());
    await prefs.setString(_userDataKey, jsonString);
  }

  // Load user data
  Future<User?> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_userDataKey);
    
    if (jsonString != null) {
      final jsonMap = json.decode(jsonString);
      return User.fromJson(jsonMap);
    }
    
    return null;
  }

  // Update lesson progress
  Future<void> updateLessonProgress(String languageId, String lessonId, bool completed) async {
    final progress = await loadUserProgress();
    if (progress != null) {
      final languageProgress = progress.languages[languageId];
      if (languageProgress != null) {
        final updatedLessonProgress = LessonProgress(
          lessonId: lessonId,
          isUnlocked: true,
          isCompleted: completed,
          completedDate: completed ? DateTime.now() : null,
          timeSpent: languageProgress.lessons[lessonId]?.timeSpent ?? 0,
          attempts: (languageProgress.lessons[lessonId]?.attempts ?? 0) + 1,
        );

        final updatedLessons = Map<String, LessonProgress>.from(languageProgress.lessons);
        updatedLessons[lessonId] = updatedLessonProgress;

        final updatedLanguageProgress = LanguageProgress(
          languageId: languageId,
          overallProgress: _calculateOverallProgress(updatedLessons),
          levels: languageProgress.levels,
          lessons: updatedLessons,
          quizResults: languageProgress.quizResults,
          isCompleted: languageProgress.isCompleted,
          completedDate: languageProgress.completedDate,
        );

        final updatedLanguages = Map<String, LanguageProgress>.from(progress.languages);
        updatedLanguages[languageId] = updatedLanguageProgress;

        final updatedProgress = UserProgress(
          languages: updatedLanguages,
          currentLanguage: progress.currentLanguage,
          currentLevel: progress.currentLevel,
          currentLesson: completed ? _getNextLesson(lessonId) : lessonId,
        );

        await saveUserProgress(updatedProgress);
      }
    }
  }

  // Update quiz result
  Future<void> updateQuizResult(String languageId, String quizId, QuizResult result) async {
    final progress = await loadUserProgress();
    if (progress != null) {
      final languageProgress = progress.languages[languageId];
      if (languageProgress != null) {
        final updatedQuizResults = Map<String, QuizResult>.from(languageProgress.quizResults);
        updatedQuizResults[quizId] = result;

        final updatedLanguageProgress = LanguageProgress(
          languageId: languageId,
          overallProgress: languageProgress.overallProgress,
          levels: languageProgress.levels,
          lessons: languageProgress.lessons,
          quizResults: updatedQuizResults,
          isCompleted: languageProgress.isCompleted,
          completedDate: languageProgress.completedDate,
        );

        final updatedLanguages = Map<String, LanguageProgress>.from(progress.languages);
        updatedLanguages[languageId] = updatedLanguageProgress;

        final updatedProgress = UserProgress(
          languages: updatedLanguages,
          currentLanguage: progress.currentLanguage,
          currentLevel: progress.currentLevel,
          currentLesson: progress.currentLesson,
        );

        await saveUserProgress(updatedProgress);
      }
    }
  }

  // Check if lesson is unlocked
  Future<bool> isLessonUnlocked(String languageId, String lessonId) async {
    final progress = await loadUserProgress();
    if (progress != null) {
      final languageProgress = progress.languages[languageId];
      if (languageProgress != null) {
        final lessonProgress = languageProgress.lessons[lessonId];
        return lessonProgress?.isUnlocked ?? false;
      }
    }
    return false;
  }

  // Check if level is unlocked
  Future<bool> isLevelUnlocked(String languageId, String levelId) async {
    final progress = await loadUserProgress();
    if (progress != null) {
      final languageProgress = progress.languages[languageId];
      if (languageProgress != null) {
        final levelProgress = languageProgress.levels[levelId];
        return levelProgress?.isUnlocked ?? false;
      }
    }
    return false;
  }

  // Initialize user progress for new language
  Future<void> initializeLanguageProgress(String languageId) async {
    final progress = await loadUserProgress() ?? UserProgress(
      languages: {},
      currentLanguage: languageId,
      currentLevel: '',
      currentLesson: '',
    );

    if (!progress.languages.containsKey(languageId)) {
      final newLanguageProgress = LanguageProgress(
        languageId: languageId,
        overallProgress: 0.0,
        levels: {},
        lessons: {},
        quizResults: {},
        isCompleted: false,
      );

      final updatedLanguages = Map<String, LanguageProgress>.from(progress.languages);
      updatedLanguages[languageId] = newLanguageProgress;

      final updatedProgress = UserProgress(
        languages: updatedLanguages,
        currentLanguage: languageId,
        currentLevel: progress.currentLevel,
        currentLesson: progress.currentLesson,
      );

      await saveUserProgress(updatedProgress);
    }
  }

  // Helper methods
  double _calculateOverallProgress(Map<String, LessonProgress> lessons) {
    if (lessons.isEmpty) return 0.0;
    
    final completedLessons = lessons.values.where((lesson) => lesson.isCompleted).length;
    return (completedLessons / lessons.length) * 100;
  }

  String _getNextLesson(String currentLessonId) {
    // This would need to be implemented based on the course structure
    // For now, return the current lesson
    return currentLessonId;
  }

  // Clear all progress (for testing or reset)
  Future<void> clearAllProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userProgressKey);
    await prefs.remove(_userDataKey);
  }
}
