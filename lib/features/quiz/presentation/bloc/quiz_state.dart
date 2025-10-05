
import 'package:equatable/equatable.dart';
import '../../domain/entities/question.dart';

enum QuizStatus {
  initial,
  loading,
  loaded,
  answering,
  answered,
  completed,
  error,
}

class QuizState extends Equatable {
  final QuizStatus status;
  final List<Question> questions;
  final int currentQuestionIndex;
  final String? selectedAnswer;
  final int correctAnswers;
  final int wrongAnswers;
  final String? errorMessage;
  final String categoryName;
  final bool isAnswerCorrect;
  final int remainingSeconds; 

  const QuizState({
    this.status = QuizStatus.initial,
    this.questions = const [],
    this.currentQuestionIndex = 0,
    this.selectedAnswer,
    this.correctAnswers = 0,
    this.wrongAnswers = 0,
    this.errorMessage,
    this.categoryName = '',
    this.isAnswerCorrect = false,
    this.remainingSeconds = 60, 
  });

  // Getters
  Question? get currentQuestion {
    if (currentQuestionIndex < questions.length) {
      return questions[currentQuestionIndex];
    }
    return null;
  }

  int get totalQuestions => questions.length;

  double get progress {
    if (totalQuestions == 0) return 0.0;
    return (currentQuestionIndex + 1) / totalQuestions;
  }

  bool get hasMoreQuestions => currentQuestionIndex < questions.length - 1;

  bool get isLastQuestion => currentQuestionIndex == questions.length - 1;

  // CopyWith
  QuizState copyWith({
    QuizStatus? status,
    List<Question>? questions,
    int? currentQuestionIndex,
    String? selectedAnswer,
    int? correctAnswers,
    int? wrongAnswers,
    String? errorMessage,
    String? categoryName,
    bool? isAnswerCorrect,
    int? remainingSeconds,
  }) {
    return QuizState(
      status: status ?? this.status,
      questions: questions ?? this.questions,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      selectedAnswer: selectedAnswer,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      wrongAnswers: wrongAnswers ?? this.wrongAnswers,
      errorMessage: errorMessage,
      categoryName: categoryName ?? this.categoryName,
      isAnswerCorrect: isAnswerCorrect ?? this.isAnswerCorrect,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
    );
  }

  @override
  List<Object?> get props => [
        status,
        questions,
        currentQuestionIndex,
        selectedAnswer,
        correctAnswers,
        wrongAnswers,
        errorMessage,
        categoryName,
        isAnswerCorrect,
        remainingSeconds,
      ];
}