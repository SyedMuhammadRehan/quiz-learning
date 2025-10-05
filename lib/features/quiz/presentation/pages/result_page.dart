
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/responsive.dart';
import '../../../home/presentation/bloc/home_bloc.dart';
import '../../../home/presentation/bloc/home_event.dart';
import '../bloc/quiz_bloc.dart';
import '../bloc/quiz_event.dart';

class ResultPage extends StatefulWidget {
  final int correctAnswers;
  final int totalQuestions;
  final String categoryName;
  final int categoryId; 

  const ResultPage({
    super.key,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.categoryName,
    required this.categoryId, 
  });

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Update home stats with correct category ID
    context.read<HomeBloc>().add(UpdateQuizProgressEvent(
          categoryId: widget.categoryId, // NOW IT'S DYNAMIC!
          correctAnswers: widget.correctAnswers,
          totalQuestions: widget.totalQuestions,
        ));

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  double get _percentage =>
      (widget.correctAnswers / widget.totalQuestions) * 100;

  String get _resultMessage {
    if (_percentage >= 80) return 'Excellent!';
    if (_percentage >= 60) return 'Good Job!';
    if (_percentage >= 40) return 'Not Bad!';
    return 'Keep Practicing!';
  }

  Color get _resultColor {
    if (_percentage >= 80) return Colors.green;
    if (_percentage >= 60) return Colors.blue;
    if (_percentage >= 40) return Colors.orange;
    return Colors.red;
  }

  String get _emoji {
    if (_percentage >= 80) return '🎉';
    if (_percentage >= 60) return '😊';
    if (_percentage >= 40) return '😐';
    return '😔';
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Go directly to home instead of going back through stack
        context.goNamed('dashboard');
        return false;
      },
      child: Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [_resultColor.withOpacity(0.1), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: Responsive.getPagePadding(context),
            child: Column(
              children: [
                const SizedBox(height: 40),

                // Result Icon
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _resultColor.withOpacity(0.1),
                      border: Border.all(
                        color: _resultColor,
                        width: 4,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        _emoji,
                        style: const TextStyle(fontSize: 60),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Result Message
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    _resultMessage,
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: _resultColor,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    widget.categoryName,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                  ),
                ),

                const SizedBox(height: 48),

                // Score Card
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Score Circle
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 180,
                              height: 180,
                              child: CircularProgressIndicator(
                                value: _percentage / 100,
                                strokeWidth: 12,
                                backgroundColor: Colors.grey.shade200,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  _resultColor,
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                Text(
                                  '${_percentage.toStringAsFixed(0)}%',
                                  style: TextStyle(
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold,
                                    color: _resultColor,
                                  ),
                                ),
                                Text(
                                  'Score',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        // Stats
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _StatItem(
                              icon: Icons.check_circle,
                              label: 'Correct',
                              value: '${widget.correctAnswers}',
                              color: Colors.green,
                            ),
                            Container(
                              width: 1,
                              height: 50,
                              color: Colors.grey.shade300,
                            ),
                            _StatItem(
                              icon: Icons.cancel,
                              label: 'Wrong',
                              value:
                                  '${widget.totalQuestions - widget.correctAnswers}',
                              color: Colors.red,
                            ),
                            Container(
                              width: 1,
                              height: 50,
                              color: Colors.grey.shade300,
                            ),
                            _StatItem(
                              icon: Icons.quiz,
                              label: 'Total',
                              value: '${widget.totalQuestions}',
                              color: Colors.blue,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 48),

                // Buttons
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // Reset quiz and go back to home
                            context.read<QuizBloc>().add(const ResetQuizEvent());
                            context.goNamed('dashboard');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6366F1),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Back to Home',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            // Show detailed review (optional feature)
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Review feature coming soon!'),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF6366F1),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            side: const BorderSide(
                              color: Color(0xFF6366F1),
                              width: 2,
                            ),
                          ),
                          child: const Text(
                            'Review Answers',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
       )   );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}
