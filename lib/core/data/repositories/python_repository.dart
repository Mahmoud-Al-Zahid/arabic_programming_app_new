import '../models/track_model.dart';
import '../models/lesson_model.dart';
import '../models/quiz_model.dart';
import 'package:flutter/material.dart';

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
    slides: [
      Slide(
        title: 'ما هي لغة البايثون؟',
        content: 'البايثون هي لغة برمجة سهلة التعلم وقوية في نفس الوقت.',
        code: 'print("مرحباً بالعالم!")',
        hasCode: true,
      ),
      Slide(
        title: 'لماذا نتعلم البايثون؟',
        content: 'البايثون مناسبة للمبتدئين لأنها سهلة القراءة والفهم.',
        code: 'name = "أحمد"\nprint(f"مرحباً {name}!")',
        hasCode: true,
      ),
      Slide(
        title: 'ملخص الدرس',
        content: 'تعلمنا في هذا الدرس أساسيات Python',
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
  );

  List<Track> getTracks() {
    return [
      const Track(
        id: 'python-basics',
        title: 'أساسيات Python',
        description: 'تعلم أساسيات لغة البرمجة Python من الصفر',
        icon: Icons.code,
        color: Color(0xFF4A90E2),
        progress: 0.3,
        lessonsCount: 12,
        duration: '4 ساعات',
        isUnlocked: true,
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
      const Lesson(
        id: 'lesson-1',
        title: 'Getting Started',
        description: 'مقدمة في Python وإعداد البيئة',
        content: 'محتوى الدرس الأول...',
        trackId: 'python-basics',
        isUnlocked: true,
        isCompleted: true,
        order: 1,
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
      ),
    ];
  }
}
