import '../models/track_model.dart';
import '../models/lesson_model.dart';
import '../models/quiz_model.dart';

class PythonRepository {
  static const TrackModel pythonTrack = TrackModel(
    id: 'python',
    title: 'Python - الثعبان الودود',
    icon: '🐍',
    isAccessible: true,
    progress: 0.15,
    lessonsCount: 20,
    description: 'تعلم لغة البايثون من الصفر إلى الاحتراف',
  );

  static const LessonModel pythonDemoLesson = LessonModel(
    id: 'python_hello',
    title: 'مرحباً بايثون',
    trackId: 'python',
    slides: [
      SlideModel(
        title: 'ما هي لغة البايثون؟',
        content: 'البايثون هي لغة برمجة سهلة التعلم وقوية في نفس الوقت. تستخدم في تطوير المواقع، الذكاء الاصطناعي، وتحليل البيانات.',
        code: 'print("مرحباً بالعالم!")',
        hasCode: true,
      ),
      SlideModel(
        title: 'لماذا نتعلم البايثون؟',
        content: 'البايثون مناسبة للمبتدئين لأنها سهلة القراءة والفهم. كما أنها تستخدم في شركات كبيرة مثل جوجل ونتفليكس.',
        code: 'name = "أحمد"\nprint(f"مرحباً {name}!")',
        hasCode: true,
      ),
      SlideModel(
        title: 'ملخص الدرس',
        content: 'تعلمنا في هذا الدرس:\n• ما هي لغة البايثون\n• لماذا هي مهمة\n• كيفية كتابة أول برنامج',
        hasCode: false,
      ),
    ],
  );

  static const QuizModel sampleQuiz = QuizModel(
    id: 'python_hello_quiz',
    title: 'اختبار: مرحباً بايثون',
    lessonId: 'python_hello',
    questions: [
      QuestionModel(
        id: 'q1',
        type: 'multiple_choice',
        question: 'ما هي الدالة المستخدمة لطباعة النص في البايثون؟',
        options: ['print()', 'show()', 'display()', 'output()'],
        correctAnswer: 0,
      ),
      QuestionModel(
        id: 'q2',
        type: 'fill_blank',
        question: 'أكمل الكود التالي لطباعة "مرحباً بالعالم"',
        code: '___("مرحباً بالعالم")',
        correctAnswer: 'print',
      ),
      QuestionModel(
        id: 'q3',
        type: 'drag_drop',
        question: 'رتب الكود التالي بالترتيب الصحيح:',
        codeBlocks: ['name = "أحمد"', 'print(f"مرحباً {name}!")'],
        correctOrder: [0, 1],
        correctAnswer: [0, 1],
      ),
    ],
  );

  static List<Map<String, dynamic>> getPythonUnits() {
    return [
      {
        'id': 'unit_1',
        'title': 'الوحدة الأولى: المقدمة',
        'lessons': 3,
        'isUnlocked': true,
        'isCompleted': true,
      },
      {
        'id': 'unit_2',
        'title': 'الوحدة الثانية: الأساسيات',
        'lessons': 4,
        'isUnlocked': true,
        'isCompleted': false,
      },
      {
        'id': 'unit_3',
        'title': 'الوحدة الثالثة: التطبيق',
        'lessons': 5,
        'isUnlocked': false,
        'isCompleted': false,
      },
      {
        'id': 'unit_4',
        'title': 'الوحدة الرابعة: المشاريع',
        'lessons': 3,
        'isUnlocked': false,
        'isCompleted': false,
      },
    ];
  }
}
