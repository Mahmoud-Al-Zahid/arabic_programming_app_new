class JsonPaths {
  // Base paths
  static const String _basePath = 'assets/data';
  static const String _languagesPath = '$_basePath/languages';
  static const String _coursesPath = '$_basePath/courses';
  static const String _lessonsPath = '$_basePath/lessons';
  static const String _quizzesPath = '$_basePath/quizzes';

  // Main data files
  static const String languages = '$_languagesPath/languages.json';

  // Course paths
  static String getCoursePathForLanguage(String languageId) {
    return '$_coursesPath/$languageId.json';
  }

  // Lesson paths
  static String getLessonPath(String languageId, String lessonId) {
    return '$_lessonsPath/$languageId/$lessonId.json';
  }

  // Quiz paths
  static String getLessonQuizPath(String lessonId) {
    return '$_quizzesPath/lessons/${lessonId}_quiz.json';
  }

  static String getLevelQuizPath(String levelId) {
    return '$_quizzesPath/levels/${levelId}_quiz.json';
  }

  // Specific language course paths
  static const String pythonCourse = '$_coursesPath/python.json';
  static const String javascriptCourse = '$_coursesPath/javascript.json';
  static const String javaCourse = '$_coursesPath/java.json';
  static const String cppCourse = '$_coursesPath/cpp.json';
  static const String csharpCourse = '$_coursesPath/csharp.json';

  // Specific lesson paths for Python
  static const String pythonIntroLesson = '$_lessonsPath/python/intro_01.json';
  static const String pythonVariablesLesson = '$_lessonsPath/python/variables_03.json';
  static const String pythonFunctionsLesson = '$_lessonsPath/python/functions_05.json';
  static const String pythonLoopsLesson = '$_lessonsPath/python/loops_07.json';
  static const String pythonOopLesson = '$_lessonsPath/python/oop_09.json';

  // Specific quiz paths
  static const String pythonIntroQuiz = '$_quizzesPath/lessons/intro_01_quiz.json';
  static const String pythonVariablesQuiz = '$_quizzesPath/lessons/variables_03_quiz.json';
  static const String pythonBasicsLevelQuiz = '$_quizzesPath/levels/python_basics_level_quiz.json';

  // Helper methods
  static List<String> getAllLanguagePaths() {
    return [
      pythonCourse,
      javascriptCourse,
      javaCourse,
      cppCourse,
      csharpCourse,
    ];
  }

  static List<String> getPythonLessonPaths() {
    return [
      pythonIntroLesson,
      pythonVariablesLesson,
      pythonFunctionsLesson,
      pythonLoopsLesson,
      pythonOopLesson,
    ];
  }

  static List<String> getPythonQuizPaths() {
    return [
      pythonIntroQuiz,
      pythonVariablesQuiz,
      pythonBasicsLevelQuiz,
    ];
  }

  // Validation methods
  static bool isValidLanguagePath(String path) {
    return path.startsWith(_coursesPath) && path.endsWith('.json');
  }

  static bool isValidLessonPath(String path) {
    return path.startsWith(_lessonsPath) && path.endsWith('.json');
  }

  static bool isValidQuizPath(String path) {
    return path.startsWith(_quizzesPath) && path.endsWith('.json');
  }

  // Path extraction methods
  static String? extractLanguageIdFromCoursePath(String path) {
    if (!isValidLanguagePath(path)) return null;
    
    final fileName = path.split('/').last;
    return fileName.replaceAll('.json', '');
  }

  static String? extractLessonIdFromPath(String path) {
    if (!isValidLessonPath(path)) return null;
    
    final fileName = path.split('/').last;
    return fileName.replaceAll('.json', '');
  }

  static String? extractQuizIdFromPath(String path) {
    if (!isValidQuizPath(path)) return null;
    
    final fileName = path.split('/').last;
    return fileName.replaceAll('_quiz.json', '');
  }
}
