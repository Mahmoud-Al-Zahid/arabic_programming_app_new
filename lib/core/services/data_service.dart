import '../data/models/track_model.dart';
import '../data/models/lesson_model.dart';
import '../data/models/quiz_model.dart';
import '../data/models/user_model.dart';

abstract class DataService {
  // Tracks
  Future<List<Track>> getTracks();
  Future<Track?> getTrackById(String id);
  Future<void> updateTrackProgress(String trackId, double progress);

  // Lessons
  Future<List<Lesson>> getLessonsByTrackId(String trackId);
  Future<Lesson?> getLessonById(String id);
  Future<void> markLessonCompleted(String lessonId);

  // Quizzes
  Future<List<Quiz>> getQuizzesByLessonId(String lessonId);
  Future<Quiz?> getQuizById(String id);
  Future<void> saveQuizResult(String quizId, int score, int totalQuestions);

  // User
  Future<User?> getCurrentUser();
  Future<void> updateUserProgress(String userId, int xpGained, int coinsGained);
  Future<void> updateUserProfile(User user);
}
