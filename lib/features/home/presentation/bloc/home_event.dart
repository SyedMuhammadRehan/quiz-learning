import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class LoadHomeDataEvent extends HomeEvent {
  const LoadHomeDataEvent();
}

class UpdateQuizProgressEvent extends HomeEvent {
  final int categoryId;
  final int correctAnswers;
  final int totalQuestions;

  const UpdateQuizProgressEvent({
    required this.categoryId,
    required this.correctAnswers,
    required this.totalQuestions,
  });

  @override
  List<Object?> get props => [categoryId, correctAnswers, totalQuestions];
}

class UpdateUserStatsEvent extends HomeEvent {
  final int quizzesTakenIncrement;
  final int scoreIncrement;

  const UpdateUserStatsEvent({
    required this.quizzesTakenIncrement,
    required this.scoreIncrement,
  });

  @override
  List<Object?> get props => [quizzesTakenIncrement, scoreIncrement];
}
