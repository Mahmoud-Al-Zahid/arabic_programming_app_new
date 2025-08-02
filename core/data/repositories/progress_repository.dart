import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../datasources/cache_datasource.dart';
import '../models/user_model.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/progress_repository_interface.dart';
import '../../utils/progress_calculator.dart';

class ProgressRepository implements ProgressRepositoryInterface {
  final CacheDataSource _cacheDataSource;
  final ProgressCalculator _progressCalculator;
  final Uuid _uuid = const Uuid();

  // SharedPreferences keys
  static const String _currentUserKey = 'current_user';
  static const String _userProgressKey = 'user_progress_';

  ProgressRepository({
    CacheDataSource? cacheDataSource,
    ProgressCalculator? progressCalculator,
  })  : _cacheDataSource = cacheDataSource ?? CacheDataSource(),
        _progressCalculator = progressCalculator ?? ProgressCalculator();

  @override
  Future<UserEntity?> getCurrentUser() async {
    try {
      // Try to get from cache first
      final cachedUser = await _cacheDataSource.getCachedUserProgress();
      if (cachedUser != null) {
        return _mapUserToEntity(cachedUser);
      }

      // Get from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_currentUserKey);
      
      if (userJson == null) return null;

      final userData = jsonDecode(userJson) as Map<String, dynamic>;
      final user = User.fromJson(userData);
      
      // Cache the user data
      await _cacheDataSource.cacheUserProgress(user);
      
      return _mapUserToEntity(user);
    } catch (e) {
      print('Error in ProgressRepository.getCurrentUser: $e');
      return null;
    }
  }

  @override
  Future<UserEntity?> createUser(String name, String email) async {
    try {
      final userId = _uuid.v4();
      final now = DateTime.now();

      final user = User(
        id: userId,
        name: name,
        email: email,
        avatar: 'default_avatar.png',
        level: 1,
        xp: 0,
        coins: 100, // Starting coins
        streak: 0,
        joinDate: now,
        progress: UserProgress(
          currentLanguage: '',
          languages: {},
        ),
        stats: UserStats(
          totalLessonsCompleted: 0,
          totalQuizzesPassed: 0,
          totalTimeSpent: 0,
          averageQuizScore: 0.0,
          longestStreak: 0,
        ),
        achievements: [],
        preferences: UserPreferences(
          language: 'ar',
          theme: 'light',
          soundEnabled: true,
          notificationsEnabled: true,
          dailyGoalMinutes: 30,
        ),
      );

      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_currentUserKey, jsonEncode(user.toJson()));

      // Cache the user data
      await _cacheDataSource.cacheUserProgress(user);

      return _mapUserToEntity(user);
    } catch (e) {
      print('Error in ProgressRepository.createUser: $e');
      return null;
    }
  }

  @override
  Future<bool> completeLesson(
    String userId,
    String languageId,
    String lessonId,
    int timeSpent, {
    double? score,
  }) async {
    try {
      final user = await _getCurrentUserModel();
      if (user == null || user.id != userId) return false;

      // Get or create language progress
      final languageProgress = user.progress.languages[languageId] ?? 
          LanguageProgress(
            languageId: languageId,
            isCompleted: false,
            lastAccessed: DateTime.now(),
            lessons: {},
            quizResults: {},
          );

      // Update lesson progress
      final existingLesson = languageProgress.lessons[lessonId];
      final isFirstTime = existingLesson == null || !existingLesson.isCompleted;

      final lessonProgress = LessonProgress(
        lessonId: lessonId,
        isCompleted: true,
        completedAt: DateTime.now(),
        timeSpent: (existingLesson?.timeSpent ?? 0) + timeSpent,
        attempts: (existingLesson?.attempts ?? 0) + 1,
        score: score,
      );

      languageProgress.lessons[lessonId] = lessonProgress;
      languageProgress.lastAccessed = DateTime.now();

      // Calculate XP and coins rewards
      final xpReward = _progressCalculator.calculateLessonXP(
        isFirstTime: isFirstTime,
        currentStreak: user.streak,
        score: score,
      );

      final coinsReward = _progressCalculator.calculateLessonCoins(
        isFirstTime: isFirstTime,
        currentStreak: user.streak,
      );

      // Update user stats
      final updatedUser = user.copyWith(
        xp: user.xp + xpReward,
        coins: user.coins + coinsReward,
        level: _progressCalculator.calculateLevelFromXP(user.xp + xpReward),
        progress: user.progress.copyWith(
          currentLanguage: languageId,
          languages: {...user.progress.languages, languageId: languageProgress},
        ),
        stats: user.stats.copyWith(
          totalLessonsCompleted: user.stats.totalLessonsCompleted + (isFirstTime ? 1 : 0),
          totalTimeSpent: user.stats.totalTimeSpent + timeSpent,
        ),
      );

      // Save updated user
      await _saveUser(updatedUser);

      return true;
    } catch (e) {
      print('Error in ProgressRepository.completeLesson: $e');
      return false;
    }
  }

  @override
  Future<bool> completeQuiz(
    String userId,
    String languageId,
    String quizId,
    QuizResultEntity quizResult,
  ) async {
    try {
      final user = await _getCurrentUserModel();
      if (user == null || user.id != userId) return false;

      // Get or create language progress
      final languageProgress = user.progress.languages[languageId] ?? 
          LanguageProgress(
            languageId: languageId,
            isCompleted: false,
            lastAccessed: DateTime.now(),
            lessons: {},
            quizResults: {},
          );

      // Update quiz result
      final existingQuiz = languageProgress.quizResults[quizId];
      final isFirstTime = existingQuiz == null || !existingQuiz.passed;

      final quizResultModel = QuizResult(
        quizId: quizId,
        score: quizResult.score,
        passed: quizResult.passed,
        completedAt: DateTime.now(),
        timeSpent: quizResult.timeSpent,
        attempts: (existingQuiz?.attempts ?? 0) + 1,
        answers: quizResult.answers,
      );

      languageProgress.quizResults[quizId] = quizResultModel;
      languageProgress.lastAccessed = DateTime.now();

      // Calculate XP and coins rewards
      final xpReward = _progressCalculator.calculateQuizXP(
        score: quizResult.score,
        isFirstTime: isFirstTime,
        currentStreak: user.streak,
      );

      final coinsReward = _progressCalculator.calculateQuizCoins(
        score: quizResult.score,
        isFirstTime: isFirstTime,
        currentStreak: user.streak,
      );

      // Update user stats
      final newAverageScore = _calculateNewAverageScore(
        user.stats.averageQuizScore,
        user.stats.totalQuizzesPassed,
        quizResult.score,
        isFirstTime && quizResult.passed,
      );

      final updatedUser = user.copyWith(
        xp: user.xp + xpReward,
        coins: user.coins + coinsReward,
        level: _progressCalculator.calculateLevelFromXP(user.xp + xpReward),
        progress: user.progress.copyWith(
          currentLanguage: languageId,
          languages: {...user.progress.languages, languageId: languageProgress},
        ),
        stats: user.stats.copyWith(
          totalQuizzesPassed: user.stats.totalQuizzesPassed + (isFirstTime && quizResult.passed ? 1 : 0),
          totalTimeSpent: user.stats.totalTimeSpent + quizResult.timeSpent,
          averageQuizScore: newAverageScore,
        ),
      );

      // Save updated user
      await _saveUser(updatedUser);

      return true;
    } catch (e) {
      print('Error in ProgressRepository.completeQuiz: $e');
      return false;
    }
  }

  @override
  Future<bool> canAccessLesson(
    String userId,
    String languageId,
    String lessonId,
    int lessonOrder,
  ) async {
    try {
      final user = await _getCurrentUserModel();
      if (user == null || user.id != userId) return lessonOrder == 1;

      final languageProgress = user.progress.languages[languageId];
      if (languageProgress == null) return lessonOrder == 1;

      // First lesson is always accessible
      if (lessonOrder == 1) return true;

      // Check if previous lessons are completed
      final completedLessons = languageProgress.lessons.values
          .where((lesson) => lesson.isCompleted)
          .length;

      return completedLessons >= lessonOrder - 1;
    } catch (e) {
      print('Error in ProgressRepository.canAccessLesson: $e');
      return lessonOrder == 1;
    }
  }

  // Additional methods
  Future<User?> _getCurrentUserModel() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_currentUserKey);
      
      if (userJson == null) return null;

      final userData = jsonDecode(userJson) as Map<String, dynamic>;
      return User.fromJson(userData);
    } catch (e) {
      print('Error getting current user model: $e');
      return null;
    }
  }

  Future<void> _saveUser(User user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_currentUserKey, jsonEncode(user.toJson()));
      
      // Update cache
      await _cacheDataSource.cacheUserProgress(user);
    } catch (e) {
      print('Error saving user: $e');
    }
  }

  double _calculateNewAverageScore(
    double currentAverage,
    int totalQuizzes,
    double newScore,
    bool countAsNew,
  ) {
    if (!countAsNew) return currentAverage;
    if (totalQuizzes == 0) return newScore;
    
    return ((currentAverage * totalQuizzes) + newScore) / (totalQuizzes + 1);
  }

  Future<void> clearAllData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_currentUserKey);
      await _cacheDataSource.clearAllCache();
    } catch (e) {
      print('Error clearing all data: $e');
    }
  }

  // Mapping method
  UserEntity _mapUserToEntity(User user) {
    return UserEntity(
      id: user.id,
      name: user.name,
      email: user.email,
      avatar: user.avatar,
      level: user.level,
      xp: user.xp,
      coins: user.coins,
      streak: user.streak,
      joinDate: user.joinDate,
      progress: _mapProgressToEntity(user.progress),
      stats: _mapStatsToEntity(user.stats),
      achievements: user.achievements,
      preferences: _mapPreferencesToEntity(user.preferences),
    );
  }

  UserProgressEntity _mapProgressToEntity(UserProgress progress) {
    return UserProgressEntity(
      currentLanguage: progress.currentLanguage,
      languages: progress.languages.map(
        (key, value) => MapEntry(key, _mapLanguageProgressToEntity(value)),
      ),
    );
  }

  LanguageProgressEntity _mapLanguageProgressToEntity(LanguageProgress progress) {
    return LanguageProgressEntity(
      languageId: progress.languageId,
      isCompleted: progress.isCompleted,
      lastAccessed: progress.lastAccessed,
      lessons: progress.lessons.map(
        (key, value) => MapEntry(key, _mapLessonProgressToEntity(value)),
      ),
      quizResults: progress.quizResults.map(
        (key, value) => MapEntry(key, _mapQuizResultToEntity(value)),
      ),
    );
  }

  LessonProgressEntity _mapLessonProgressToEntity(LessonProgress progress) {
    return LessonProgressEntity(
      lessonId: progress.lessonId,
      isCompleted: progress.isCompleted,
      completedAt: progress.completedAt,
      timeSpent: progress.timeSpent,
      attempts: progress.attempts,
      score: progress.score,
    );
  }

  QuizResultEntity _mapQuizResultToEntity(QuizResult result) {
    return QuizResultEntity(
      quizId: result.quizId,
      score: result.score,
      passed: result.passed,
      completedAt: result.completedAt,
      timeSpent: result.timeSpent,
      attempts: result.attempts,
      answers: result.answers,
    );
  }

  UserStatsEntity _mapStatsToEntity(UserStats stats) {
    return UserStatsEntity(
      totalLessonsCompleted: stats.totalLessonsCompleted,
      totalQuizzesPassed: stats.totalQuizzesPassed,
      totalTimeSpent: stats.totalTimeSpent,
      averageQuizScore: stats.averageQuizScore,
      longestStreak: stats.longestStreak,
    );
  }

  UserPreferencesEntity _mapPreferencesToEntity(UserPreferences preferences) {
    return UserPreferencesEntity(
      language: preferences.language,
      theme: preferences.theme,
      soundEnabled: preferences.soundEnabled,
      notificationsEnabled: preferences.notificationsEnabled,
      dailyGoalMinutes: preferences.dailyGoalMinutes,
    );
  }
}
