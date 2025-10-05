
import 'package:equatable/equatable.dart';

abstract class QuizEvent extends Equatable {
  const QuizEvent();

  @override
  List<Object?> get props => [];
}

class LoadQuestionsEvent extends QuizEvent {
  final int categoryId;
  final String categoryName;
  final String difficulty;

  const LoadQuestionsEvent({
    required this.categoryId,
    required this.categoryName,
    required this.difficulty,
  });

  @override
  List<Object?> get props => [categoryId, categoryName, difficulty];
}

class AnswerQuestionEvent extends QuizEvent {
  final String selectedAnswer;

  const AnswerQuestionEvent(this.selectedAnswer);

  @override
  List<Object?> get props => [selectedAnswer];
}

class NextQuestionEvent extends QuizEvent {
  const NextQuestionEvent();
}

class TimeUpEvent extends QuizEvent {
  const TimeUpEvent();
}

class TimerTickEvent extends QuizEvent {
  final int remainingSeconds;

  const TimerTickEvent(this.remainingSeconds);

  @override
  List<Object?> get props => [remainingSeconds];
}

class ResetQuizEvent extends QuizEvent {
  const ResetQuizEvent();
}