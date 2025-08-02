import 'package:flutter/material.dart';
import '../data/models/lesson_model.dart';
import '../data/models/slide_model.dart';
import '../data/repositories/course_repository.dart';

class LessonProvider extends ChangeNotifier {
  final CourseRepository _courseRepository;

  // State
  bool _isLoading = false;
  String? _error;
  Lesson? _currentLesson;
  int _currentSlideIndex = 0;
  bool _isLessonCompleted = false;
  int _timeSpent = 0;
  DateTime? _lessonStartTime;

  LessonProvider() : _courseRepository = CourseRepository();

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  Lesson? get currentLesson => _currentLesson;
  int get currentSlideIndex => _currentSlideIndex;
  bool get isLessonCompleted => _isLessonCompleted;
  int get timeSpent => _timeSpent;

  bool get hasLesson => _currentLesson != null;
  bool get hasNextSlide => _currentLesson != null && _currentSlideIndex < _currentLesson!.slides.length - 1;
  bool get hasPreviousSlide => _currentSlideIndex > 0;
  bool get isFirstSlide => _currentSlideIndex == 0;
  bool get isLastSlide => _currentLesson != null && _currentSlideIndex == _currentLesson!.slides.length - 1;

  Slide? get currentSlide => _currentLesson?.slides[_currentSlideIndex];
  int get totalSlides => _currentLesson?.slides.length ?? 0;
  double get progress => totalSlides > 0 ? (_currentSlideIndex + 1) / totalSlides : 0.0;

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

  // Load lesson
  Future<void> loadLesson(String languageId, String lessonId) async {
    try {
      _setLoading(true);
      _setError(null);

      _currentLesson = await _courseRepository.getLesson(languageId, lessonId);
      _currentSlideIndex = 0;
      _isLessonCompleted = false;
      _timeSpent = 0;
      _lessonStartTime = DateTime.now();

      notifyListeners();
    } catch (e) {
      _setError('خطأ في تحميل الدرس: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Go to next slide
  void nextSlide() {
    if (hasNextSlide) {
      _currentSlideIndex++;
      notifyListeners();
    }
  }

  // Go to previous slide
  void previousSlide() {
    if (hasPreviousSlide) {
      _currentSlideIndex--;
      notifyListeners();
    }
  }

  // Go to specific slide
  void goToSlide(int index) {
    if (_currentLesson != null && index >= 0 && index < _currentLesson!.slides.length) {
      _currentSlideIndex = index;
      notifyListeners();
    }
  }

  // Complete lesson
  void completeLesson() {
    if (_currentLesson != null && !_isLessonCompleted) {
      _isLessonCompleted = true;
      _calculateTimeSpent();
      notifyListeners();
    }
  }

  // Calculate time spent
  void _calculateTimeSpent() {
    if (_lessonStartTime != null) {
      final endTime = DateTime.now();
      _timeSpent = endTime.difference(_lessonStartTime!).inSeconds;
    }
  }

  // Get current time spent (live)
  int getCurrentTimeSpent() {
    if (_lessonStartTime != null) {
      final currentTime = DateTime.now();
      return currentTime.difference(_lessonStartTime!).inSeconds;
    }
    return 0;
  }

  // Reset lesson
  void resetLesson() {
    _currentSlideIndex = 0;
    _isLessonCompleted = false;
    _timeSpent = 0;
    _lessonStartTime = DateTime.now();
    notifyListeners();
  }

  // Get slide by ID
  Slide? getSlideById(String slideId) {
    if (_currentLesson == null) return null;

    try {
      return _currentLesson!.slides.firstWhere((slide) => slide.slideId == slideId);
    } catch (e) {
      return null;
    }
  }

  // Get slides by type
  List<Slide> getSlidesByType(String slideType) {
    if (_currentLesson == null) return [];

    return _currentLesson!.slides.where((slide) => slide.slideType == slideType).toList();
  }

  // Check if slide is interactive
  bool isSlideInteractive(Slide slide) {
    return slide.slideType == 'interactive' || 
           slide.slideType == 'code' ||
           slide.content.containsKey('interactive') ||
           slide.content.containsKey('codeEditor');
  }

  // Get lesson statistics
  Map<String, dynamic> getLessonStatistics() {
    if (_currentLesson == null) {
      return {
        'totalSlides': 0,
        'currentSlide': 0,
        'progress': 0.0,
        'timeSpent': 0,
        'isCompleted': false,
      };
    }

    return {
      'lessonId': _currentLesson!.lessonId,
      'lessonTitle': _currentLesson!.lessonTitle,
      'totalSlides': totalSlides,
      'currentSlide': _currentSlideIndex + 1,
      'progress': progress,
      'timeSpent': getCurrentTimeSpent(),
      'isCompleted': _isLessonCompleted,
      'estimatedMinutes': _currentLesson!.estimatedMinutes,
    };
  }

  // Clear current lesson
  void clearLesson() {
    _currentLesson = null;
    _currentSlideIndex = 0;
    _isLessonCompleted = false;
    _timeSpent = 0;
    _lessonStartTime = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _calculateTimeSpent();
    super.dispose();
  }
}
