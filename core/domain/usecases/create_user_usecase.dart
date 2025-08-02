import '../entities/user_entity.dart';
import '../repositories/progress_repository_interface.dart';

class CreateUserUseCase {
  final ProgressRepositoryInterface repository;

  CreateUserUseCase(this.repository);

  Future<UserEntity?> execute({
    required String name,
    required String email,
  }) async {
    try {
      if (name.isEmpty || name.trim().length < 2) {
        throw ArgumentError('Name must be at least 2 characters long');
      }

      if (email.isEmpty || !_isValidEmail(email)) {
        throw ArgumentError('Please provide a valid email address');
      }

      return await repository.createUser(name.trim(), email.trim());
    } catch (e) {
      print('Error in CreateUserUseCase: $e');
      return null;
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
