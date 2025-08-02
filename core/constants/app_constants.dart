class AppConstants {
  // App Information
  static const String appName = 'تعلم البرمجة بالعربية';
  static const String appVersion = '1.0.0';
  
  // Design Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double extraLargePadding = 32.0;
  
  static const double defaultBorderRadius = 12.0;
  static const double smallBorderRadius = 8.0;
  static const double largeBorderRadius = 20.0;
  
  static const double defaultElevation = 4.0;
  static const double smallElevation = 2.0;
  static const double largeElevation = 8.0;
  
  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 400);
  static const Duration longAnimationDuration = Duration(milliseconds: 600);
  
  // Spacing
  static const double smallSpacing = 4.0;
  static const double mediumSpacing = 8.0;
  static const double largeSpacing = 16.0;
  static const double extraLargeSpacing = 24.0;
  
  // Icon Sizes
  static const double smallIconSize = 16.0;
  static const double mediumIconSize = 24.0;
  static const double largeIconSize = 32.0;
  static const double extraLargeIconSize = 48.0;
  
  // Font Sizes
  static const double smallFontSize = 12.0;
  static const double mediumFontSize = 14.0;
  static const double largeFontSize = 16.0;
  static const double extraLargeFontSize = 18.0;
  static const double titleFontSize = 20.0;
  static const double headlineFontSize = 24.0;
  
  // Grid Constants
  static const int gridCrossAxisCount = 2;
  static const double gridChildAspectRatio = 0.85;
  static const double gridSpacing = 16.0;
  
  // Card Constants
  static const double cardElevation = 4.0;
  static const double cardBorderRadius = 12.0;
  
  // Button Constants
  static const double buttonHeight = 48.0;
  static const double buttonBorderRadius = 8.0;
  
  // Progress Constants
  static const double progressBarHeight = 4.0;
  static const double circularProgressSize = 24.0;
  
  // Image Constants
  static const double avatarRadius = 24.0;
  static const double largeAvatarRadius = 48.0;
  
  // Breakpoints
  static const double mobileBreakpoint = 600.0;
  static const double tabletBreakpoint = 900.0;
  static const double desktopBreakpoint = 1200.0;
  
  // API Constants
  static const int apiTimeoutSeconds = 30;
  static const int maxRetryAttempts = 3;
  
  // Cache Constants
  static const Duration cacheExpiration = Duration(hours: 24);
  static const int maxCacheSize = 100;
  
  // User Progress Constants
  static const int maxLevel = 100;
  static const int xpPerLevel = 1000;
  static const int coinsPerLesson = 10;
  static const int xpPerLesson = 50;
  static const int xpPerQuiz = 100;
  
  // Quiz Constants
  static const int defaultQuizTimeLimit = 300; // 5 minutes
  static const double passingScore = 70.0;
  static const int maxQuizAttempts = 3;
  
  // Lesson Constants
  static const int maxSlidesPerLesson = 20;
  static const int estimatedReadingSpeed = 200; // words per minute
  
  // Validation Constants
  static const int minNameLength = 2;
  static const int maxNameLength = 50;
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 128;
  
  // File Paths
  static const String imagesPath = 'assets/images/';
  static const String iconsPath = 'assets/icons/';
  static const String dataPath = 'assets/data/';
  
  // Asset Paths
  static const String logoPath = '${imagesPath}logo.png';
  static const String defaultAvatarPath = '${imagesPath}avatars/default.png';
  static const String pythonLogoPath = '${imagesPath}languages/python.png';
  static const String javascriptLogoPath = '${imagesPath}languages/javascript.png';
  static const String javaLogoPath = '${imagesPath}languages/java.png';
  
  // Colors (as hex strings for consistency)
  static const String primaryColorHex = '#4A90E2';
  static const String secondaryColorHex = '#50C878';
  static const String errorColorHex = '#FF6B6B';
  static const String warningColorHex = '#FFD93D';
  static const String successColorHex = '#6BCF7F';
  
  // Language Codes
  static const String arabicLanguageCode = 'ar';
  static const String englishLanguageCode = 'en';
  
  // Supported Languages
  static const List<String> supportedLanguages = [
    'python',
    'javascript',
    'java',
    'cpp',
    'csharp',
  ];
  
  // Default Values
  static const String defaultLanguage = 'ar';
  static const String defaultTheme = 'light';
  static const bool defaultSoundEnabled = true;
  static const bool defaultNotificationsEnabled = true;
  static const int defaultDailyGoalMinutes = 30;
  
  // Error Messages
  static const String networkErrorMessage = 'خطأ في الاتصال بالإنترنت';
  static const String genericErrorMessage = 'حدث خطأ غير متوقع';
  static const String dataNotFoundMessage = 'البيانات غير موجودة';
  static const String invalidInputMessage = 'البيانات المدخلة غير صحيحة';
  
  // Success Messages
  static const String lessonCompletedMessage = 'تم إكمال الدرس بنجاح!';
  static const String quizPassedMessage = 'مبروك! لقد نجحت في الاختبار';
  static const String profileUpdatedMessage = 'تم تحديث الملف الشخصي';
  
  // Navigation
  static const String homeRoute = '/home';
  static const String profileRoute = '/profile';
  static const String settingsRoute = '/settings';
  static const String courseRoute = '/course';
  static const String lessonRoute = '/lesson';
  static const String quizRoute = '/quiz';
  static const String resultsRoute = '/results';
  
  // SharedPreferences Keys
  static const String userDataKey = 'user_data';
  static const String userProgressKey = 'user_progress';
  static const String settingsKey = 'app_settings';
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'app_language';
  
  // Achievement IDs
  static const String firstLessonAchievement = 'first_lesson_completed';
  static const String fiveLessonsAchievement = 'five_lessons_completed';
  static const String tenLessonsAchievement = 'ten_lessons_completed';
  static const String firstQuizAchievement = 'first_quiz_passed';
  static const String perfectScoreAchievement = 'perfect_quiz_score';
  static const String weekStreakAchievement = 'week_streak';
  
  // Difficulty Levels
  static const String beginnerLevel = 'مبتدئ';
  static const String intermediateLevel = 'متوسط';
  static const String advancedLevel = 'متقدم';
  
  // Content Types
  static const String lessonContentType = 'lesson';
  static const String quizContentType = 'quiz';
  static const String projectContentType = 'project';
  
  // Platform Constants
  static const String androidPlatform = 'android';
  static const String iosPlatform = 'ios';
  static const String webPlatform = 'web';
}
