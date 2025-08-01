import '../models/track_model.dart';
import '../models/lesson_model.dart';
import '../models/quiz_model.dart';
import 'package:flutter/material.dart';

class PythonRepository {
  List<Track> getTracks() {
    return [
      Track(
        id: 'python-basics',
        title: 'أساسيات Python',
        description: 'تعلم أساسيات لغة البرمجة Python من الصفر',
        icon: Icons.code,
        color: const Color(0xFF4A90E2),
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
      Lesson(
        id: 'lesson-1',
        title: 'Getting Started',
        description: 'مقدمة في Python وإعداد البيئة',
        content: 'محتوى الدرس الأول...',
        trackId: trackId,
        isUnlocked: true,
        isCompleted: true,
        order: 1,
      ),
      Lesson(
        id: 'lesson-2',
        title: 'Variables & Data Types',
        description: 'تعلم المتغيرات وأنواع البيانات',
        content: 'محتوى الدرس الثاني...',
        trackId: trackId,
        isUnlocked: true,
        isCompleted: false,
        order: 2,
      ),
      Lesson(
        id: 'lesson-3',
        title: 'Working with Functions',
        description: 'كيفية إنشاء واستخدام الدوال',
        content: 'محتوى الدرس الثالث...',
        trackId: trackId,
        isUnlocked: true,
        isCompleted: false,
        order: 3,
      ),
      Lesson(
        id: 'lesson-4',
        title: 'Control Structures',
        description: 'الشروط والحلقات في Python',
        content: 'محتوى الدرس الرابع...',
        trackId: trackId,
        isUnlocked: false,
        isCompleted: false,
        order: 4,
      ),
      Lesson(
        id: 'lesson-5',
        title: 'Object-Oriented Programming',
        description: 'البرمجة الكائنية في Python',
        content: 'محتوى الدرس الخامس...',
        trackId: trackId,
        isUnlocked: false,
        isCompleted: false,
        order: 5,
      ),
      Lesson(
        id: 'lesson-6',
        title: 'Final Project',
        description: 'مشروع نهائي لتطبيق ما تعلمته',
        content: 'محتوى المشروع النهائي...',
        trackId: trackId,
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
      Quiz(
        id: 'quiz-1',
        lessonId: lessonId,
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
