import 'package:flutter/material.dart';
import '../domain/entities/course_entity.dart';
import '../domain/entities/language_entity.dart';
import '../domain/usecases/get_course_usecase.dart';
import '../domain/usecases/get_languages_usecase.dart';
import '../data/repositories/course_repository.dart';
import '../data/models/lesson_model.dart';
import '../data/models/quiz_model.dart';

class CourseProvider extends ChangeNotifier {
  final GetCourseUseCase _getCourseUseCase;
  final GetLanguagesUseCase _getLanguagesUseCase;
  final CourseRepository _courseRepository;

  // State
  bool _isLoading = false;
  String? _error;
  List<LanguageEntity> _languages = [];
  CourseEntity? _currentCourse;
  String _selectedLanguageId = '';
  Lesson? _currentLesson;
  Quiz? _currentQuiz;

  CourseProvider()
      : _courseRepository = CourseRepository(),
        _getCourseUseCase = GetCourseUseCase(CourseRepository()),
        _getLanguagesUseCase = GetLanguagesUseCase(CourseRepository()) {
    _loadLanguages();
  }

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<LanguageEntity> get languages => _languages;
  CourseEntity? get currentCourse => _currentCourse;
  String get selectedLanguageId => _selectedLanguageId;
  Lesson? get currentLesson => _currentLesson;
  Quiz? get currentQuiz => _currentQuiz;

  bool get hasSelectedLanguage => _selectedLanguageId.isNotEmpty;
  bool get hasCourse => _currentCourse != null;
  bool get hasCurrentLesson => _currentLesson != null;
  bool get hasCurrentQuiz => _currentQuiz != null;

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

  // Load languages
  Future<void> _loadLanguages() async {
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

  // Select language and load course
  Future<void> selectLanguage(String languageId) async {
    try {
      _setLoading(true);
      _setError(null);

      _selectedLanguageId = languageId;
      _currentCourse = await _getCourseUseCase.execute(languageId);
      
      // Clear current lesson and quiz when changing language
      _currentLesson = null;
      _currentQuiz = null;
      
      notifyListeners();
    } catch (e) {
      _setError('خطأ في تحميل الكورس: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Load specific lesson
  Future<void> loadLesson(String lessonId) async {
    if (_selectedLanguageId.isEmpty) {
      _setError('يجب اختيار لغة أولاً');
      return;
    }

    try {
      _setLoading(true);
      _setError(null);

      _currentLesson = await _courseRepository.getLesson(
        _selectedLanguageId,
        lessonId,
      );
      
      notifyListeners();
    } catch (e) {
      _setError('خطأ في تحميل الدرس: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Load lesson quiz
  Future<void> loadLessonQuiz(String lessonId) async {
    try {
      _setLoading(true);
      _setError(null);

      _currentQuiz = await _courseRepository.getLessonQuiz(lessonId);
      notifyListeners();
    } catch (e) {
      _setError('خطأ في تحميل الاختبار: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Load level quiz
  Future<void> loadLevelQuiz(String levelId) async {
    try {
      _setLoading(true);
      _setError(null);

      _currentQuiz = await _courseRepository.getLevelQuiz(levelId);
      notifyListeners();
    } catch (e) {
      _setError('خطأ في تحميل اختبار المستوى: $e');
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

  // Get level by ID
  LevelEntity? getLevelById(String levelId) {
    if (_currentCourse == null) return null;

    try {
      return _currentCourse!.levels.firstWhere((level) => level.levelId == levelId);
    } catch (e) {
      return null;
    }
  }

  // Get lesson by ID from current course
  LessonEntity? getLessonById(String lessonId) {
    if (_currentCourse == null) return null;

    for (final level in _currentCourse!.levels) {
      try {
        return level.lessons.firstWhere((lesson) => lesson.lessonId == lessonId);
      } catch (e) {
        continue;
      }
    }
    return null;
  }

  // Get lessons for specific level
  List<LessonEntity> getLessonsForLevel(String levelId) {
    final level = getLevelById(levelId);
    return level?.lessons ?? [];
  }

  // Get total lessons count
  int getTotalLessonsCount() {
    if (_currentCourse == null) return 0;

    return _currentCourse!.levels
        .map((level) => level.lessons.length)
        .fold(0, (sum, count) => sum + count);
  }

  // Get total levels count
  int getTotalLevelsCount() {
    return _currentCourse?.levels.length ?? 0;
  }

  // Search content
  Future<List<dynamic>> searchContent(String query) async {
    if (query.isEmpty || query.trim().length < 2) {
      return [];
    }

    try {
      return await _courseRepository.searchContent(
        query.trim(),
        languageId: _selectedLanguageId.isNotEmpty ? _selectedLanguageId : null,
      );
    } catch (e) {
      _setError('خطأ في البحث: $e');
      return [];
    }
  }

  // Refresh course data
  Future<void> refreshCourse() async {
    if (_selectedLanguageId.isNotEmpty) {
      await selectLanguage(_selectedLanguageId);
    }
  }

  // Clear current lesson
  void clearCurrentLesson() {
    _currentLesson = null;
    notifyListeners();
  }

  // Clear current quiz
  void clearCurrentQuiz() {
    _currentQuiz = null;
    notifyListeners();
  }

  // Get course progress statistics
  Map<String, dynamic> getCourseStatistics() {
    if (_currentCourse == null) {
      return {
        'totalLevels': 0,
        'totalLessons': 0,
        'estimatedHours': 0,
      };
    }

    return {
      'totalLevels': _currentCourse!.levels.length,
      'totalLessons': getTotalLessonsCount(),
      'estimatedHours': _currentCourse!.estimatedHours,
      'languageName': _currentCourse!.languageName,
    };
  }

  @override
  void dispose() {
    super.dispose();
  }
}
