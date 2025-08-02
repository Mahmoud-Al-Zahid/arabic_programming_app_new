import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/json_data_service.dart';
import '../services/progress_service.dart';
import '../data/models/language_model.dart';
import '../data/models/course_model.dart';
import '../data/models/lesson_model.dart';
import '../data/models/quiz_model.dart';
import '../data/models/user_model.dart';

// خدمات البيانات
final jsonDataServiceProvider = Provider<JsonDataService>((ref) {
  return JsonDataService();
});

final progressServiceProvider = Provider<ProgressService>((ref) {
  return ProgressService();
});

// قائمة اللغات
final languagesProvider = FutureProvider<List<Language>>((ref) async {
  final service = ref.read(jsonDataServiceProvider);
  return await service.loadLanguages();
});

// كورس معين
final courseProvider = FutureProvider.family<Course?, String>((ref, languageId) async {
  final service = ref.read(jsonDataServiceProvider);
  return await service.loadCourse(languageId);
});

// درس معين
final lessonProvider = FutureProvider.family<Lesson?, LessonParams>((ref, params) async {
  final service = ref.read(jsonDataServiceProvider);
  return await service.loadLesson(params.languageId, params.lessonId);
});

// اختبار درس
final lessonQuizProvider = FutureProvider.family<Quiz?, String>((ref, quizId) async {
  final service = ref.read(jsonDataServiceProvider);
  return await service.loadLessonQuiz(quizId);
});

// اختبار مستوى
final levelQuizProvider = FutureProvider.family<Quiz?, String>((ref, quizFileName) async {
  final service = ref.read(jsonDataServiceProvider);
  return await service.loadLevelQuiz(quizFileName);
});

// بيانات المستخدم
final userProvider = StateNotifierProvider<UserNotifier, AsyncValue<User?>>((ref) {
  return UserNotifier(ref.read(progressServiceProvider));
});

// اللغة المختارة حالياً
final selectedLanguageProvider = StateProvider<String?>((ref) => null);

// المستوى المختار حالياً
final selectedLevelProvider = StateProvider<String?>((ref) => null);

// الدرس المختار حالياً
final selectedLessonProvider = StateProvider<String?>((ref) => null);

// حالة التحميل
final loadingStateProvider = StateProvider<bool>((ref) => false);

// رسائل الأخطاء
final errorMessageProvider = StateProvider<String?>((ref) => null);

// فئة لتمرير معاملات الدرس
class LessonParams {
  final String languageId;
  final String lessonId;

  const LessonParams({
    required this.languageId,
    required this.lessonId,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LessonParams &&
          runtimeType == other.runtimeType &&
          languageId == other.languageId &&
          lessonId == other.lessonId;

  @override
  int get hashCode => languageId.hashCode ^ lessonId.hashCode;
}

// مدير حالة المستخدم
class UserNotifier extends StateNotifier<AsyncValue<User?>> {
  final ProgressService _progressService;

  UserNotifier(this._progressService) : super(const AsyncValue.loading()) {
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      final user = await _progressService.loadUserProgress();
      state = AsyncValue.data(user);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> createUser(String name, String email) async {
    try {
      state = const AsyncValue.loading();
      final user = await _progressService.createNewUser(name, email);
      state = AsyncValue.data(user);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateUser(User user) async {
    try {
      await _progressService.saveUserProgress(user);
      state = AsyncValue.data(user);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> completeLesson(
    String languageId,
    String lessonId,
    int timeSpent,
  ) async {
    final currentUser = state.value;
    if (currentUser != null) {
      try {
        await _progressService.completeLesson(
          currentUser.id,
          languageId,
          lessonId,
          timeSpent,
        );
        await _loadUser(); // إعادة تحميل البيانات
      } catch (error, stackTrace) {
        state = AsyncValue.error(error, stackTrace);
      }
    }
  }

  Future<void> completeQuiz(
    String languageId,
    String quizId,
    QuizResult quizResult,
  ) async {
    final currentUser = state.value;
    if (currentUser != null) {
      try {
        await _progressService.completeQuiz(
          currentUser.id,
          languageId,
          quizId,
          quizResult,
        );
        await _loadUser(); // إعادة تحميل البيانات
      } catch (error, stackTrace) {
        state = AsyncValue.error(error, stackTrace);
      }
    }
  }

  bool canAccessLesson(String languageId, String lessonId, int lessonOrder) {
    final user = state.value;
    if (user == null) return false;
    
    return _progressService.canAccessLesson(user, languageId, lessonId, lessonOrder);
  }

  bool canAccessLevel(String languageId, String levelId, int levelOrder) {
    final user = state.value;
    if (user == null) return false;
    
    return _progressService.canAccessLevel(user, languageId, levelId, levelOrder);
  }

  Future<void> clearAllData() async {
    try {
      await _progressService.clearAllData();
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

// Provider للتحقق من إمكانية الوصول للدروس
final lessonAccessProvider = Provider.family<bool, LessonAccessParams>((ref, params) {
  final userAsync = ref.watch(userProvider);
  
  return userAsync.when(
    data: (user) {
      if (user == null) return false;
      final progressService = ref.read(progressServiceProvider);
      return progressService.canAccessLesson(
        user,
        params.languageId,
        params.lessonId,
        params.lessonOrder,
      );
    },
    loading: () => false,
    error: (_, __) => false,
  );
});

// Provider للتحقق من إمكانية الوصول للمستويات
final levelAccessProvider = Provider.family<bool, LevelAccessParams>((ref, params) {
  final userAsync = ref.watch(userProvider);
  
  return userAsync.when(
    data: (user) {
      if (user == null) return false;
      final progressService = ref.read(progressServiceProvider);
      return progressService.canAccessLevel(
        user,
        params.languageId,
        params.levelId,
        params.levelOrder,
      );
    },
    loading: () => false,
    error: (_, __) => false,
  );
});

// فئات لمعاملات التحقق من الوصول
class LessonAccessParams {
  final String languageId;
  final String lessonId;
  final int lessonOrder;

  const LessonAccessParams({
    required this.languageId,
    required this.lessonId,
    required this.lessonOrder,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LessonAccessParams &&
          runtimeType == other.runtimeType &&
          languageId == other.languageId &&
          lessonId == other.lessonId &&
          lessonOrder == other.lessonOrder;

  @override
  int get hashCode => languageId.hashCode ^ lessonId.hashCode ^ lessonOrder.hashCode;
}

class LevelAccessParams {
  final String languageId;
  final String levelId;
  final int levelOrder;

  const LevelAccessParams({
    required this.languageId,
    required this.levelId,
    required this.levelOrder,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LevelAccessParams &&
          runtimeType == other.runtimeType &&
          languageId == other.languageId &&
          levelId == other.levelId &&
          levelOrder == other.levelOrder;

  @override
  int get hashCode => languageId.hashCode ^ levelId.hashCode ^ levelOrder.hashCode;
}
