import '../data/models/track_model.dart';
import '../data/models/lesson_model.dart';
import '../data/models/quiz_model.dart';
import '../data/models/user_model.dart';
import '../data/repositories/python_repository.dart';

class DataService {
  final PythonRepository _repository = PythonRepository();

  // Tracks
  Future<List<Track>> getTracks() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return _repository.getTracks();
  }

  Future<Track?> getTrackById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _repository.getTrackById(id);
  }

  // Lessons
  Future<List<Lesson>> getLessonsByTrackId(String trackId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _repository.getLessonsByTrackId(trackId);
  }

  Future<Lesson?> getLessonById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _repository.getLessonById(id);
  }

  // Quizzes
  Future<List<Quiz>> getQuizzesByLessonId(String lessonId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _repository.getQuizzesByLessonId(lessonId);
  }

  Future<Quiz?> getQuizById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _repository.getQuizById(id);
  }

  // User
  Future<User> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _repository.getCurrentUser();
  }

  Future<void> updateUserProgress(String lessonId, bool completed) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // In a real app, this would update the backend
    print('Updated progress for lesson $lessonId: $completed');
  }

  Future<void> updateUserXP(int xpGained) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // In a real app, this would update the backend
    print('User gained $xpGained XP');
  }
}
