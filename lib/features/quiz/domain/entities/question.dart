import 'package:equatable/equatable.dart';

class Question extends Equatable {
  final String question;
  final String correctAnswer;
  final List<String> incorrectAnswers;
  final String type;
  final String difficulty;
  final String category;

  const Question({
    required this.question,
    required this.correctAnswer,
    required this.incorrectAnswers,
    required this.type,
    required this.difficulty,
    required this.category,
  });

  // Get all answers in API order
  List<String> get allAnswers => [correctAnswer, ...incorrectAnswers];

  // Check if answer is correct
  bool isCorrect(String answer) => answer == correctAnswer;

  // Check if it's true/false question
  bool get isTrueFalse => type == 'boolean';

  // Check if it's multiple choice
  bool get isMultipleChoice => type == 'multiple';

  @override
  List<Object?> get props => [
        question,
        correctAnswer,
        incorrectAnswers,
        type,
        difficulty,
        category,
      ];
}
