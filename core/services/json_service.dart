import 'dart:convert';
import 'package:flutter/services.dart';
import '../data/models/language_model.dart';
import '../data/models/course_model.dart';
import '../data/models/lesson_model.dart';
import '../data/models/quiz_model.dart';
import '../data/models/user_model.dart';
import '../data/models/user_progress_model.dart';

class JsonService {
  // Load languages from JSON
  Future<List<LanguageModel>> loadLanguages() async {
    try {
      final String response = await rootBundle.loadString('assets/languages/languages.json');
      final Map<String, dynamic> data = json.decode(response);
      final List<dynamic> languagesJson = data['languages'];
      
      return languagesJson.map((json) => LanguageModel.fromJson(json)).toList();
    } catch (e) {
      print('Error loading languages: $e');
      return _getMockLanguages();
    }
  }

  // Load course by language ID
  Future<CourseModel?> loadCourse(String languageId) async {
    try {
      final String response = await rootBundle.loadString('assets/courses/$languageId.json');
      final Map<String, dynamic> data = json.decode(response);
      
      return CourseModel.fromJson(data);
    } catch (e) {
      print('Error loading course for $languageId: $e');
      return _getMockCourse(languageId);
    }
  }

  // Load courses by language
  Future<List<CourseModel>> loadCoursesByLanguage(String languageId) async {
    final course = await loadCourse(languageId);
    return course != null ? [course] : [];
  }

  // Load lessons by course
  Future<List<LessonModel>> loadLessonsByCourse(String courseId) async {
    try {
      // For now, return mock lessons based on course ID
      return _getMockLessons(courseId);
    } catch (e) {
      print('Error loading lessons for course $courseId: $e');
      return [];
    }
  }

  // Load specific lesson
  Future<LessonModel?> loadLesson(String lessonId) async {
    try {
      // Try to load from different language folders
      final languages = ['python', 'javascript', 'java'];
      
      for (String lang in languages) {
        try {
          final String response = await rootBundle.loadString('assets/lessons/$lang/$lessonId.json');
          final Map<String, dynamic> data = json.decode(response);
          return LessonModel.fromJson(data);
        } catch (e) {
          continue;
        }
      }
      
      return _getMockLesson(lessonId);
    } catch (e) {
      print('Error loading lesson $lessonId: $e');
      return _getMockLesson(lessonId);
    }
  }

  // Load quiz
  Future<QuizModel?> loadQuiz(String quizId) async {
    try {
      // Try to load from lessons folder first
      try {
        final String response = await rootBundle.loadString('assets/quizzes/lessons/$quizId.json');
        final Map<String, dynamic> data = json.decode(response);
        return QuizModel.fromJson(data);
      } catch (e) {
        // Try levels folder
        final String response = await rootBundle.loadString('assets/quizzes/levels/$quizId.json');
        final Map<String, dynamic> data = json.decode(response);
        return QuizModel.fromJson(data);
      }
    } catch (e) {
      print('Error loading quiz $quizId: $e');
      return _getMockQuiz(quizId);
    }
  }

  // Mock data methods
  List<LanguageModel> _getMockLanguages() {
    return [
      LanguageModel(
        id: 'python',
        name: 'Python',
        nameAr: 'بايثون',
        description: 'لغة برمجة سهلة ومرنة',
        icon: 'assets/images/languages/python_bg.png',
        color: '#3776ab',
        difficulty: 'مبتدئ',
        estimatedHours: 40,
        isPopular: true,
        courses: [],
      ),
      LanguageModel(
        id: 'javascript',
        name: 'JavaScript',
        nameAr: 'جافا سكريبت',
        description: 'لغة الويب الأساسية',
        icon: 'assets/images/languages/javascript_bg.png',
        color: '#f7df1e',
        difficulty: 'متوسط',
        estimatedHours: 35,
        isPopular: true,
        courses: [],
      ),
      LanguageModel(
        id: 'java',
        name: 'Java',
        nameAr: 'جافا',
        description: 'لغة برمجة قوية ومتعددة الاستخدامات',
        icon: 'assets/images/languages/java_bg.png',
        color: '#ed8b00',
        difficulty: 'متقدم',
        estimatedHours: 50,
        isPopular: false,
        courses: [],
      ),
    ];
  }

  CourseModel _getMockCourse(String languageId) {
    return CourseModel(
      courseId: '${languageId}_basics',
      languageId: languageId,
      title: 'أساسيات ${_getLanguageName(languageId)}',
      description: 'تعلم أساسيات لغة ${_getLanguageName(languageId)} من الصفر',
      difficulty: 'مبتدئ',
      estimatedHours: 20,
      instructor: 'فريق التطوير',
      rating: 4.8,
      studentsCount: 1250,
      isCompleted: false,
      progress: 0.0,
      levels: [],
      prerequisites: [],
      learningOutcomes: [
        'فهم أساسيات البرمجة',
        'كتابة برامج بسيطة',
        'حل المشاكل البرمجية',
      ],
    );
  }

  List<LessonModel> _getMockLessons(String courseId) {
    return [
      LessonModel(
        lessonId: 'intro_01',
        courseId: courseId,
        title: 'مقدمة في البرمجة',
        description: 'تعرف على أساسيات البرمجة والمفاهيم الأولية',
        order: 1,
        estimatedMinutes: 15,
        isCompleted: false,
        isUnlocked: true,
        slides: [
          SlideModel(
            slideId: 'slide_1',
            title: 'مرحباً بك في عالم البرمجة',
            content: 'البرمجة هي فن كتابة التعليمات للحاسوب لحل المشاكل وإنجاز المهام.',
            slideType: 'text',
            order: 1,
            hasCode: false,
          ),
          SlideModel(
            slideId: 'slide_2',
            title: 'ما هي البرمجة؟',
            content: 'البرمجة هي عملية إنشاء مجموعة من التعليمات التي تخبر الحاسوب كيفية أداء مهمة معينة.',
            slideType: 'text',
            order: 2,
            hasCode: true,
            code: 'print("مرحباً بالعالم!")',
          ),
        ],
        quiz: null,
      ),
      LessonModel(
        lessonId: 'variables_03',
        courseId: courseId,
        title: 'المتغيرات',
        description: 'تعلم كيفية استخدام المتغيرات في البرمجة',
        order: 2,
        estimatedMinutes: 20,
        isCompleted: false,
        isUnlocked: false,
        slides: [
          SlideModel(
            slideId: 'slide_1',
            title: 'ما هي المتغيرات؟',
            content: 'المتغيرات هي حاويات لتخزين البيانات في البرنامج.',
            slideType: 'text',
            order: 1,
            hasCode: true,
            code: 'name = "أحمد"\nage = 25',
          ),
        ],
        quiz: null,
      ),
    ];
  }

  LessonModel _getMockLesson(String lessonId) {
    return LessonModel(
      lessonId: lessonId,
      courseId: 'python_basics',
      title: 'درس تجريبي',
      description: 'هذا درس تجريبي للاختبار',
      order: 1,
      estimatedMinutes: 15,
      isCompleted: false,
      isUnlocked: true,
      slides: [
        SlideModel(
          slideId: 'slide_1',
          title: 'مرحباً',
          content: 'هذا محتوى تجريبي للدرس',
          slideType: 'text',
          order: 1,
          hasCode: false,
        ),
      ],
      quiz: null,
    );
  }

  QuizModel _getMockQuiz(String quizId) {
    return QuizModel(
      quizId: quizId,
      lessonId: 'intro_01',
      title: 'اختبار تجريبي',
      description: 'اختبار بسيط لقياس فهمك',
      timeLimit: 300,
      passingScore: 70,
      questions: [
        QuestionModel(
          questionId: 'q1',
          questionText: 'ما هي البرمجة؟',
          questionType: 'multiple_choice',
          options: [
            'فن كتابة التعليمات للحاسوب',
            'لعبة كمبيوتر',
            'نوع من الرياضيات',
            'لا أعرف',
          ],
          correctAnswer: 0,
          explanation: 'البرمجة هي فن كتابة التعليمات للحاسوب لحل المشاكل.',
          points: 10,
        ),
      ],
    );
  }

  String _getLanguageName(String languageId) {
    switch (languageId) {
      case 'python':
        return 'بايثون';
      case 'javascript':
        return 'جافا سكريبت';
      case 'java':
        return 'جافا';
      default:
        return 'البرمجة';
    }
  }
}
