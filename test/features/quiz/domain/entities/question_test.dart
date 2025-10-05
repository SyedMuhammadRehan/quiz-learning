// test/features/quiz/domain/entities/question_test.dart

import 'package:flutter_quiz_app/features/quiz/domain/entities/question.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Question Entity', () {
    const tQuestion = Question(
      question: 'What is 2+2?',
      correctAnswer: '4',
      incorrectAnswers: ['3', '5', '6'],
      type: 'multiple',
      difficulty: 'easy',
      category: 'Math',
    );

    test('allAnswers should return all answers shuffled', () {
      final answers = tQuestion.allAnswers;
      expect(answers.length, 4);
      expect(answers.contains('4'), true);
      expect(answers.contains('3'), true);
    });

    test('isCorrect should return true for correct answer', () {
      expect(tQuestion.isCorrect('4'), true);
      expect(tQuestion.isCorrect('3'), false);
    });

    test('isTrueFalse should return false for multiple choice', () {
      expect(tQuestion.isTrueFalse, false);
      expect(tQuestion.isMultipleChoice, true);
    });

    test('should support equality', () {
      const sameQuestion = Question(
        question: 'What is 2+2?',
        correctAnswer: '4',
        incorrectAnswers: ['3', '5', '6'],
        type: 'multiple',
        difficulty: 'easy',
        category: 'Math',
      );
      expect(tQuestion, sameQuestion);
    });
  });
}