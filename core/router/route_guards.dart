import 'package:flutter/material.dart';
import '../domain/entities/user_entity.dart';
import '../domain/repositories/progress_repository_interface.dart';
import '../services/validation_service.dart';

class RouteGuards {
  final ProgressRepositoryInterface _progressRepository;

  RouteGuards(this._progressRepository);

  // Check if user is authenticated
  Future<bool> isAuthenticated() async {
    try {
      final user = await _progressRepository.getCurrentUser();
      return user != null;
    } catch (e) {
      print('Error checking authentication: $e');
      return false;
    }
  }

  // Check if user can access a specific lesson
  Future<bool> canAccessLesson({
    required String languageId,
    required String lessonId,
    required int lessonOrder,
  }) async {
    try {
      final user = await _progressRepository.getCurrentUser();
      if (user == null) return false;

      return await _progressRepository.canAccessLesson(
        user.id,
        languageId,
        lessonId,
        lessonOrder,
      );
    } catch (e) {
      print('Error checking lesson access: $e');
      return false;
    }
  }

  // Check if user can access a specific course
  Future<bool> canAccessCourse(String languageId) async {
    try {
      if (!ValidationService.isValidLanguageId(languageId)) {
        return false;
      }

      final user = await _progressRepository.getCurrentUser();
      if (user == null) return false;

      // Basic course access - can be extended with premium features, level requirements, etc.
      return true;
    } catch (e) {
      print('Error checking course access: $e');
      return false;
    }
  }

  // Check if user can access quiz
  Future<bool> canAccessQuiz({
    required String languageId,
    required String quizId,
    required String? associatedLessonId,
  }) async {
    try {
      final user = await _progressRepository.getCurrentUser();
      if (user == null) return false;

      // If quiz is associated with a lesson, check if lesson is completed
      if (associatedLessonId != null) {
        final isLessonCompleted = await _progressRepository.isLessonCompleted(
          user.id,
          languageId,
          associatedLessonId,
        );
        return isLessonCompleted;
      }

      // For level quizzes or standalone quizzes, allow access
      return true;
    } catch (e) {
      print('Error checking quiz access: $e');
      return false;
    }
  }

  // Check if user has minimum level requirement
  Future<bool> hasMinimumLevel(int requiredLevel) async {
    try {
      final user = await _progressRepository.getCurrentUser();
      if (user == null) return false;

      return user.level >= requiredLevel;
    } catch (e) {
      print('Error checking minimum level: $e');
      return false;
    }
  }

  // Check if user has minimum XP requirement
  Future<bool> hasMinimumXP(int requiredXP) async {
    try {
      final user = await _progressRepository.getCurrentUser();
      if (user == null) return false;

      return user.xp >= requiredXP;
    } catch (e) {
      print('Error checking minimum XP: $e');
      return false;
    }
  }

  // Check if user has specific achievement
  Future<bool> hasAchievement(String achievementId) async {
    try {
      final user = await _progressRepository.getCurrentUser();
      if (user == null) return false;

      return user.achievements.contains(achievementId);
    } catch (e) {
      print('Error checking achievement: $e');
      return false;
    }
  }

  // Check if user has completed a specific language
  Future<bool> hasCompletedLanguage(String languageId) async {
    try {
      final user = await _progressRepository.getCurrentUser();
      if (user == null) return false;

      final languageProgress = user.progress.languages[languageId];
      return languageProgress?.isCompleted ?? false;
    } catch (e) {
      print('Error checking language completion: $e');
      return false;
    }
  }

  // Check if user has premium access
  Future<bool> hasPremiumAccess() async {
    try {
      final user = await _progressRepository.getCurrentUser();
      if (user == null) return false;

      // This would be implemented based on your premium system
      // For now, return true for all users
      return true;
    } catch (e) {
      print('Error checking premium access: $e');
      return false;
    }
  }

  // Get redirect route based on user state
  Future<String> getRedirectRoute() async {
    try {
      final isAuth = await isAuthenticated();
      
      if (!isAuth) {
        return '/onboarding';
      }

      final user = await _progressRepository.getCurrentUser();
      if (user == null) {
        return '/onboarding';
      }

      // If user has no progress, redirect to language selection
      if (user.progress.languages.isEmpty) {
        return '/languages';
      }

      // If user has current language, redirect to course
      if (user.progress.currentLanguage.isNotEmpty) {
        return '/course/${user.progress.currentLanguage}';
      }

      // Default to home
      return '/home';
    } catch (e) {
      print('Error getting redirect route: $e');
      return '/onboarding';
    }
  }

  // Route guard middleware
  Future<bool> guardRoute({
    required String route,
    Map<String, dynamic>? parameters,
  }) async {
    try {
      // Extract route components
      final routeParts = route.split('/');
      
      switch (routeParts[1]) {
        case 'onboarding':
        case 'registration':
          // These routes are always accessible
          return true;

        case 'home':
        case 'profile':
        case 'settings':
          // Require authentication
          return await isAuthenticated();

        case 'course':
          if (routeParts.length > 2) {
            final languageId = routeParts[2];
            return await canAccessCourse(languageId);
          }
          return await isAuthenticated();

        case 'lesson':
          if (routeParts.length > 3 && parameters != null) {
            final languageId = routeParts[2];
            final lessonId = routeParts[3];
            final lessonOrder = parameters['order'] as int? ?? 1;
            
            return await canAccessLesson(
              languageId: languageId,
              lessonId: lessonId,
              lessonOrder: lessonOrder,
            );
          }
          return false;

        case 'quiz':
          if (routeParts.length > 3 && parameters != null) {
            final languageId = routeParts[2];
            final quizId = routeParts[3];
            final associatedLessonId = parameters['lessonId'] as String?;
            
            return await canAccessQuiz(
              languageId: languageId,
              quizId: quizId,
              associatedLessonId: associatedLessonId,
            );
          }
          return false;

        case 'premium':
          // Check premium access
          return await hasPremiumAccess();

        case 'achievements':
          // Require minimum level
          return await hasMinimumLevel(5);

        case 'leaderboard':
          // Require specific achievement
          return await hasAchievement('first_quiz_passed');

        default:
          // Unknown route, require authentication
          return await isAuthenticated();
      }
    } catch (e) {
      print('Error guarding route: $e');
      return false;
    }
  }

  // Get access requirements for a route
  Future<Map<String, dynamic>> getRouteRequirements(String route) async {
    try {
      final routeParts = route.split('/');
      final requirements = <String, dynamic>{
        'requiresAuth': false,
        'minimumLevel': null,
        'minimumXP': null,
        'requiredAchievements': <String>[],
        'requiresPremium': false,
        'customRequirements': <String, dynamic>{},
      };

      switch (routeParts[1]) {
        case 'onboarding':
        case 'registration':
          // No requirements
          break;

        case 'home':
        case 'profile':
        case 'settings':
          requirements['requiresAuth'] = true;
          break;

        case 'course':
          requirements['requiresAuth'] = true;
          break;

        case 'lesson':
          requirements['requiresAuth'] = true;
          requirements['customRequirements']['lessonAccess'] = true;
          break;

        case 'quiz':
          requirements['requiresAuth'] = true;
          requirements['customRequirements']['quizAccess'] = true;
          break;

        case 'premium':
          requirements['requiresAuth'] = true;
          requirements['requiresPremium'] = true;
          break;

        case 'achievements':
          requirements['requiresAuth'] = true;
          requirements['minimumLevel'] = 5;
          break;

        case 'leaderboard':
          requirements['requiresAuth'] = true;
          requirements['requiredAchievements'] = ['first_quiz_passed'];
          break;

        default:
          requirements['requiresAuth'] = true;
      }

      return requirements;
    } catch (e) {
      print('Error getting route requirements: $e');
      return {
        'requiresAuth': true,
        'minimumLevel': null,
        'minimumXP': null,
        'requiredAchievements': <String>[],
        'requiresPremium': false,
        'customRequirements': <String, dynamic>{},
      };
    }
  }

  // Check if user meets all requirements for a route
  Future<Map<String, dynamic>> checkRouteRequirements(String route) async {
    try {
      final requirements = await getRouteRequirements(route);
      final result = <String, dynamic>{
        'canAccess': true,
        'missingRequirements': <String>[],
        'userStatus': <String, dynamic>{},
      };

      final user = await _progressRepository.getCurrentUser();
      
      // Check authentication
      if (requirements['requiresAuth'] == true) {
        if (user == null) {
          result['canAccess'] = false;
          result['missingRequirements'].add('authentication');
        } else {
          result['userStatus']['isAuthenticated'] = true;
          result['userStatus']['userId'] = user.id;
          result['userStatus']['level'] = user.level;
          result['userStatus']['xp'] = user.xp;
        }
      }

      if (user != null) {
        // Check minimum level
        if (requirements['minimumLevel'] != null) {
          final requiredLevel = requirements['minimumLevel'] as int;
          if (user.level < requiredLevel) {
            result['canAccess'] = false;
            result['missingRequirements'].add('level_$requiredLevel');
          }
        }

        // Check minimum XP
        if (requirements['minimumXP'] != null) {
          final requiredXP = requirements['minimumXP'] as int;
          if (user.xp < requiredXP) {
            result['canAccess'] = false;
            result['missingRequirements'].add('xp_$requiredXP');
          }
        }

        // Check required achievements
        final requiredAchievements = requirements['requiredAchievements'] as List<String>;
        for (final achievement in requiredAchievements) {
          if (!user.achievements.contains(achievement)) {
            result['canAccess'] = false;
            result['missingRequirements'].add('achievement_$achievement');
          }
        }

        // Check premium access
        if (requirements['requiresPremium'] == true) {
          final hasPremium = await hasPremiumAccess();
          if (!hasPremium) {
            result['canAccess'] = false;
            result['missingRequirements'].add('premium');
          }
        }
      }

      return result;
    } catch (e) {
      print('Error checking route requirements: $e');
      return {
        'canAccess': false,
        'missingRequirements': ['error'],
        'userStatus': <String, dynamic>{},
      };
    }
  }
}

// Route guard widget for declarative route protection
class RouteGuardWidget extends StatefulWidget {
  final Widget child;
  final String route;
  final Map<String, dynamic>? parameters;
  final Widget? fallbackWidget;
  final VoidCallback? onAccessDenied;

  const RouteGuardWidget({
    Key? key,
    required this.child,
    required this.route,
    this.parameters,
    this.fallbackWidget,
    this.onAccessDenied,
  }) : super(key: key);

  @override
  State<RouteGuardWidget> createState() => _RouteGuardWidgetState();
}

class _RouteGuardWidgetState extends State<RouteGuardWidget> {
  bool _isLoading = true;
  bool _canAccess = false;
  late RouteGuards _routeGuards;

  @override
  void initState() {
    super.initState();
    // Initialize route guards - this would be injected in a real app
    // _routeGuards = RouteGuards(progressRepository);
    _checkAccess();
  }

  Future<void> _checkAccess() async {
    try {
      final canAccess = await _routeGuards.guardRoute(
        route: widget.route,
        parameters: widget.parameters,
      );

      if (mounted) {
        setState(() {
          _canAccess = canAccess;
          _isLoading = false;
        });

        if (!canAccess && widget.onAccessDenied != null) {
          widget.onAccessDenied!();
        }
      }
    } catch (e) {
      print('Error checking route access: $e');
      if (mounted) {
        setState(() {
          _canAccess = false;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (!_canAccess) {
      return widget.fallbackWidget ?? 
          const Center(
            child: Text(
              'غير مسموح بالوصول',
              style: TextStyle(fontSize: 18),
            ),
          );
    }

    return widget.child;
  }
}
