import 'question_model.dart';

class QuizResponseModel {
  final int responseCode;
  final List<QuestionModel> results;

  const QuizResponseModel({
    required this.responseCode,
    required this.results,
  });

  factory QuizResponseModel.fromJson(Map<String, dynamic> json) {
    return QuizResponseModel(
      responseCode: json['response_code'] as int,
      results: (json['results'] as List<dynamic>)
          .map((question) => QuestionModel.fromJson(question as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'response_code': responseCode,
      'results': results.map((q) => q.toJson()).toList(),
    };
  }
}
