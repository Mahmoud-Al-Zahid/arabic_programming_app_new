import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/data_service.dart';
import '../data/models/track_model.dart';
import '../data/models/lesson_model.dart';
import '../data/models/quiz_model.dart';
import '../data/models/user_model.dart';

// Service Provider
final dataServiceProvider = Provider<DataService>((ref) {
  return DataService();
});

// User Provider
final currentUserProvider = FutureProvider<User>((ref) async {
  final dataService = ref.read(dataServiceProvider);
  return await dataService.getCurrentUser();
});

// Tracks Provider
final tracksProvider = FutureProvider<List<Track>>((ref) async {
  final dataService = ref.read(dataServiceProvider);
  return await dataService.getTracks();
});

// Track by ID Provider
final trackByIdProvider = FutureProvider.family<Track?, String>((ref, trackId) async {
  final dataService = ref.read(dataServiceProvider);
  return await dataService.getTrackById(trackId);
});

// Lessons by Track ID Provider
final lessonsByTrackIdProvider = FutureProvider.family<List<Lesson>, String>((ref, trackId) async {
  final dataService = ref.read(dataServiceProvider);
  return await dataService.getLessonsByTrackId(trackId);
});

// Lesson by ID Provider
final lessonByIdProvider = FutureProvider.family<Lesson?, String>((ref, lessonId) async {
  final dataService = ref.read(dataServiceProvider);
  return await dataService.getLessonById(lessonId);
});

// Quizzes by Lesson ID Provider
final quizzesByLessonIdProvider = FutureProvider.family<List<Quiz>, String>((ref, lessonId) async {
  final dataService = ref.read(dataServiceProvider);
  return await dataService.getQuizzesByLessonId(lessonId);
});

// Quiz by ID Provider
final quizByIdProvider = FutureProvider.family<Quiz?, String>((ref, quizId) async {
  final dataService = ref.read(dataServiceProvider);
  return await dataService.getQuizById(quizId);
});

// User Progress Provider
final userProgressProvider = StateNotifierProvider<UserProgressNotifier, Map<String, bool>>((ref) {
  return UserProgressNotifier();
});

class UserProgressNotifier extends StateNotifier<Map<String, bool>> {
  UserProgressNotifier() : super({});

  void updateLessonProgress(String lessonId, bool completed) {
    state = {
      ...state,
      lessonId: completed,
    };
  }

  bool isLessonCompleted(String lessonId) {
    return state[lessonId] ?? false;
  }
}
