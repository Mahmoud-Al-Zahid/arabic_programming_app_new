import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/user_model.dart';

class ProgressService {
  static final ProgressService _instance = ProgressService._internal();
  factory ProgressService() => _instance;
  ProgressService._internal();

  static const String _userProgressKey = 'user_progress';
  static const String _userDataKey = 'user_data';

  // حفظ تقدم المستخدم
  Future<void> saveUserProgress(User user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = json.encode(user.toJson());
      await prefs.setString(_userDataKey, userJson);
    } catch (e) {
      print('Error saving user progress: $e');
    }
  }

  // تحميل تقدم المستخدم
  Future<User?> loadUserProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userDataKey);
      
      if (userJson != null) {
        final userMap = json.decode(userJson);
        return User.fromJson(userMap);
      }
      
      return null;
    } catch (e) {
      print('Error loading user progress: $e');
      return null;
    }
  }

  // إنشاء مستخدم جديد
  Future<User> createNewUser(String name, String email) async {
    final user = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
      avatar: 'assets/images/avatars/default_avatar.png',
      level: 1,
      xp: 0,
      coins: 100, // عملات ابتدائية
      streak: 0,
      joinDate: DateTime.now(),
      progress: const UserProgress(
        languages: {},
        currentLanguage: '',
        currentLevel: '',
        currentLesson: '',
      ),
      stats: const UserStats(
        totalLessonsCompleted: 0,
        totalQuizzesPassed: 0,
        totalTimeSpent: 0,
        longestStreak: 0,
        averageQuizScore: 0.0,
        languageStats: {},
      ),
      achievements: [],
    );

    await saveUserProgress(user);
    return user;
  }

  // تحديث تقدم اللغة
  Future<void> updateLanguageProgress(
    String userId,
    String languageId,
    LanguageProgress languageProgress,
  ) async {
    final user = await loadUserProgress();
    if (user != null) {
      final updatedLanguages = Map<String, LanguageProgress>.from(user.progress.languages);
      updatedLanguages[languageId] = languageProgress;

      final updatedProgress = UserProgress(
        languages: updatedLanguages,
        currentLanguage: user.progress.currentLanguage,
        currentLevel: user.progress.currentLevel,
        currentLesson: user.progress.currentLesson,
      );

      final updatedUser = User(
        id: user.id,
        name: user.name,
        email: user.email,
        avatar: user.avatar,
        level: user.level,
        xp: user.xp,
        coins: user.coins,
        streak: user.streak,
        joinDate: user.joinDate,
        progress: updatedProgress,
        stats: user.stats,
        achievements: user.achievements,
      );

      await saveUserProgress(updatedUser);
    }
  }

  // إكمال درس
  Future<void> completeLesson(
    String userId,
    String languageId,
    String lessonId,
    int timeSpent,
  ) async {
    final user = await loadUserProgress();
    if (user != null) {
      // تحديث تقدم الدرس
      final languageProgress = user.progress.languages[languageId] ?? LanguageProgress(
        languageId: languageId,
        overallProgress: 0.0,
        levels: {},
        lessons: {},
        quizResults: {},
        isCompleted: false,
      );

      final updatedLessons = Map<String, LessonProgress>.from(languageProgress.lessons);
      updatedLessons[lessonId] = LessonProgress(
        lessonId: lessonId,
        isUnlocked: true,
        isCompleted: true,
        completedDate: DateTime.now(),
        timeSpent: timeSpent,
        attempts: (updatedLessons[lessonId]?.attempts ?? 0) + 1,
      );

      final updatedLanguageProgress = LanguageProgress(
        languageId: languageProgress.languageId,
        overallProgress: languageProgress.overallProgress,
        levels: languageProgress.levels,
        lessons: updatedLessons,
        quizResults: languageProgress.quizResults,
        isCompleted: languageProgress.isCompleted,
        completedDate: languageProgress.completedDate,
      );

      await updateLanguageProgress(userId, languageId, updatedLanguageProgress);

      // تحديث الإحصائيات
      await _updateUserStats(userId, timeSpent: timeSpent, lessonsCompleted: 1);
    }
  }

  // إكمال اختبار
  Future<void> completeQuiz(
    String userId,
    String languageId,
    String quizId,
    QuizResult quizResult,
  ) async {
    final user = await loadUserProgress();
    if (user != null) {
      final languageProgress = user.progress.languages[languageId] ?? LanguageProgress(
        languageId: languageId,
        overallProgress: 0.0,
        levels: {},
        lessons: {},
        quizResults: {},
        isCompleted: false,
      );

      final updatedQuizResults = Map<String, QuizResult>.from(languageProgress.quizResults);
      updatedQuizResults[quizId] = quizResult;

      final updatedLanguageProgress = LanguageProgress(
        languageId: languageProgress.languageId,
        overallProgress: languageProgress.overallProgress,
        levels: languageProgress.levels,
        lessons: languageProgress.lessons,
        quizResults: updatedQuizResults,
        isCompleted: languageProgress.isCompleted,
        completedDate: languageProgress.completedDate,
      );

      await updateLanguageProgress(userId, languageId, updatedLanguageProgress);

      // تحديث الإحصائيات
      if (quizResult.passed) {
        await _updateUserStats(
          userId,
          quizzesPassed: 1,
          timeSpent: quizResult.timeSpent,
          quizScore: quizResult.percentage,
        );

        // إضافة XP والعملات
        await _addRewards(userId, quizResult.score * 10, quizResult.score * 2);
      }
    }
  }

  // تحديث إحصائيات المستخدم
  Future<void> _updateUserStats(
    String userId, {
    int timeSpent = 0,
    int lessonsCompleted = 0,
    int quizzesPassed = 0,
    double quizScore = 0.0,
  }) async {
    final user = await loadUserProgress();
    if (user != null) {
      final updatedStats = UserStats(
        totalLessonsCompleted: user.stats.totalLessonsCompleted + lessonsCompleted,
        totalQuizzesPassed: user.stats.totalQuizzesPassed + quizzesPassed,
        totalTimeSpent: user.stats.totalTimeSpent + timeSpent,
        longestStreak: user.stats.longestStreak,
        averageQuizScore: quizScore > 0 
            ? ((user.stats.averageQuizScore * user.stats.totalQuizzesPassed) + quizScore) / (user.stats.totalQuizzesPassed + 1)
            : user.stats.averageQuizScore,
        languageStats: user.stats.languageStats,
      );

      final updatedUser = User(
        id: user.id,
        name: user.name,
        email: user.email,
        avatar: user.avatar,
        level: user.level,
        xp: user.xp,
        coins: user.coins,
        streak: user.streak,
        joinDate: user.joinDate,
        progress: user.progress,
        stats: updatedStats,
        achievements: user.achievements,
      );

      await saveUserProgress(updatedUser);
    }
  }

  // إضافة مكافآت (XP وعملات)
  Future<void> _addRewards(String userId, int xp, int coins) async {
    final user = await loadUserProgress();
    if (user != null) {
      final newXp = user.xp + xp;
      final newLevel = (newXp / 1000).floor() + 1; // كل 1000 XP = مستوى جديد
      
      final updatedUser = User(
        id: user.id,
        name: user.name,
        email: user.email,
        avatar: user.avatar,
        level: newLevel,
        xp: newXp,
        coins: user.coins + coins,
        streak: user.streak,
        joinDate: user.joinDate,
        progress: user.progress,
        stats: user.stats,
        achievements: user.achievements,
      );

      await saveUserProgress(updatedUser);
    }
  }

  // التحقق من إمكانية الوصول للدرس
  bool canAccessLesson(User user, String languageId, String lessonId, int lessonOrder) {
    final languageProgress = user.progress.languages[languageId];
    if (languageProgress == null) return lessonOrder == 1;

    // الدرس الأول دائماً متاح
    if (lessonOrder == 1) return true;

    // التحقق من إكمال الدرس السابق
    final previousLessonCompleted = languageProgress.lessons.values
        .any((lesson) => lesson.isCompleted);

    return previousLessonCompleted;
  }

  // التحقق من إمكانية الوصول للمستوى
  bool canAccessLevel(User user, String languageId, String levelId, int levelOrder) {
    final languageProgress = user.progress.languages[languageId];
    if (languageProgress == null) return levelOrder == 1;

    // المستوى الأول دائماً متاح
    if (levelOrder == 1) return true;

    // التحقق من إكمال المستوى السابق
    final previousLevelCompleted = languageProgress.levels.values
        .any((level) => level.isCompleted);

    return previousLevelCompleted;
  }

  // مسح جميع البيانات
  Future<void> clearAllData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userDataKey);
      await prefs.remove(_userProgressKey);
    } catch (e) {
      print('Error clearing data: $e');
    }
  }
}
