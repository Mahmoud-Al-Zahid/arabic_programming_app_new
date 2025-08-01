import '../models/track_model.dart';
import '../models/lesson_model.dart';
import '../models/quiz_model.dart';
import '../models/user_model.dart';
import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';

class PythonRepository {
  // Static data for backward compatibility
  static const pythonDemoLesson = Lesson(
    id: 'python_hello',
    title: 'مرحباً بايثون',
    description: 'تعلم أساسيات Python',
    content: 'محتوى الدرس...',
    trackId: 'python',
    isUnlocked: true,
    isCompleted: false,
    order: 1,
    backgroundImage: '${AppConstants.lessonsPath}python_intro.jpg',
    slides: [
      Slide(
        title: 'ما هي لغة البايثون؟',
        content: 'البايثون هي لغة برمجة سهلة التعلم وقوية في نفس الوقت. تم إنشاؤها بواسطة جويدو فان روسوم في عام 1991.',
        code: 'print("مرحباً بالعالم!")',
        hasCode: true,
      ),
      Slide(
        title: 'لماذا نتعلم البايثون؟',
        content: 'البايثون مناسبة للمبتدئين لأنها سهلة القراءة والفهم. كما أنها تستخدم في العديد من المجالات مثل تطوير الويب والذكاء الاصطناعي.',
        code: 'name = "أحمد"\nprint(f"مرحباً {name}!")',
        hasCode: true,
      ),
      Slide(
        title: 'ملخص الدرس',
        content: 'تعلمنا في هذا الدرس أساسيات Python وأهميتها في عالم البرمجة. في الدرس القادم سنتعلم كيفية كتابة أول برنامج لنا.',
        hasCode: false,
      ),
    ],
  );

  static const sampleQuiz = Quiz(
    id: 'python_hello_quiz',
    lessonId: 'python_hello',
    question: 'ما هي الدالة المستخدمة لطباعة النص في البايثون؟',
    options: ['print()', 'show()', 'display()', 'output()'],
    correctAnswer: 0,
    explanation: 'الدالة print() هي الدالة المستخدمة لطباعة النص في البايثون.',
  );

  List<Track> getTracks() {
    return [
      Track(
        id: 'python-basics',
        title: 'أساسيات Python',
        description: 'تعلم أساسيات لغة البرمجة Python من الصفر حتى الاحتراف',
        icon: Icons.code,
        color: const Color(0xFF4A90E2),
        progress: 0.3,
        lessonsCount: 12,
        duration: '4 ساعات',
        isUnlocked: true,
        backgroundImage: '${AppConstants.tracksPath}python_basics.jpg',
      ),
      Track(
        id: 'python-advanced',
        title: 'Python المتقدم',
        description: 'تعلم المفاهيم المتقدمة في Python مثل OOP والمكتبات',
        icon: Icons.rocket_launch,
        color: const Color(0xFF9B59B6),
        progress: 0.0,
        lessonsCount: 15,
        duration: '6 ساعات',
        isUnlocked: false,
        backgroundImage: '${AppConstants.tracksPath}python_advanced.jpg',
      ),
      Track(
        id: 'web-development',
        title: 'تطوير الويب',
        description: 'تعلم تطوير مواقع الويب باستخدام Django و Flask',
        icon: Icons.web,
        color: const Color(0xFF2ECC71),
        progress: 0.0,
        lessonsCount: 20,
        duration: '8 ساعات',
        isUnlocked: false,
        backgroundImage: '${AppConstants.tracksPath}web_development.jpg',
      ),
    ];
  }

  Track? getTrackById(String id) {
    final tracks = getTracks();
    try {
      return tracks.firstWhere((track) => track.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Lesson> getLessonsByTrackId(String trackId) {
    return [
      Lesson(
        id: 'lesson-1',
        title: 'Getting Started',
        description: 'مقدمة في Python وإعداد البيئة البرمجية',
        content: 'في هذا الدرس سنتعلم كيفية تثبيت Python وإعداد البيئة البرمجية...',
        trackId: trackId,
        isUnlocked: true,
        isCompleted: true,
        order: 1,
        backgroundImage: '${AppConstants.lessonsPath}getting_started.jpg',
      ),
      Lesson(
        id: 'lesson-2',
        title: 'Variables & Data Types',
        description: 'تعلم المتغيرات وأنواع البيانات المختلفة',
        content: 'المتغيرات هي أساس أي لغة برمجة. في هذا الدرس سنتعلم كيفية إنشاء واستخدام المتغيرات...',
        trackId: trackId,
        isUnlocked: true,
        isCompleted: false,
        order: 2,
        backgroundImage: '${AppConstants.lessonsPath}variables.jpg',
      ),
      Lesson(
        id: 'lesson-3',
        title: 'Working with Functions',
        description: 'كيفية إنشاء واستخدام الدوال في Python',
        content: 'الدوال تساعدنا على تنظيم الكود وإعادة استخدامه. سنتعلم كيفية كتابة دوال فعالة...',
        trackId: trackId,
        isUnlocked: true,
        isCompleted: false,
        order: 3,
        backgroundImage: '${AppConstants.lessonsPath}functions.jpg',
      ),
      Lesson(
        id: 'lesson-4',
        title: 'Control Structures',
        description: 'الشروط والحلقات في Python',
        content: 'تعلم كيفية التحكم في تدفق البرنامج باستخدام الشروط والحلقات...',
        trackId: trackId,
        isUnlocked: false,
        isCompleted: false,
        order: 4,
        backgroundImage: '${AppConstants.lessonsPath}control_structures.jpg',
      ),
      Lesson(
        id: 'lesson-5',
        title: 'Object-Oriented Programming',
        description: 'البرمجة الكائنية في Python',
        content: 'تعلم مفاهيم البرمجة الكائنية وكيفية تطبيقها في Python...',
        trackId: trackId,
        isUnlocked: false,
        isCompleted: false,
        order: 5,
        backgroundImage: '${AppConstants.lessonsPath}oop.jpg',
      ),
      Lesson(
        id: 'lesson-6',
        title: 'Final Project',
        description: 'مشروع نهائي لتطبيق ما تعلمته',
        content: 'في هذا المشروع النهائي ستطبق جميع المفاهيم التي تعلمتها...',
        trackId: trackId,
        isUnlocked: false,
        isCompleted: false,
        order: 6,
        backgroundImage: '${AppConstants.lessonsPath}final_project.jpg',
      ),
    ];
  }

  Lesson? getLessonById(String id) {
    final allLessons = getLessonsByTrackId('python-basics');
    try {
      return allLessons.firstWhere((lesson) => lesson.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Quiz> getQuizzesByLessonId(String lessonId) {
    return [
      const Quiz(
        id: 'quiz-1',
        lessonId: 'lesson-1',
        question: 'ما هي الطريقة الصحيحة لطباعة "Hello World" في Python؟',
        options: [
          'print("Hello World")',
          'echo "Hello World"',
          'console.log("Hello World")',
          'printf("Hello World")',
        ],
        correctAnswer: 0,
        explanation: 'في Python نستخدم الدالة print() لطباعة النصوص.',
      ),
      const Quiz(
        id: 'quiz-2',
        lessonId: 'lesson-2',
        question: 'أي من التالي هو نوع بيانات صحيح في Python؟',
        options: [
          'int',
          'string',
          'boolean',
          'جميع ما سبق',
        ],
        correctAnswer: 3,
        explanation: 'Python يدعم جميع أنواع البيانات المذكورة: int, str, bool.',
      ),
    ];
  }

  Quiz? getQuizById(String id) {
    final allQuizzes = getQuizzesByLessonId('lesson-1');
    try {
      return allQuizzes.firstWhere((quiz) => quiz.id == id);
    } catch (e) {
      return sampleQuiz;
    }
  }

  User getCurrentUser() {
    return User(
      id: 'user-1',
      name: 'أحمد محمد',
      email: 'ahmed@example.com',
      avatarUrl: '${AppConstants.avatarsPath}user_avatar.jpg',
      level: 5,
      xp: 1250,
      coins: 850,
      completedLessons: ['lesson-1'],
      unlockedTracks: ['python-basics'],
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      lastActiveAt: DateTime.now(),
    );
  }
}
