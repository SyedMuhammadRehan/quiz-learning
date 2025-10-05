import '../../domain/entities/question.dart';

class QuestionModel extends Question {
  const QuestionModel({
    required super.question,
    required super.correctAnswer,
    required super.incorrectAnswers,
    required super.type,
    required super.difficulty,
    required super.category,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    // Decode HTML entities
    String decodeHtml(String text) {
      return text
   .replaceAll('"', '"')
          .replaceAll('&#039;', "'")
          .replaceAll('&', '&')
          .replaceAll('<', '<')
          .replaceAll('>', '>')
          .replaceAll('&rsquo;', "'")
          .replaceAll('&lsquo;', "'")
          .replaceAll('&ldquo;', '"')
          .replaceAll('&rdquo;', '"');
    }

    return QuestionModel(
      question: decodeHtml(json['question'] as String),
      correctAnswer: decodeHtml(json['correct_answer'] as String),
      incorrectAnswers: (json['incorrect_answers'] as List<dynamic>)
          .map((answer) => decodeHtml(answer as String))
          .toList(),
      type: json['type'] as String,
      difficulty: json['difficulty'] as String,
      category: decodeHtml(json['category'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'correct_answer': correctAnswer,
      'incorrect_answers': incorrectAnswers,
      'type': type,
      'difficulty': difficulty,
      'category': category,
    };
  }
}
