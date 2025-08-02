import '../datasources/json_datasource.dart';
import '../datasources/cache_datasource.dart';
import '../models/language_model.dart';
import '../models/course_model.dart';
import '../models/lesson_model.dart';
import '../models/quiz_model.dart';
import '../../domain/entities/language_entity.dart';
import '../../domain/entities/course_entity.dart';
import '../../domain/repositories/course_repository_interface.dart';

class CourseRepository implements CourseRepositoryInterface {
  final JsonDataSource _jsonDataSource;
  final CacheDataSource _cacheDataSource;

  CourseRepository({
    JsonDataSource? jsonDataSource,
    CacheDataSource? cacheDataSource,
  })  : _jsonDataSource = jsonDataSource ?? JsonDataSource(),
        _cacheDataSource = cacheDataSource ?? CacheDataSource();

  @override
  Future<List<LanguageEntity>> getLanguages() async {
    try {
      final languages = await _jsonDataSource.getLanguages();
      return languages.map((language) => _mapLanguageToEntity(language)).toList();
    } catch (e) {
      print('Error in CourseRepository.getLanguages: $e');
      return [];
    }
  }

  @override
  Future<CourseEntity?> getCourse(String languageId) async {
    try {
      final course = await _jsonDataSource.getCourse(languageId);
      if (course == null) return null;
      
      return _mapCourseToEntity(course);
    } catch (e) {
      print('Error in CourseRepository.getCourse: $e');
      return null;
    }
  }

  @override
  Future<List<dynamic>> searchContent(String query, {String? languageId}) async {
    try {
      return await _jsonDataSource.searchContent(query, languageId: languageId);
    } catch (e) {
      print('Error in CourseRepository.searchContent: $e');
      return [];
    }
  }

  // Additional methods not in interface but needed by the app
  Future<Lesson?> getLesson(String languageId, String lessonId) async {
    try {
      return await _jsonDataSource.getLesson(languageId, lessonId);
    } catch (e) {
      print('Error in CourseRepository.getLesson: $e');
      return null;
    }
  }

  Future<Quiz?> getLessonQuiz(String lessonId) async {
    try {
      return await _jsonDataSource.getLessonQuiz(lessonId);
    } catch (e) {
      print('Error in CourseRepository.getLessonQuiz: $e');
      return null;
    }
  }

  Future<Quiz?> getLevelQuiz(String levelId) async {
    try {
      return await _jsonDataSource.getLevelQuiz(levelId);
    } catch (e) {
      print('Error in CourseRepository.getLevelQuiz: $e');
      return null;
    }
  }

  Future<List<String>> getLessonIds(String languageId) async {
    try {
      return await _jsonDataSource.getLessonIds(languageId);
    } catch (e) {
      print('Error in CourseRepository.getLessonIds: $e');
      return [];
    }
  }

  Future<List<String>> getQuizIds(String languageId) async {
    try {
      return await _jsonDataSource.getQuizIds(languageId);
    } catch (e) {
      print('Error in CourseRepository.getQuizIds: $e');
      return [];
    }
  }

  Future<void> refreshData() async {
    try {
      _jsonDataSource.clearCache();
      await _cacheDataSource.clearAllCache();
    } catch (e) {
      print('Error in CourseRepository.refreshData: $e');
    }
  }

  Future<void> clearCache() async {
    try {
      _jsonDataSource.clearCache();
      await _cacheDataSource.clearAllCache();
    } catch (e) {
      print('Error in CourseRepository.clearCache: $e');
    }
  }

  Future<Map<String, List<String>>> validateAllData() async {
    try {
      return await _jsonDataSource.validateAllJsonFiles();
    } catch (e) {
      print('Error in CourseRepository.validateAllData: $e');
      return {'validation_error': ['$e']};
    }
  }

  // Mapping methods
  LanguageEntity _mapLanguageToEntity(Language language) {
    return LanguageEntity(
      id: language.id,
      name: language.name,
      description: language.description,
      icon: language.icon,
      color: language.color,
      isPopular: language.isPopular,
      difficulty: language.difficulty,
      estimatedHours: language.estimatedHours,
    );
  }

  CourseEntity _mapCourseToEntity(Course course) {
    return CourseEntity(
      languageId: course.languageId,
      languageName: course.languageName,
      description: course.description,
      estimatedHours: course.estimatedHours,
      levels: course.levels.map((level) => _mapLevelToEntity(level)).toList(),
    );
  }

  LevelEntity _mapLevelToEntity(Level level) {
    return LevelEntity(
      levelId: level.levelId,
      levelName: level.levelName,
      description: level.description,
      order: level.order,
      estimatedHours: level.estimatedHours,
      lessons: level.lessons.map((lesson) => _mapLessonToEntity(lesson)).toList(),
    );
  }

  LessonEntity _mapLessonToEntity(LessonSummary lesson) {
    return LessonEntity(
      lessonId: lesson.lessonId,
      lessonTitle: lesson.lessonTitle,
      description: lesson.description,
      estimatedMinutes: lesson.estimatedMinutes,
      difficulty: lesson.difficulty,
      order: lesson.order,
      isUnlocked: lesson.isUnlocked,
      isCompleted: lesson.isCompleted,
    );
  }
}
