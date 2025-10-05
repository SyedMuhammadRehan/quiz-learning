import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/user_model.dart';
import '../../data/models/category_model.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState()) {
    on<LoadHomeDataEvent>(_onLoadHomeData);
    on<UpdateQuizProgressEvent>(_onUpdateQuizProgress);
    on<UpdateUserStatsEvent>(_onUpdateUserStats);
  }

  void _onLoadHomeData(
    LoadHomeDataEvent event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(status: HomeStatus.loading));

    // Load dummy data
    final user = UserModel.dummy();
    final categories = CategoryModel.dummyCategories();

    emit(state.copyWith(
      status: HomeStatus.loaded,
      user: user,
      categories: categories,
    ));
  }

  void _onUpdateQuizProgress(
    UpdateQuizProgressEvent event,
    Emitter<HomeState> emit,
  ) {
    // Update category progress
    final updatedCategories = state.categories.map((category) {
      if (category.id == event.categoryId) {
        return category.copyWith(
          questionsCompleted: min(category.totalQuestions, category.questionsCompleted + event.correctAnswers),
        );
      }
      return category;
    }).toList();

    // Update user stats
    final updatedUser = state.user?.copyWith(
      quizzesTaken: state.user!.quizzesTaken + 1,
      score: state.user!.score + (event.correctAnswers * 10),
    );

    emit(state.copyWith(
      user: updatedUser,
      categories: updatedCategories,
    ));
  }

  void _onUpdateUserStats(
    UpdateUserStatsEvent event,
    Emitter<HomeState> emit,
  ) {
    // Update user stats
    final updatedUser = state.user?.copyWith(
      quizzesTaken: state.user!.quizzesTaken + event.quizzesTakenIncrement,
      score: state.user!.score + event.scoreIncrement,
    );

    emit(state.copyWith(
      user: updatedUser,
    ));
  }
}
