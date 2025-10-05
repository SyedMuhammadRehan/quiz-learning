import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/quiz_response_model.dart';
import '../models/question_model.dart';

abstract class QuizRemoteDataSource {
  Future<List<QuestionModel>> fetchQuestions({
    required int amount,
    required int categoryId,
    required String difficulty,
    String? type,
  });
}

class QuizRemoteDataSourceImpl implements QuizRemoteDataSource {
  final ApiService apiService;

  QuizRemoteDataSourceImpl({required this.apiService});

  @override
  Future<List<QuestionModel>> fetchQuestions({
    required int amount,
    required int categoryId,
    required String difficulty,
    String? type,
  }) async {
    try {
      // Build URL
      final url = '${ApiConstants.apiPath}?amount=$amount&category=$categoryId&difficulty=$difficulty${type != null ? '&type=$type' : ''}';

      print('🌐 Fetching from: $url');

      // Call API
      final result = await apiService.get<QuizResponseModel>(
            url,
            fromJson: (data) => QuizResponseModel.fromJson(data as Map<String, dynamic>),
          );

      return result.fold(
        (failure) {
          print('❌ Error ${failure.message}');
          throw ServerException(failure.message);
        },
        (quizResponse) {
          if (quizResponse.responseCode == ApiConstants.success) {
            print('✅ Successfully fetched ${quizResponse.results.length} questions');
            return quizResponse.results;
          } else if (quizResponse.responseCode == ApiConstants.noResults) {
            throw ServerException('No questions found for this category');
          } else {
            throw ServerException('Invalid API response code: ${quizResponse.responseCode}');
          }
        },
      );
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      print('❌ Error fetching questions: $e');
      throw ServerException('Failed to fetch questions: $e');
    }
  }
}
