import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/question.dart';
import '../../domain/repositories/quiz_repository.dart';
import '../datasources/quiz_remote_datasource.dart';

class QuizRepositoryImpl implements QuizRepository {
  final QuizRemoteDataSource remoteDataSource;

  QuizRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Question>>> fetchQuestions({
    required int amount,
    required int categoryId,
    required String difficulty,
    String? type,
  }) async {
    try {
      final questions = await remoteDataSource.fetchQuestions(
        amount: amount,
        categoryId: categoryId,
        difficulty: difficulty,
        type: type,
      );

      return Right(questions);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }
}
