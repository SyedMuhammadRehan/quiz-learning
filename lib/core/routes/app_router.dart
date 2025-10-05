import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/dashboard/presentation/pages/dashboard_page.dart';

import '../../features/quiz/presentation/pages/countdown_page.dart';
import '../../features/quiz/presentation/pages/quiz_page.dart';
import '../../features/quiz/presentation/pages/result_page.dart';

class AppRouter {
  static const String dashboard = '/';
  static const String countdown = '/countdown';
  static const String quiz = '/quiz';
  static const String quizResult = '/quiz-result';

  static final GoRouter router = GoRouter(
    initialLocation: dashboard,
    routes: [
      // 🧭 Main dashboard with bottom navigation
      GoRoute(
        path: dashboard,
        name: 'dashboard',
        builder: (context, state) => const DashboardPage(),
      ),

      // ⏱ Countdown Page (no bottom bar)
      GoRoute(
        path: countdown,
        name: 'countdown',
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return MaterialPage(
            key: state.pageKey,
            child: CountdownPage(
              categoryName: extra['categoryName'] as String,
              categoryId: extra['categoryId'] as int,
              difficulty: extra['difficulty'] as String,
            ),
          );
        },
      ),

      // 🧩 Quiz Page (no bottom bar)
      GoRoute(
        path: quiz,
        name: 'quiz',
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return MaterialPage(
            key: state.pageKey,
            child: QuizPage(
              categoryName: extra['categoryName'] as String,
              categoryId: extra['categoryId'] as int,
              difficulty: extra['difficulty'] as String,
            ),
          );
        },
      ),

      // 🏁 Result Page (no bottom bar)
      GoRoute(
        path: quizResult,
        name: 'result',
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return MaterialPage(
            key: state.pageKey,
            child: ResultPage(
              correctAnswers: extra['correctAnswers'] as int,
              totalQuestions: extra['totalQuestions'] as int,
              categoryName: extra['categoryName'] as String,
              categoryId: extra['categoryId'] as int,
            ),
          );
        },
      ),
    ],
  );
}
