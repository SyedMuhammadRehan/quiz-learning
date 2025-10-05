import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/question.dart';

abstract class QuizRepository {
  Future<Either<Failure, List<Question>>> fetchQuestions({
    required int amount,
    required int categoryId,
    required String difficulty,
    String? type,
  });
}
