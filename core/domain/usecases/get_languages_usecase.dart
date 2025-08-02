import '../entities/language_entity.dart';
import '../repositories/course_repository_interface.dart';

class GetLanguagesUseCase {
  final CourseRepositoryInterface repository;

  GetLanguagesUseCase(this.repository);

  Future<List<LanguageEntity>> execute({
    String? difficulty,
    bool? popularOnly,
  }) async {
    try {
      List<LanguageEntity> languages;

      if (popularOnly == true) {
        languages = await repository.getPopularLanguages();
      } else if (difficulty != null) {
        languages = await repository.getLanguagesByDifficulty(difficulty);
      } else {
        languages = await repository.getLanguages();
      }

      // Sort languages by popularity and then by name
      languages.sort((a, b) {
        if (a.isPopular && !b.isPopular) return -1;
        if (!a.isPopular && b.isPopular) return 1;
        return a.name.compareTo(b.name);
      });

      return languages;
    } catch (e) {
      print('Error in GetLanguagesUseCase: $e');
      return [];
    }
  }

  Future<LanguageEntity?> getLanguageById(String languageId) async {
    try {
      if (languageId.isEmpty) {
        throw ArgumentError('Language ID cannot be empty');
      }

      return await repository.getLanguage(languageId);
    } catch (e) {
      print('Error in GetLanguagesUseCase.getLanguageById: $e');
      return null;
    }
  }

  Future<bool> isLanguageAvailable(String languageId) async {
    try {
      return await repository.languageExists(languageId);
    } catch (e) {
      print('Error in GetLanguagesUseCase.isLanguageAvailable: $e');
      return false;
    }
  }

  Future<List<LanguageEntity>> getRecommendedLanguages({
    String? userLevel,
    List<String>? completedLanguages,
  }) async {
    try {
      final allLanguages = await repository.getLanguages();
      
      // Filter out completed languages
      List<LanguageEntity> availableLanguages = allLanguages;
      if (completedLanguages != null && completedLanguages.isNotEmpty) {
        availableLanguages = allLanguages
            .where((lang) => !completedLanguages.contains(lang.id))
            .toList();
      }

      // Recommend based on user level
      if (userLevel != null) {
        switch (userLevel.toLowerCase()) {
          case 'beginner':
            availableLanguages = availableLanguages
                .where((lang) => lang.difficulty == 'مبتدئ')
                .toList();
            break;
          case 'intermediate':
            availableLanguages = availableLanguages
                .where((lang) => ['مبتدئ', 'متوسط'].contains(lang.difficulty))
                .toList();
            break;
          case 'advanced':
            // All languages are available for advanced users
            break;
        }
      }

      // Prioritize popular languages
      availableLanguages.sort((a, b) {
        if (a.isPopular && !b.isPopular) return -1;
        if (!a.isPopular && b.isPopular) return 1;
        return a.estimatedHours.compareTo(b.estimatedHours);
      });

      // Return top 5 recommendations
      return availableLanguages.take(5).toList();
    } catch (e) {
      print('Error in GetLanguagesUseCase.getRecommendedLanguages: $e');
      return [];
    }
  }

  Future<Map<String, int>> getLanguageStatistics() async {
    try {
      final languages = await repository.getLanguages();
      
      final stats = <String, int>{
        'total': languages.length,
        'popular': languages.where((lang) => lang.isPopular).length,
        'beginner': languages.where((lang) => lang.difficulty == 'مبتدئ').length,
        'intermediate': languages.where((lang) => lang.difficulty == 'متوسط').length,
        'advanced': languages.where((lang) => lang.difficulty == 'متقدم').length,
      };

      return stats;
    } catch (e) {
      print('Error in GetLanguagesUseCase.getLanguageStatistics: $e');
      return {};
    }
  }
}
