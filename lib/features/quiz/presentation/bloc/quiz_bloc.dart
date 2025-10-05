
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/fetch_questions.dart';
import 'quiz_event.dart';
import 'quiz_state.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  final FetchQuestions fetchQuestions;
  Timer? _timer;

  QuizBloc({required this.fetchQuestions}) : super(const QuizState()) {
    on<LoadQuestionsEvent>(_onLoadQuestions);
    on<AnswerQuestionEvent>(_onAnswerQuestion);
    on<NextQuestionEvent>(_onNextQuestion);
    on<TimeUpEvent>(_onTimeUp);
    on<TimerTickEvent>(_onTimerTick);
    on<ResetQuizEvent>(_onResetQuiz);
  }

  Future<void> _onLoadQuestions(
    LoadQuestionsEvent event,
    Emitter<QuizState> emit,
  ) async {
    emit(state.copyWith(
      status: QuizStatus.loading,
      categoryName: event.categoryName,
    ));

    final params = FetchQuestionsParams(
      amount: 10,
      categoryId: event.categoryId,
      difficulty: event.difficulty,
      type: null, // Request mixed question types (multiple choice + true/false)
    );

    final result = await fetchQuestions(params);

    result.fold(
      (failure) {
        emit(state.copyWith(
          status: QuizStatus.error,
          errorMessage: failure.message,
        ));
      },
      (questions) {
        if (questions.isEmpty) {
          emit(state.copyWith(
            status: QuizStatus.error,
            errorMessage: 'No questions available for this category',
          ));
        } else {
          emit(state.copyWith(
            status: QuizStatus.loaded,
            questions: questions,
            currentQuestionIndex: 0,
            correctAnswers: 0,
            wrongAnswers: 0,
            remainingSeconds: 60,
          ));
          _startTimer();
        }
      },
    );
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.remainingSeconds > 0) {
        add(TimerTickEvent(state.remainingSeconds - 1));
      } else {
        timer.cancel();
        add(const TimeUpEvent());
      }
    });
  }

  void _onTimerTick(
    TimerTickEvent event,
    Emitter<QuizState> emit,
  ) {
    emit(state.copyWith(remainingSeconds: event.remainingSeconds));
  }

  void _onAnswerQuestion(
    AnswerQuestionEvent event,
    Emitter<QuizState> emit,
  ) {
    _timer?.cancel();
    
    final currentQuestion = state.currentQuestion;
    if (currentQuestion == null) return;

    final isCorrect = currentQuestion.isCorrect(event.selectedAnswer);

    emit(state.copyWith(
      status: QuizStatus.answered,
      selectedAnswer: event.selectedAnswer,
      isAnswerCorrect: isCorrect,
      correctAnswers: isCorrect ? state.correctAnswers + 1 : state.correctAnswers,
      wrongAnswers: !isCorrect ? state.wrongAnswers + 1 : state.wrongAnswers,
    ));

    // Auto move to next after 1 second
    Future.delayed(const Duration(seconds: 1), () {
      add(const NextQuestionEvent());
    });
  }

  void _onNextQuestion(
    NextQuestionEvent event,
    Emitter<QuizState> emit,
  ) {
    if (state.isLastQuestion) {
      _timer?.cancel();
      emit(state.copyWith(
        status: QuizStatus.completed,
        selectedAnswer: null,
      ));
    } else {
      emit(state.copyWith(
        status: QuizStatus.loaded,
        currentQuestionIndex: state.currentQuestionIndex + 1,
        selectedAnswer: null,
        isAnswerCorrect: false,
        remainingSeconds: 60,
      ));
      _startTimer();
    }
  }

  void _onTimeUp(
    TimeUpEvent event,
    Emitter<QuizState> emit,
  ) {
    _timer?.cancel();
    
    emit(state.copyWith(
      status: QuizStatus.answered,
      selectedAnswer: null,
      isAnswerCorrect: false,
      wrongAnswers: state.wrongAnswers + 1,
    ));

    // Auto move to next after 1 second
    Future.delayed(const Duration(seconds: 1), () {
      add(const NextQuestionEvent());
    });
  }

  void _onResetQuiz(
    ResetQuizEvent event,
    Emitter<QuizState> emit,
  ) {
    _timer?.cancel();
    emit(const QuizState());
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
