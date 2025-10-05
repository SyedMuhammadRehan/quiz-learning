import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/category.dart';

enum HomeStatus {
  initial,
  loading,
  loaded,
  error,
}

class HomeState extends Equatable {
  final HomeStatus status;
  final User? user;
  final List<Category> categories;
  final String? errorMessage;

  const HomeState({
    this.status = HomeStatus.initial,
    this.user,
    this.categories = const [],
    this.errorMessage,
  });

  HomeState copyWith({
    HomeStatus? status,
    User? user,
    List<Category>? categories,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      user: user ?? this.user,
      categories: categories ?? this.categories,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, user, categories, errorMessage];
}
