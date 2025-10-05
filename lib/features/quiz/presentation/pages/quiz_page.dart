
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/responsive.dart';
import '../bloc/quiz_bloc.dart';
import '../bloc/quiz_event.dart';
import '../bloc/quiz_state.dart';
import '../widgets/question_card.dart';
import '../widgets/timer_widget.dart';
import '../widgets/answer_option.dart';
class QuizPage extends StatefulWidget {
  final String categoryName;
  final int categoryId;
  final String difficulty;

  const QuizPage({
    super.key,
    required this.categoryName,
    required this.categoryId,
    required this.difficulty,
  });

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
 _navigateToResult(QuizState state) {
  // Works for both web and app
  if (kIsWeb) {
    // For Web: replace URL & suppress history entry
    Router.neglect(context, () {
      context.goNamed(
                    'result',
                    extra: {
                      'correctAnswers': state.correctAnswers,
                      'totalQuestions': state.totalQuestions,
                      'categoryName': widget.categoryName,
                      'categoryId': widget.categoryId,
                    },
                  );
    });
  } else {
    // For Mobile/Desktop: replace in navigation stack
    context.pushReplacementNamed(
                    'result',
                    extra: {
                      'correctAnswers': state.correctAnswers,
                      'totalQuestions': state.totalQuestions,
                      'categoryName': widget.categoryName,
                      'categoryId': widget.categoryId,
                    },
                  );
  }
}
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Go directly to dashboard instead of going back through stack
        context.goNamed('dashboard');
        return false;
      },
      child: Scaffold(
      body: SafeArea(
        child: BlocConsumer<QuizBloc, QuizState>(
          listener: (context, state) {
            if (state.status == QuizStatus.completed) {
              // Navigate to result page
              Future.delayed(const Duration(milliseconds: 500), () {
                if (context.mounted) {
                 _navigateToResult(state);
                }
              });
            }
          },
          builder: (context, state) {
            if (state.status == QuizStatus.initial || state.status == QuizStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state.status == QuizStatus.error) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(
                        state.errorMessage ?? 'Failed to load questions',
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          context.read<QuizBloc>().add(const ResetQuizEvent());
                          context.goNamed('dashboard');
                        },
                        child: const Text('Go Back'),
                      ),
                    ],
                  ),
                ),
              );
            }

            final question = state.currentQuestion;
            if (question == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.quiz, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    const Text('No questions available'),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        context.read<QuizBloc>().add(const ResetQuizEvent());
                        context.goNamed('dashboard');
                      },
                      child: const Text('Go Back'),
                    ),
                  ],
                ),
              );
            }

            final answers = question.allAnswers;
            final isAnswered = state.status == QuizStatus.answered;

            return Column(
              children: [
                // Top Bar
                Container(
                  padding: Responsive.getPagePadding(context),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Exit Quiz?'),
                                  content: const Text(
                                    'Your progress will be lost.',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(ctx);
                                        context.read<QuizBloc>().add(const ResetQuizEvent());
                                        context.goNamed('dashboard');
                                      },
                                      child: const Text('Exit'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  'Question ${state.currentQuestionIndex + 1}/${state.totalQuestions}',
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 8),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: LinearProgressIndicator(
                                    value: state.progress,
                                    backgroundColor: Colors.grey.shade200,
                                    valueColor: const AlwaysStoppedAnimation<Color>(
                                      Color(0xFF6366F1),
                                    ),
                                    minHeight: 8,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 48),
                        ],
                      ),
                    ],
                  ),
                ),

                // Question Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: Responsive.getPagePadding(context),
                    child: Column(
                      children: [
                        const SizedBox(height: 24),

                        // Timer - Now from BLoC state!
                        TimerWidget(
                          remainingSeconds: state.remainingSeconds,
                          totalSeconds: 60,
                        ),

                        const SizedBox(height: 32),

                        // Question Card
                        QuestionCard(question: question),

                        const SizedBox(height: 32),

                        // Answer Options
                        ...answers.map((answer) {
                          bool isCorrect = answer == question.correctAnswer;
                          bool isSelected = answer == state.selectedAnswer;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: AnswerOption(
                              answer: answer,
                              isSelected: isSelected,
                              isCorrect: isCorrect,
                              showResult: isAnswered,
                              onTap: () {
                                if (!isAnswered) {
                                  context.read<QuizBloc>().add(
                                        AnswerQuestionEvent(answer),
                                      );
                                }
                              },
                            ),
                          );
                        }).toList(),

                        // Feedback
                        if (isAnswered) ...[
                          const SizedBox(height: 24),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: state.isAnswerCorrect
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: state.isAnswerCorrect
                                    ? Colors.green
                                    : Colors.red,
                                width: 2,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  state.isAnswerCorrect
                                      ? Icons.check_circle
                                      : Icons.cancel,
                                  color: state.isAnswerCorrect
                                      ? Colors.green
                                      : Colors.red,
                                  size: 32,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    state.isAnswerCorrect
                                        ? 'Correct!'
                                        : 'Incorrect',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: state.isAnswerCorrect
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],

                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
     ) );
  }
}
