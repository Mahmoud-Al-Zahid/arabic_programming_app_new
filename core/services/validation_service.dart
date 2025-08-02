import 'dart:convert';

class ValidationService {
  // Email validation
  static bool isValidEmail(String email) {
    final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  // Name validation
  static bool isValidName(String name) {
    return name.trim().length >= 2;
  }

  // Password validation
  static bool isValidPassword(String password) {
    // At least 6 characters
    return password.length >= 6;
  }

  // Quiz score validation
  static bool isValidQuizScore(double score) {
    return score >= 0 && score <= 100;
  }

  // Time validation (in seconds)
  static bool isValidTimeSpent(int timeSpent) {
    return timeSpent >= 0 && timeSpent <= 86400; // Max 24 hours
  }

  // Language ID validation
  static bool isValidLanguageId(String languageId) {
    if (languageId.isEmpty) return false;
    
    final validLanguages = ['python', 'javascript', 'java', 'cpp', 'csharp'];
    return validLanguages.contains(languageId.toLowerCase());
  }

  // Lesson ID validation
  static bool isValidLessonId(String lessonId) {
    if (lessonId.isEmpty) return false;
    
    // Should be alphanumeric with underscores
    final lessonRegex = RegExp(r'^[a-zA-Z0-9_]+$');
    return lessonRegex.hasMatch(lessonId) && lessonId.length <= 50;
  }

  // Quiz ID validation
  static bool isValidQuizId(String quizId) {
    if (quizId.isEmpty) return false;
    
    // Should be alphanumeric with underscores
    final quizRegex = RegExp(r'^[a-zA-Z0-9_]+$');
    return quizRegex.hasMatch(quizId) && quizId.length <= 50;
  }

  // User ID validation
  static bool isValidUserId(String userId) {
    if (userId.isEmpty) return false;
    
    // Should be alphanumeric with hyphens (UUID format)
    final userIdRegex = RegExp(r'^[a-zA-Z0-9\-]+$');
    return userIdRegex.hasMatch(userId) && userId.length >= 10;
  }

  // JSON validation
  static bool isValidJson(String jsonString) {
    if (jsonString.isEmpty) return false;
    
    try {
      final decoded = jsonDecode(jsonString);
      return decoded != null;
    } catch (e) {
      return false;
    }
  }

  // URL validation
  static bool isValidUrl(String url) {
    if (url.isEmpty) return false;
    
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }

  // Phone number validation (basic)
  static bool isValidPhoneNumber(String phoneNumber) {
    if (phoneNumber.isEmpty) return false;
    
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'[\s\-$$$$]'), '');
    final phoneRegex = RegExp(r'^\+?[1-9]\d{1,14}$');
    
    return phoneRegex.hasMatch(cleanNumber);
  }

  // Age validation
  static bool isValidAge(int age) {
    return age >= 5 && age <= 120;
  }

  // Level validation
  static bool isValidLevel(int level) {
    return level >= 1 && level <= 100;
  }

  // XP validation
  static bool isValidXP(int xp) {
    return xp >= 0 && xp <= 1000000;
  }

  // Coins validation
  static bool isValidCoins(int coins) {
    return coins >= 0 && coins <= 1000000;
  }

  // Streak validation
  static bool isValidStreak(int streak) {
    return streak >= 0 && streak <= 10000;
  }

  // File path validation
  static bool isValidFilePath(String filePath) {
    if (filePath.isEmpty) return false;
    
    // Basic file path validation
    final pathRegex = RegExp(r'^[a-zA-Z0-9\/_\-\.]+$');
    return pathRegex.hasMatch(filePath) && !filePath.contains('..');
  }

  // Sanitize input string
  static String sanitizeInput(String input) {
    return input.trim().replaceAll(RegExp(r'[<>"\']'), '');
  }

  // Validate and sanitize name
  static String? validateAndSanitizeName(String name) {
    final sanitized = sanitizeInput(name);
    return isValidName(sanitized) ? sanitized : null;
  }

  // Validate and sanitize email
  static String? validateAndSanitizeEmail(String email) {
    final sanitized = sanitizeInput(email).toLowerCase();
    return isValidEmail(sanitized) ? sanitized : null;
  }

  // Validate email
  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'البريد الإلكتروني مطلوب';
    }
    if (!isValidEmail(email)) {
      return 'البريد الإلكتروني غير صحيح';
    }
    return null;
  }

  // Validate name
  static String? validateName(String? name) {
    if (name == null || name.isEmpty) {
      return 'الاسم مطلوب';
    }
    if (!isValidName(name)) {
      return 'الاسم يجب أن يكون أكثر من حرفين';
    }
    return null;
  }

  // Validate password
  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'كلمة المرور مطلوبة';
    }
    if (!isValidPassword(password)) {
      return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
    }
    return null;
  }

  // Validate confirm password
  static String? validateConfirmPassword(String? password, String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'تأكيد كلمة المرور مطلوب';
    }
    if (password != confirmPassword) {
      return 'كلمات المرور غير متطابقة';
    }
    return null;
  }

  // Get validation error message
  static String getValidationErrorMessage(String field, String value) {
    switch (field.toLowerCase()) {
      case 'email':
        if (value.isEmpty) return 'البريد الإلكتروني مطلوب';
        if (!isValidEmail(value)) return 'البريد الإلكتروني غير صحيح';
        break;
      case 'name':
        if (value.isEmpty) return 'الاسم مطلوب';
        if (!isValidName(value)) return 'الاسم يجب أن يكون أكثر من حرفين';
        break;
      case 'password':
        if (value.isEmpty) return 'كلمة المرور مطلوبة';
        if (!isValidPassword(value)) return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
        break;
      default:
        return 'قيمة غير صحيحة';
    }
    return '';
  }

  // Batch validation
  static Map<String, String> validateFields(Map<String, String> fields) {
    final errors = <String, String>{};
    
    for (final entry in fields.entries) {
      final field = entry.key;
      final value = entry.value;
      final error = getValidationErrorMessage(field, value);
      
      if (error.isNotEmpty) {
        errors[field] = error;
      }
    }
    
    return errors;
  }

  // Validate quiz answer
  static bool isValidQuizAnswer(dynamic answer) {
    return answer != null;
  }

  // Validate lesson completion
  static bool isLessonCompleted(Map<String, dynamic> progress, String lessonId) {
    final completedLessons = progress['completedLessons'] as List<dynamic>? ?? [];
    return completedLessons.contains(lessonId);
  }

  // Validate quiz score
  static bool isQuizPassed(int score, int totalQuestions) {
    final percentage = (score / totalQuestions) * 100;
    return percentage >= 70; // 70% passing grade
  }

  // Validate lesson access
  static bool canAccessLesson(Map<String, dynamic> progress, String lessonId, List<String> prerequisites) {
    if (prerequisites.isEmpty) return true;
    
    final completedLessons = progress['completedLessons'] as List<dynamic>? ?? [];
    return prerequisites.every((prereq) => completedLessons.contains(prereq));
  }

  // Validate JSON structure
  static bool isValidJsonStructure(Map<String, dynamic> json, List<String> requiredKeys) {
    return requiredKeys.every((key) => json.containsKey(key));
  }

  // Validate user level
  static int calculateUserLevel(int xp) {
    if (xp < 100) return 1;
    if (xp < 300) return 2;
    if (xp < 600) return 3;
    if (xp < 1000) return 4;
    if (xp < 1500) return 5;
    return 6; // Max level
  }

  // Validate achievement unlock
  static List<String> checkUnlockedAchievements(Map<String, dynamic> progress) {
    final achievements = <String>[];
    final completedLessons = progress['completedLessons'] as List<dynamic>? ?? [];
    final xp = progress['xp'] as int? ?? 0;

    // First lesson achievement
    if (completedLessons.isNotEmpty) {
      achievements.add('first_lesson');
    }

    // Complete 5 lessons
    if (completedLessons.length >= 5) {
      achievements.add('lesson_master');
    }

    // Reach level 3
    if (calculateUserLevel(xp) >= 3) {
      achievements.add('level_up');
    }

    return achievements;
  }

  // Username validation
  static bool isValidUsername(String username) {
    // At least 3 characters, alphanumeric and underscores only
    final usernameRegex = RegExp(r'^[a-zA-Z0-9_]{3,}$');
    return usernameRegex.hasMatch(username);
  }

  // Validate user input
  static String? validateUserInput(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'يرجى إدخال $fieldName';
    }
    
    if (fieldName == 'البريد الإلكتروني' && !isValidEmail(value)) {
      return 'يرجى إدخال بريد إلكتروني صحيح';
    }
    
    if (fieldName == 'الاسم' && !isValidName(value)) {
      return 'يجب أن يكون الاسم أكثر من حرفين';
    }
    
    if (fieldName == 'كلمة المرور' && !isValidPassword(value)) {
      return 'يجب أن تكون كلمة المرور 6 أحرف على الأقل';
    }
    
    return null;
  }

  // Validate course completion
  static bool isCourseCompleted(List<String> completedLessons, int totalLessons) {
    return completedLessons.length >= totalLessons;
  }
}
