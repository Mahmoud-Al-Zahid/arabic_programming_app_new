class ValidationService {
  // Email validation
  static bool isValidEmail(String email) {
    if (email.isEmpty) return false;
    
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    );
    
    return emailRegex.hasMatch(email.trim());
  }

  // Name validation
  static bool isValidName(String name) {
    if (name.isEmpty) return false;
    
    final trimmedName = name.trim();
    if (trimmedName.length < 2 || trimmedName.length > 50) return false;
    
    // Check for valid characters (letters, spaces, hyphens, apostrophes)
    final nameRegex = RegExp(r"^[a-zA-Z\u0600-\u06FF\s\-']+$");
    return nameRegex.hasMatch(trimmedName);
  }

  // Password validation
  static bool isValidPassword(String password) {
    if (password.isEmpty) return false;
    
    // At least 8 characters, contains letters and numbers
    if (password.length < 8) return false;
    
    final hasLetter = RegExp(r'[a-zA-Z]').hasMatch(password);
    final hasNumber = RegExp(r'[0-9]').hasMatch(password);
    
    return hasLetter && hasNumber;
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

  // Get validation error message
  static String getValidationErrorMessage(String field, String value) {
    switch (field.toLowerCase()) {
      case 'email':
        if (value.isEmpty) return 'البريد الإلكتروني مطلوب';
        if (!isValidEmail(value)) return 'البريد الإلكتروني غير صحيح';
        break;
      case 'name':
        if (value.isEmpty) return 'الاسم مطلوب';
        if (!isValidName(value)) return 'الاسم يجب أن يكون بين 2-50 حرف';
        break;
      case 'password':
        if (value.isEmpty) return 'كلمة المرور مطلوبة';
        if (!isValidPassword(value)) return 'كلمة المرور يجب أن تكون 8 أحرف على الأقل وتحتوي على أرقام وحروف';
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
}
