import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
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

final appRouter = GoRouter(
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
    GoRoute(
      path: '/main',
      builder: (context, state) => const MainNavigation(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/course/:trackId',
      builder: (context, state) {
        final trackId = state.pathParameters['trackId']!;
        return CourseViewScreen(trackId: trackId);
      },
    ),
    GoRoute(
      path: '/lesson/:lessonId',
      builder: (context, state) {
        final lessonId = state.pathParameters['lessonId']!;
        return LessonScreen(lessonId: lessonId);
      },
    ),
    GoRoute(
      path: '/quiz/:quizId',
      builder: (context, state) {
        final quizId = state.pathParameters['quizId']!;
        return QuizScreen(quizId: quizId);
      },
    ),
    GoRoute(
      path: '/results',
      builder: (context, state) {
        final results = state.extra as Map<String, dynamic>?;
        return ResultsScreen(results: results);
      },
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
  ],
);
