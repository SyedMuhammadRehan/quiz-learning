// test/features/quiz/domain/usecases/fetch_questions_test.dart

import 'package:flutter_quiz_app/features/quiz/domain/entities/question.dart';
import 'package:flutter_quiz_app/features/quiz/domain/repositories/quiz_repository.dart';
import 'package:flutter_quiz_app/features/quiz/domain/usecases/fetch_questions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';


class MockQuizRepository extends Mock implements QuizRepository {}

void main() {
  late FetchQuestions useCase;
  late MockQuizRepository mockRepository;

  setUp(() {
    mockRepository = MockQuizRepository();
    useCase = FetchQuestions(mockRepository);
  });

  const tQuestion = Question(
    question: 'Test?',
    correctAnswer: 'Yes',
    incorrectAnswers: ['No'],
    type: 'boolean',
    difficulty: 'easy',
    category: 'Test',
  );

  const tParams = FetchQuestionsParams(
    amount: 10,
    categoryId: 9,
    difficulty: 'easy',
  );

  test('should get questions from repository', () async {
    // arrange
    when(() => mockRepository.fetchQuestions(
          amount: any(named: 'amount'),
          categoryId: any(named: 'categoryId'),
          difficulty: any(named: 'difficulty'),
        )).thenAnswer((_) async => const Right([tQuestion]));

    // act
    final result = await useCase(tParams);

    // assert
    expect(result, const Right([tQuestion]));
    verify(() => mockRepository.fetchQuestions(
          amount: 10,
          categoryId: 9,
          difficulty: 'easy',
        )).called(1);
  });
}