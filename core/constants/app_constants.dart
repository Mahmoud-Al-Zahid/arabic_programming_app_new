class AppConstants {
  // مسارات الأصول
  static const String assetsPath = 'assets/';
  static const String imagesPath = '${assetsPath}images/';
  static const String avatarsPath = '${imagesPath}avatars/';
  static const String backgroundsPath = '${imagesPath}backgrounds/';
  static const String tracksPath = '${imagesPath}tracks/';
  static const String lessonsPath = '${imagesPath}lessons/';
  static const String languagesPath = '${imagesPath}languages/';
  static const String slidesPath = '${imagesPath}slides/';
  
  // مسارات JSON
  static const String jsonPath = '${assetsPath}json/';
  static const String languagesJsonPath = '${jsonPath}languages/';
  static const String coursesJsonPath = '${jsonPath}courses/';
  static const String lessonsJsonPath = '${jsonPath}lessons/';
  static const String quizzesJsonPath = '${jsonPath}quizzes/';
  
  // إعدادات التطبيق
  static const String appName = 'تعلم البرمجة بالعربية';
  static const String appVersion = '1.0.0';
  static const int splashDuration = 3000;
  static const int animationDuration = 300;
  
  // إعدادات التعلم
  static const int defaultLessonTime = 15; // دقيقة
  static const int defaultQuizTime = 10; // دقيقة
  static const int passingScore = 70; // النسبة المئوية للنجاح
  static const int maxAttempts = 3; // عدد المحاولات القصوى
  
  // إعدادات المكافآت
  static const int xpPerLesson = 50;
  static const int xpPerQuiz = 100;
  static const int coinsPerLesson = 10;
  static const int coinsPerQuiz = 20;
  static const int xpPerLevel = 1000;
  
  // ألوان اللغات
  static const Map<String, String> languageColors = {
    'python': '#3776AB',
    'javascript': '#F7DF1E',
    'java': '#ED8B00',
    'cpp': '#00599C',
    'csharp': '#239120',
    'php': '#777BB4',
    'swift': '#FA7343',
    'kotlin': '#0095D5',
  };
  
  // أيقونات اللغات
  static const Map<String, String> languageIcons = {
    'python': '🐍',
    'javascript': '🟨',
    'java': '☕',
    'cpp': '⚡',
    'csharp': '#️⃣',
    'php': '🐘',
    'swift': '🦉',
    'kotlin': '🎯',
  };
}
