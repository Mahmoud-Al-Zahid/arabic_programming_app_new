import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/registration_screen.dart';
import '../../features/navigation/presentation/screens/main_navigation.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/course/presentation/screens/course_view_screen.dart';
import '../../features/lesson/presentation/screens/lesson_screen.dart';
import '../../features/quiz/presentation/screens/quiz_screen.dart';
import '../../features/results/presentation/screens/results_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/registration',
      builder: (context, state) => const RegistrationScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) => MainNavigation(
        location: state.uri.path,
        child: child,
      ),
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/course/:trackId',
      builder: (context, state) => CourseViewScreen(
        trackId: state.pathParameters['trackId']!,
      ),
    ),
    GoRoute(
      path: '/lesson/:lessonId',
      builder: (context, state) => LessonScreen(
        lessonId: state.pathParameters['lessonId']!,
      ),
    ),
    GoRoute(
      path: '/quiz/:quizId',
      builder: (context, state) => QuizScreen(
        quizId: state.pathParameters['quizId']!,
      ),
    ),
    GoRoute(
      path: '/results',
      builder: (context, state) => ResultsScreen(
        results: state.extra as Map<String, dynamic>? ?? {
          'score': 0,
          'total': 0,
          'percentage': 0,
        },
      ),
    ),
  ],
);
