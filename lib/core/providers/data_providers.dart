import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/track_model.dart';
import '../data/models/lesson_model.dart';
import '../data/models/quiz_model.dart';
import '../data/models/user_model.dart';
import '../services/data_service.dart';
import '../services/mock_data_service.dart';

// Service Provider
final dataServiceProvider = Provider<DataService>((ref) {
  return MockDataService();
});

// User Providers
final currentUserProvider = FutureProvider<User?>((ref) async {
  final dataService = ref.read(dataServiceProvider);
  return await dataService.getCurrentUser();
});

final userProgressProvider = StateNotifierProvider<UserProgressNotifier, UserProgress>((ref) {
  return UserProgressNotifier(ref.read(dataServiceProvider));
});

// Track Providers
final tracksProvider = FutureProvider<List<Track>>((ref) async {
  final dataService = ref.read(dataServiceProvider);
  return await dataService.getTracks();
});

final trackProvider = FutureProvider.family<Track?, String>((ref, trackId) async {
  final dataService = ref.read(dataServiceProvider);
  return await dataService.getTrackById(trackId);
});

// Lesson Providers
final lessonsProvider = FutureProvider.family<List<Lesson>, String>((ref, trackId) async {
  final dataService = ref.read(dataServiceProvider);
  return await dataService.getLessonsByTrackId(trackId);
});

final lessonProvider = FutureProvider.family<Lesson?, String>((ref, lessonId) async {
  final dataService = ref.read(dataServiceProvider);
  return await dataService.getLessonById(lessonId);
});

// Quiz Providers
final quizzesProvider = FutureProvider.family<List<Quiz>, String>((ref, lessonId) async {
  final dataService = ref.read(dataServiceProvider);
  return await dataService.getQuizzesByLessonId(lessonId);
});

final quizProvider = FutureProvider.family<Quiz?, String>((ref, quizId) async {
  final dataService = ref.read(dataServiceProvider);
  return await dataService.getQuizById(quizId);
});

// State Notifiers
class UserProgress {
  final int xp;
  final int coins;
  final int level;

  const UserProgress({
    required this.xp,
    required this.coins,
    required this.level,
  });

  UserProgress copyWith({
    int? xp,
    int? coins,
    int? level,
  }) {
    return UserProgress(
      xp: xp ?? this.xp,
      coins: coins ?? this.coins,
      level: level ?? this.level,
    );
  }
}

class UserProgressNotifier extends StateNotifier<UserProgress> {
  final DataService _dataService;

  UserProgressNotifier(this._dataService) : super(const UserProgress(xp: 0, coins: 0, level: 1)) {
    _loadUserProgress();
  }

  Future<void> _loadUserProgress() async {
    final user = await _dataService.getCurrentUser();
    if (user != null) {
      state = UserProgress(
        xp: user.xp,
        coins: user.coins,
        level: user.level,
      );
    }
  }

  Future<void> addProgress(int xpGained, int coinsGained) async {
    final user = await _dataService.getCurrentUser();
    if (user != null) {
      await _dataService.updateUserProgress(user.id, xpGained, coinsGained);
      
      final newXp = state.xp + xpGained;
      final newCoins = state.coins + coinsGained;
      final newLevel = newXp ~/ 500 + 1;
      
      state = UserProgress(
        xp: newXp,
        coins: newCoins,
        level: newLevel,
      );
    }
  }
}

// Loading State Provider
final appLoadingProvider = StateProvider<bool>((ref) => false);

// Error Provider
final appErrorProvider = StateProvider<String?>((ref) => null);
