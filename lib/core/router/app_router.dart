import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/registration_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/course/presentation/screens/course_view_screen.dart';
import '../../features/lesson/presentation/screens/lesson_screen.dart';
import '../../features/quiz/presentation/screens/quiz_screen.dart';
import '../../features/results/presentation/screens/results_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/navigation/presentation/screens/main_navigation.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/registration',
        name: 'registration',
        builder: (context, state) => const RegistrationScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => MainNavigation(
          child: child,
          location: state.uri.path,
        ),
        routes: [
          GoRoute(
            path: '/home',
            name: 'home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/course/:trackId',
        name: 'course',
        builder: (context, state) {
          final trackId = state.pathParameters['trackId']!;
          return CourseViewScreen(trackId: trackId);
        },
      ),
      GoRoute(
        path: '/lesson/:lessonId',
        name: 'lesson',
        builder: (context, state) {
          final lessonId = state.pathParameters['lessonId']!;
          return LessonScreen(lessonId: lessonId);
        },
      ),
      GoRoute(
        path: '/quiz/:quizId',
        name: 'quiz',
        builder: (context, state) {
          final quizId = state.pathParameters['quizId']!;
          return QuizScreen(quizId: quizId);
        },
      ),
      GoRoute(
        path: '/results',
        name: 'results',
        builder: (context, state) {
          final results = state.extra as Map<String, dynamic>;
          return ResultsScreen(results: results);
        },
      ),
    ],
  );
});
