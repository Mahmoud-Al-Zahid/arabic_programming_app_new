import 'dart:convert';

class JsonValidator {
  // Validate JSON string
  static bool isValidJson(String jsonString) {
    if (jsonString.isEmpty) return false;
    
    try {
      jsonDecode(jsonString);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Validate and parse JSON
  static dynamic parseJson(String jsonString) {
    try {
      return jsonDecode(jsonString);
    } catch (e) {
      print('Error parsing JSON: $e');
      return null;
    }
  }

  // Validate language JSON structure
  static bool isValidLanguageJson(Map<String, dynamic> json) {
    try {
      final requiredFields = ['id', 'name', 'description', 'icon', 'color'];
      
      for (final field in requiredFields) {
        if (!json.containsKey(field) || json[field] == null) {
          return false;
        }
      }
      
      // Validate specific field types
      if (json['id'] is! String || (json['id'] as String).isEmpty) return false;
      if (json['name'] is! String || (json['name'] as String).isEmpty) return false;
      if (json['description'] is! String) return false;
      if (json['icon'] is! String) return false;
      if (json['color'] is! String) return false;
      
      return true;
    } catch (e) {
      return false;
    }
  }

  // Validate course JSON structure
  static bool isValidCourseJson(Map<String, dynamic> json) {
    try {
      final requiredFields = ['languageId', 'languageName', 'levels'];
      
      for (final field in requiredFields) {
        if (!json.containsKey(field) || json[field] == null) {
          return false;
        }
      }
      
      // Validate field types
      if (json['languageId'] is! String || (json['languageId'] as String).isEmpty) return false;
      if (json['languageName'] is! String || (json['languageName'] as String).isEmpty) return false;
      if (json['levels'] is! List) return false;
      
      // Validate levels
      final levels = json['levels'] as List;
      for (final level in levels) {
        if (!isValidLevelJson(level as Map<String, dynamic>)) {
          return false;
        }
      }
      
      return true;
    } catch (e) {
      return false;
    }
  }

  // Validate level JSON structure
  static bool isValidLevelJson(Map<String, dynamic> json) {
    try {
      final requiredFields = ['levelId', 'levelName', 'lessons'];
      
      for (final field in requiredFields) {
        if (!json.containsKey(field) || json[field] == null) {
          return false;
        }
      }
      
      // Validate field types
      if (json['levelId'] is! String || (json['levelId'] as String).isEmpty) return false;
      if (json['levelName'] is! String || (json['levelName'] as String).isEmpty) return false;
      if (json['lessons'] is! List) return false;
      
      // Validate lessons
      final lessons = json['lessons'] as List;
      for (final lesson in lessons) {
        if (!isValidLessonJson(lesson as Map<String, dynamic>)) {
          return false;
        }
      }
      
      return true;
    } catch (e) {
      return false;
    }
  }

  // Validate lesson JSON structure
  static bool isValidLessonJson(Map<String, dynamic> json) {
    try {
      final requiredFields = ['lessonId', 'lessonTitle', 'description'];
      
      for (final field in requiredFields) {
        if (!json.containsKey(field) || json[field] == null) {
          return false;
        }
      }
      
      // Validate field types
      if (json['lessonId'] is! String || (json['lessonId'] as String).isEmpty) return false;
      if (json['lessonTitle'] is! String || (json['lessonTitle'] as String).isEmpty) return false;
      if (json['description'] is! String) return false;
      
      // Validate optional fields
      if (json.containsKey('estimatedMinutes') && json['estimatedMinutes'] is! int) return false;
      if (json.containsKey('difficulty') && json['difficulty'] is! String) return false;
      if (json.containsKey('order') && json['order'] is! int) return false;
      
      return true;
    } catch (e) {
      return false;
    }
  }

  // Validate quiz JSON structure
  static bool isValidQuizJson(Map<String, dynamic> json) {
    try {
      final requiredFields = ['quizId', 'title', 'questions'];
      
      for (final field in requiredFields) {
        if (!json.containsKey(field) || json[field] == null) {
          return false;
        }
      }
      
      // Validate field types
      if (json['quizId'] is! String || (json['quizId'] as String).isEmpty) return false;
      if (json['title'] is! String || (json['title'] as String).isEmpty) return false;
      if (json['questions'] is! List) return false;
      
      // Validate questions
      final questions = json['questions'] as List;
      if (questions.isEmpty) return false;
      
      for (final question in questions) {
        if (!isValidQuestionJson(question as Map<String, dynamic>)) {
          return false;
        }
      }
      
      return true;
    } catch (e) {
      return false;
    }
  }

  // Validate question JSON structure
  static bool isValidQuestionJson(Map<String, dynamic> json) {
    try {
      final requiredFields = ['questionId', 'questionText', 'options', 'correctAnswer'];
      
      for (final field in requiredFields) {
        if (!json.containsKey(field) || json[field] == null) {
          return false;
        }
      }
      
      // Validate field types
      if (json['questionId'] is! String || (json['questionId'] as String).isEmpty) return false;
      if (json['questionText'] is! String || (json['questionText'] as String).isEmpty) return false;
      if (json['options'] is! List) return false;
      if (json['correctAnswer'] is! int) return false;
      
      // Validate options
      final options = json['options'] as List;
      if (options.length < 2) return false;
      
      for (final option in options) {
        if (option is! String || (option as String).isEmpty) {
          return false;
        }
      }
      
      // Validate correct answer index
      final correctAnswer = json['correctAnswer'] as int;
      if (correctAnswer < 0 || correctAnswer >= options.length) {
        return false;
      }
      
      return true;
    } catch (e) {
      return false;
    }
  }

  // Validate user JSON structure
  static bool isValidUserJson(Map<String, dynamic> json) {
    try {
      final requiredFields = ['id', 'name', 'email'];
      
      for (final field in requiredFields) {
        if (!json.containsKey(field) || json[field] == null) {
          return false;
        }
      }
      
      // Validate field types
      if (json['id'] is! String || (json['id'] as String).isEmpty) return false;
      if (json['name'] is! String || (json['name'] as String).isEmpty) return false;
      if (json['email'] is! String || (json['email'] as String).isEmpty) return false;
      
      // Validate optional numeric fields
      if (json.containsKey('level') && json['level'] is! int) return false;
      if (json.containsKey('xp') && json['xp'] is! int) return false;
      if (json.containsKey('coins') && json['coins'] is! int) return false;
      if (json.containsKey('streak') && json['streak'] is! int) return false;
      
      return true;
    } catch (e) {
      return false;
    }
  }

  // Sanitize JSON by removing null values
  static Map<String, dynamic> sanitizeJson(Map<String, dynamic> json) {
    final sanitized = <String, dynamic>{};
    
    for (final entry in json.entries) {
      final key = entry.key;
      final value = entry.value;
      
      if (value != null) {
        if (value is Map<String, dynamic>) {
          sanitized[key] = sanitizeJson(value);
        } else if (value is List) {
          sanitized[key] = value.where((item) => item != null).toList();
        } else {
          sanitized[key] = value;
        }
      }
    }
    
    return sanitized;
  }

  // Get validation errors for JSON
  static List<String> getJsonValidationErrors(Map<String, dynamic> json, String type) {
    final errors = <String>[];
    
    switch (type.toLowerCase()) {
      case 'language':
        if (!isValidLanguageJson(json)) {
          errors.add('Invalid language JSON structure');
        }
        break;
      case 'course':
        if (!isValidCourseJson(json)) {
          errors.add('Invalid course JSON structure');
        }
        break;
      case 'lesson':
        if (!isValidLessonJson(json)) {
          errors.add('Invalid lesson JSON structure');
        }
        break;
      case 'quiz':
        if (!isValidQuizJson(json)) {
          errors.add('Invalid quiz JSON structure');
        }
        break;
      case 'user':
        if (!isValidUserJson(json)) {
          errors.add('Invalid user JSON structure');
        }
        break;
      default:
        errors.add('Unknown JSON type');
    }
    
    return errors;
  }

  // Convert JSON to pretty string
  static String toPrettyJson(dynamic json) {
    try {
      const encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(json);
    } catch (e) {
      return json.toString();
    }
  }
}
