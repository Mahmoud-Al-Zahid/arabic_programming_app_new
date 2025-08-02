import 'package:flutter/material.dart';
import '../data/models/track_model.dart';
import '../data/models/lesson_model.dart';
import '../data/models/quiz_model.dart';
import '../data/models/user_model.dart';
import 'data_service.dart';

class MockDataService implements DataService {
  static final MockDataService _instance = MockDataService._internal();
  factory MockDataService() => _instance;
  MockDataService._internal();

  // Mock data storage
  late List<Track> _tracks;
  late List<Lesson> _lessons;
  late List<Quiz> _quizzes;
  late User _currentUser;

  void _initializeData() {
    _tracks = [
      const Track(
        id: 'python-basics',
        title: 'أساسيات Python',
        description: 'تعلم أساسيات لغة البرمجة Python من الصفر',
        icon: Icons.code,
        color: Color(0xFF4A90E2),
        progress: 0.3,
        lessonsCount: 6,
        duration: '4 ساعات',
        isUnlocked: true,
        imageUrl: 'assets/images/tracks/python_basics.png',
      ),
      const Track(
        id: 'python-advanced',
        title: 'Python المتقدم',
        description: 'تعلم المفاهيم المتقدمة في Python',
        icon: Icons.rocket_launch,
        color: Color(0xFF9B59B6),
        progress: 0.0,
        lessonsCount: 8,
        duration: '6 ساعات',
        isUnlocked: false,
        imageUrl: 'assets/images/tracks/python_advanced.png',
      ),
      const Track(
        id: 'web-development',
        title: 'تطوير الويب',
        description: 'تعلم تطوير مواقع الويب باستخدام Python',
        icon: Icons.web,
        color: Color(0xFF2ECC71),
        progress: 0.0,
        lessonsCount: 10,
        duration: '8 ساعات',
        isUnlocked: false,
        imageUrl: 'assets/images/tracks/web_development.png',
      ),
    ];

    _lessons = [
      const Lesson(
        id: 'lesson-1',
        title: 'Getting Started',
        description: 'مقدمة في Python وإعداد البيئة',
        content: 'محتوى الدرس الأول...',
        trackId: 'python-basics',
        isUnlocked: true,
        isCompleted: true,
        order: 1,
        imageUrl: 'assets/images/lessons/getting_started.png',
        duration: 20,
        slides: [
          Slide(
            title: 'ما هي لغة البايثون؟',
            content: 'البايثون هي لغة برمجة سهلة التعلم وقوية في نفس الوقت. تم إنشاؤها في عام 1991 وهي من أكثر اللغات شيوعاً في العالم.',
            code: 'print("مرحباً بالعالم!")',
            hasCode: true,
          ),
          Slide(
            title: 'لماذا نتعلم البايثون؟',
            content: 'البايثون مناسبة للمبتدئين لأنها سهلة القراءة والفهم. كما أنها تستخدم في تطوير الويب، الذكاء الاصطناعي، وتحليل البيانات.',
            code: 'name = "أحمد"\nprint(f"مرحباً {name}!")',
            hasCode: true,
          ),
          Slide(
            title: 'ملخص الدرس',
            content: 'تعلمنا في هذا الدرس أساسيات Python وأهميتها في عالم البرمجة. في الدرس القادم سنتعلم عن المتغيرات وأنواع البيانات.',
            hasCode: false,
          ),
        ],
      ),
      const Lesson(
        id: 'lesson-2',
        title: 'Variables & Data Types',
        description: 'تعلم المتغيرات وأنواع البيانات',
        content: 'محتوى الدرس الثاني...',
        trackId: 'python-basics',
        isUnlocked: true,
        isCompleted: false,
        order: 2,
        imageUrl: 'assets/images/lessons/variables.png',
        duration: 25,
        slides: [
          Slide(
            title: 'ما هي المتغيرات؟',
            content: 'المتغيرات هي مساحات في الذاكرة نستخدمها لحفظ البيانات. في Python لا نحتاج لتحديد نوع المتغير مسبقاً.',
            code: 'age = 25\nname = "سارة"\nis_student = True',
            hasCode: true,
          ),
          Slide(
            title: 'أنواع البيانات',
            content: 'Python يحتوي على عدة أنواع من البيانات: الأرقام الصحيحة (int)، الأرقام العشرية (float)، النصوص (str)، والقيم المنطقية (bool).',
            code: 'number = 42        # int\nprice = 19.99     # float\nmessage = "Hello" # str\nis_valid = True   # bool',
            hasCode: true,
          ),
        ],
      ),
      const Lesson(
        id: 'lesson-3',
        title: 'Working with Functions',
        description: 'كيفية إنشاء واستخدام الدوال',
        content: 'محتوى الدرس الثالث...',
        trackId: 'python-basics',
        isUnlocked: true,
        isCompleted: false,
        order: 3,
        imageUrl: 'assets/images/lessons/functions.png',
        duration: 30,
      ),
      const Lesson(
        id: 'lesson-4',
        title: 'Control Structures',
        description: 'الشروط والحلقات في Python',
        content: 'محتوى الدرس الرابع...',
        trackId: 'python-basics',
        isUnlocked: false,
        isCompleted: false,
        order: 4,
        imageUrl: 'assets/images/lessons/control_structures.png',
        duration: 35,
      ),
      const Lesson(
        id: 'lesson-5',
        title: 'Object-Oriented Programming',
        description: 'البرمجة الكائنية في Python',
        content: 'محتوى الدرس الخامس...',
        trackId: 'python-basics',
        isUnlocked: false,
        isCompleted: false,
        order: 5,
        imageUrl: 'assets/images/lessons/oop.png',
        duration: 40,
      ),
      const Lesson(
        id: 'lesson-6',
        title: 'Final Project',
        description: 'مشروع نهائي لتطبيق ما تعلمته',
        content: 'محتوى المشروع النهائي...',
        trackId: 'python-basics',
        isUnlocked: false,
        isCompleted: false,
        order: 6,
        imageUrl: 'assets/images/lessons/final_project.png',
        duration: 60,
      ),
    ];

    _quizzes = [
      Quiz(
        id: 'quiz-1',
        lessonId: 'lesson-1',
        title: 'اختبار أساسيات Python',
        timeLimit: 5,
        questions: [
          const QuizQuestion(
            id: 'q1',
            question: 'ما هي الطريقة الصحيحة لطباعة "Hello World" في Python؟',
            options: [
              'print("Hello World")',
              'echo "Hello World"',
              'console.log("Hello World")',
              'printf("Hello World")',
            ],
            correctAnswer: 0,
            explanation: 'في Python نستخدم دالة print() لطباعة النصوص.',
          ),
          const QuizQuestion(
            id: 'q2',
            question: 'أي من التالي صحيح حول Python؟',
            options: [
              'لغة صعبة التعلم',
              'لا تدعم البرمجة الكائنية',
              'سهلة القراءة والفهم',
              'تحتاج لتعريف نوع المتغير',
            ],
            correctAnswer: 2,
            explanation: 'Python معروفة بسهولة قراءتها وفهمها.',
          ),
        ],
      ),
      Quiz(
        id: 'quiz-2',
        lessonId: 'lesson-2',
        title: 'اختبار المتغيرات وأنواع البيانات',
        timeLimit: 7,
        questions: [
          const QuizQuestion(
            id: 'q3',
            question: 'ما نوع البيانات للقيمة 42 في Python؟',
            options: ['string', 'float', 'int', 'boolean'],
            correctAnswer: 2,
            explanation: '42 هو رقم صحيح، لذا نوعه int.',
          ),
        ],
      ),
    ];

    _currentUser = const User(
      id: 'user-1',
      name: 'أحمد محمد',
      email: 'ahmed@example.com',
      avatarUrl: 'assets/images/avatars/user_1.png',
      level: 5,
      xp: 1250,
      coins: 850,
      completedLessons: ['lesson-1'],
      unlockedTracks: ['python-basics'],
    );
  }

  @override
  Future<List<Track>> getTracks() async {
    _initializeData();
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
    return List.from(_tracks);
  }

  @override
  Future<Track?> getTrackById(String id) async {
    _initializeData();
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _tracks.firstWhere((track) => track.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> updateTrackProgress(String trackId, double progress) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final trackIndex = _tracks.indexWhere((track) => track.id == trackId);
    if (trackIndex != -1) {
      _tracks[trackIndex] = _tracks[trackIndex].copyWith(progress: progress);
    }
  }

  @override
  Future<List<Lesson>> getLessonsByTrackId(String trackId) async {
    _initializeData();
    await Future.delayed(const Duration(milliseconds: 300));
    return _lessons.where((lesson) => lesson.trackId == trackId).toList();
  }

  @override
  Future<Lesson?> getLessonById(String id) async {
    _initializeData();
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _lessons.firstWhere((lesson) => lesson.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> markLessonCompleted(String lessonId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final lessonIndex = _lessons.indexWhere((lesson) => lesson.id == lessonId);
    if (lessonIndex != -1) {
      _lessons[lessonIndex] = _lessons[lessonIndex].copyWith(isCompleted: true);
    }
  }

  @override
  Future<List<Quiz>> getQuizzesByLessonId(String lessonId) async {
    _initializeData();
    await Future.delayed(const Duration(milliseconds: 200));
    return _quizzes.where((quiz) => quiz.lessonId == lessonId).toList();
  }

  @override
  Future<Quiz?> getQuizById(String id) async {
    _initializeData();
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _quizzes.firstWhere((quiz) => quiz.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> saveQuizResult(String quizId, int score, int totalQuestions) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // In a real app, this would save to a database
    debugPrint('Quiz $quizId completed with score: $score/$totalQuestions');
  }

  @override
  Future<User?> getCurrentUser() async {
    _initializeData();
    await Future.delayed(const Duration(milliseconds: 200));
    return _currentUser;
  }

  @override
  Future<void> updateUserProgress(String userId, int xpGained, int coinsGained) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (_currentUser.id == userId) {
      final newLevel = (_currentUser.xp + xpGained) ~/ 500 + 1;
      _currentUser = _currentUser.copyWith(
        xp: _currentUser.xp + xpGained,
        coins: _currentUser.coins + coinsGained,
        level: newLevel,
      );
    }
  }

  @override
  Future<void> updateUserProfile(User user) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _currentUser = user;
  }
}
