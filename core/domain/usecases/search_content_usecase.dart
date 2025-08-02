import '../repositories/course_repository_interface.dart';

class SearchContentUseCase {
  final CourseRepositoryInterface repository;

  SearchContentUseCase(this.repository);

  Future<List<dynamic>> execute({
    required String query,
    String? languageId,
  }) async {
    try {
      if (query.isEmpty || query.trim().length < 2) {
        return [];
      }

      return await repository.searchContent(
        query.trim(),
        languageId: languageId,
      );
    } catch (e) {
      print('Error in SearchContentUseCase: $e');
      return [];
    }
  }
}
