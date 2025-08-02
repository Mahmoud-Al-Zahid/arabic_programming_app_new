import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/registration_screen.dart';
import '../../features/navigation/presentation/screens/main_navigation.dart';
import '../../features/course/presentation/screens/course_view_screen.dart';
import '../../features/lesson/presentation/screens/lesson_screen.dart';
import '../../features/quiz/presentation/screens/quiz_screen.dart';
import '../../features/results/presentation/screens/results_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    // Splash Screen
    GoRoute(
      path: '/splash',
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),
    
    // Onboarding
    GoRoute(
      path: '/onboarding',
      name: 'onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    
    // Registration
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => const RegistrationScreen(),
    ),
    
    // Main Navigation (Home, Profile, Store)
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const MainNavigation(),
    ),
    
    // Course View
    GoRoute(
      path: '/course/:trackId',
      name: 'course',
      builder: (context, state) {
        final trackId = state.pathParameters['trackId']!;
        return CourseViewScreen(trackId: trackId);
      },
    ),
    
    // Lesson
    GoRoute(
      path: '/lesson/:lessonId',
      name: 'lesson',
      builder: (context, state) {
        final lessonId = state.pathParameters['lessonId']!;
        return LessonScreen(lessonId: lessonId);
      },
    ),
    
    // Quiz
    GoRoute(
      path: '/quiz/:quizId',
      name: 'quiz',
      builder: (context, state) {
        final quizId = state.pathParameters['quizId']!;
        return QuizScreen(quizId: quizId);
      },
    ),
    
    // Results
    GoRoute(
      path: '/results',
      name: 'results',
      builder: (context, state) {
        final results = state.extra as Map<String, dynamic>?;
        return ResultsScreen(results: results);
      },
    ),
  ],
  
  // Error handling
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          Text(
            'حدث خطأ: ${state.error}',
            style: const TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.go('/home'),
            child: const Text('العودة للرئيسية'),
          ),
        ],
      ),
    ),
  ),
);
