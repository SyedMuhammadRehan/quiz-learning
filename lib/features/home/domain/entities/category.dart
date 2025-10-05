import 'package:equatable/equatable.dart';

class Category extends Equatable {
  const Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.questionsCompleted,
    required this.totalQuestions,
    required this.difficulty,
  });

  final int id;
  final String name;
  final String icon;
  final int questionsCompleted;
  final int totalQuestions;
  final String difficulty;

  int get progress => totalQuestions > 0 ? (questionsCompleted * 100 ~/ totalQuestions) : 0;

  Category copyWith({
    String? name,
    int? questionsCompleted,
    int? totalQuestions,
    String? difficulty,
  }) {
    return Category(
      id: id,
      name: name ?? this.name,
      icon: icon,
      questionsCompleted: questionsCompleted ?? this.questionsCompleted,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      difficulty: difficulty ?? this.difficulty,
    );
  }

  @override
  List<Object?> get props => [id, name, icon, questionsCompleted, totalQuestions, difficulty];
}
