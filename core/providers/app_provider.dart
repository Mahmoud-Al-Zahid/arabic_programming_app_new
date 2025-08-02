import 'package:flutter/material.dart';
import '../domain/entities/user_entity.dart';
import '../domain/entities/language_entity.dart';
import '../domain/entities/course_entity.dart';
import '../domain/usecases/get_languages_usecase.dart';
import '../domain/usecases/get_course_usecase.dart';
import '../domain/usecases/get_user_progress_usecase.dart';
import '../domain/usecases/create_user_usecase.dart';
import '../data/repositories/course_repository.dart';
import '../data/repositories/progress_repository.dart';
import '../services/cache_service.dart';

class AppProvider extends ChangeNotifier {
  // Use cases
  late final GetLanguagesUseCase _getLanguagesUseCase;
  late final GetCourseUseCase _getCourseUseCase;
  late final GetUserProgressUseCase _getUserProgressUseCase;
  late final CreateUserUseCase _createUserUseCase;

  // Services
  final CacheService _cacheService = CacheService();

  // State
  bool _isLoading = false;
  String? _error;
  UserEntity? _currentUser;
  List<LanguageEntity> _languages = [];
  CourseEntity? _currentCourse;
  String _selectedLanguageId = '';

  // Constructor
  AppProvider() {
    _initializeUseCases();
    _loadInitialData();
  }

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  UserEntity? get currentUser => _currentUser;
  List<LanguageEntity> get languages => _languages;
  CourseEntity? get currentCourse => _currentCourse;
  String get selectedLanguageId => _selectedLanguageId;
  bool get hasUser => _currentUser != null;
  bool get hasSelectedLanguage => _selectedLanguageId.isNotEmpty;

  // Initialize use cases
  void _initializeUseCases() {
    final courseRepository = CourseRepository();
    final progressRepository = ProgressRepository();

    _getLanguagesUseCase = GetLanguagesUseCase(courseRepository);
    _getCourseUseCase = GetCourseUseCase(courseRepository);
    _getUserProgressUseCase = GetUserProgressUseCase(progressRepository);
    _createUserUseCase = CreateUserUseCase(progressRepository);
  }

  // Load initial data
  Future<void> _loadInitialData() async {
    await loadUser();
    await loadLanguages();
  }

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

  // Load user data
  Future<void> loadUser() async {
    try {
      _setLoading(true);
      _setError(null);

      _currentUser = await _getUserProgressUseCase.execute();
      notifyListeners();
    } catch (e) {
      _setError('خطأ في تحميل بيانات المستخدم: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Create new user
  Future<bool> createUser({
    required String name,
    required String email,
  }) async {
    try {
      _setLoading(true);
      _setError(null);

      final user = await _createUserUseCase.execute(
        name: name,
        email: email,
      );

      if (user != null) {
        _currentUser = user;
        notifyListeners();
        return true;
      } else {
        _setError('فشل في إنشاء المستخدم');
        return false;
      }
    } catch (e) {
      _setError('خطأ في إنشاء المستخدم: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Load languages
  Future<void> loadLanguages({bool forceRefresh = false}) async {
    try {
      _setLoading(true);
      _setError(null);

      _languages = await _getLanguagesUseCase.execute();
      notifyListeners();
    } catch (e) {
      _setError('خطأ في تحميل اللغات: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Select language
  Future<void> selectLanguage(String languageId) async {
    try {
      _setLoading(true);
      _setError(null);

      _selectedLanguageId = languageId;
      
      // Load course for selected language
      _currentCourse = await _getCourseUseCase.execute(languageId);
      
      notifyListeners();
    } catch (e) {
      _setError('خطأ في تحديد اللغة: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Get language by ID
  LanguageEntity? getLanguageById(String languageId) {
    try {
      return _languages.firstWhere((lang) => lang.id == languageId);
    } catch (e) {
      return null;
    }
  }

  // Get user progress for language
  LanguageProgressEntity? getUserLanguageProgress(String languageId) {
    return _currentUser?.progress.languages[languageId];
  }

  // Check if lesson is accessible
  bool canAccessLesson(String languageId, String lessonId, int lessonOrder) {
    if (_currentUser == null) return lessonOrder == 1;

    final languageProgress = getUserLanguageProgress(languageId);
    if (languageProgress == null) return lessonOrder == 1;

    if (lessonOrder == 1) return true;

    final completedLessons = languageProgress.lessons.values
        .where((lesson) => lesson.isCompleted)
        .length;

    return completedLessons >= lessonOrder - 1;
  }

  // Get user level
  int getUserLevel() {
    return _currentUser?.level ?? 1;
  }

  // Get user XP
  int getUserXP() {
    return _currentUser?.xp ?? 0;
  }

  // Get user coins
  int getUserCoins() {
    return _currentUser?.coins ?? 0;
  }

  // Get user streak
  int getUserStreak() {
    return _currentUser?.streak ?? 0;
  }

  // Refresh all data
  Future<void> refreshData() async {
    await Future.wait([
      loadUser(),
      loadLanguages(forceRefresh: true),
    ]);

    if (_selectedLanguageId.isNotEmpty) {
      await selectLanguage(_selectedLanguageId);
    }
  }

  // Clear cache
  Future<void> clearCache() async {
    try {
      await _cacheService.clearAllCache();
      await refreshData();
    } catch (e) {
      _setError('خطأ في مسح الكاش: $e');
    }
  }

  // Update user preferences
  Future<void> updateUserPreferences(UserPreferencesEntity preferences) async {
    if (_currentUser == null) return;

    try {
      _setLoading(true);
      _setError(null);

      // Update user with new preferences
      final updatedUser = UserEntity(
        id: _currentUser!.id,
        name: _currentUser!.name,
        email: _currentUser!.email,
        avatar: _currentUser!.avatar,
        level: _currentUser!.level,
        xp: _currentUser!.xp,
        coins: _currentUser!.coins,
        streak: _currentUser!.streak,
        joinDate: _currentUser!.joinDate,
        progress: _currentUser!.progress,
        stats: _currentUser!.stats,
        achievements: _currentUser!.achievements,
        preferences: preferences,
      );

      _currentUser = updatedUser;
      notifyListeners();
    } catch (e) {
      _setError('خطأ في تحديث الإعدادات: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Get app statistics
  Map<String, dynamic> getAppStatistics() {
    if (_currentUser == null) {
      return {
        'totalLanguages': _languages.length,
        'userLevel': 0,
        'userXP': 0,
        'completedLessons': 0,
        'passedQuizzes': 0,
      };
    }

    return {
      'totalLanguages': _languages.length,
      'userLevel': _currentUser!.level,
      'userXP': _currentUser!.xp,
      'completedLessons': _currentUser!.stats.totalLessonsCompleted,
      'passedQuizzes': _currentUser!.stats.totalQuizzesPassed,
      'totalTimeSpent': _currentUser!.stats.totalTimeSpent,
      'averageScore': _currentUser!.stats.averageQuizScore,
      'longestStreak': _currentUser!.stats.longestStreak,
    };
  }

  @override
  void dispose() {
    super.dispose();
  }
}
