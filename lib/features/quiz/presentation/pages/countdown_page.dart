import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/quiz_bloc.dart';
import '../bloc/quiz_event.dart';

class CountdownPage extends StatefulWidget {
  final String categoryName;
  final int categoryId;
  final String difficulty;

  const CountdownPage({
    super.key,
    required this.categoryName,
    required this.categoryId,
    required this.difficulty,
  });

  @override
  State<CountdownPage> createState() => _CountdownPageState();
}

class _CountdownPageState extends State<CountdownPage>
    with SingleTickerProviderStateMixin {
  int _countdown = 3;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // Start loading questions in background
    context.read<QuizBloc>().add(LoadQuestionsEvent(
      categoryId: widget.categoryId,
      categoryName: widget.categoryName,
      difficulty: widget.difficulty,
    ));

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ),
    );

    _startCountdown();
  }

  void _startCountdown() {
    _animationController.forward();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 1) {
        setState(() {
          _countdown--;
        });
        _animationController.reset();
        _animationController.forward();
      } else {
        timer.cancel();
        _navigateToQuiz();
      }
    });
  }

void _navigateToQuiz() {
  // Works for both web and app
  if (kIsWeb) {
    // For Web: replace URL & suppress history entry
    Router.neglect(context, () {
      context.goNamed(
        'quiz',
        extra: {
          'categoryName': widget.categoryName,
          'categoryId': widget.categoryId,
          'difficulty': widget.difficulty,
        },
      );
    });
  } else {
    // For Mobile/Desktop: replace in navigation stack
    context.pushReplacementNamed(
      'quiz',
      extra: {
        'categoryName': widget.categoryName,
        'categoryId': widget.categoryId,
        'difficulty': widget.difficulty,
      },
    );
  }
}


  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Category Name
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  widget.categoryName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 60),

              // Countdown Number
              ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 40,
                        offset: const Offset(0, 20),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '$_countdown',
                      style: const TextStyle(
                        fontSize: 120,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6366F1),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 60),

              // Get Ready Text
              const Text(
                'Get Ready!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 16),

              Text(
                '10 questions • ${widget.difficulty.toUpperCase()}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
