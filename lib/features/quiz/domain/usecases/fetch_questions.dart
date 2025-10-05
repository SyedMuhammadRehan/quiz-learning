import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/question.dart';
import '../repositories/quiz_repository.dart';

class FetchQuestions {
  final QuizRepository repository;

  FetchQuestions(this.repository);

  Future<Either<Failure, List<Question>>> call(FetchQuestionsParams params) async {
    return await repository.fetchQuestions(
      amount: params.amount,
      categoryId: params.categoryId,
      difficulty: params.difficulty,
      type: params.type,
    );
  }
}

class FetchQuestionsParams extends Equatable {
  final int amount;
  final int categoryId;
  final String difficulty;
  final String? type;

  const FetchQuestionsParams({
    required this.amount,
    required this.categoryId,
    required this.difficulty,
    this.type,
  });

  @override
  List<Object?> get props => [amount, categoryId, difficulty, type];
}
