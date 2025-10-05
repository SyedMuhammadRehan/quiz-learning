import '../../domain/entities/category.dart';

class CategoryModel extends Category {
  const CategoryModel({
    required super.id,
    required super.name,
    required super.icon,
    required super.questionsCompleted,
    required super.totalQuestions,
    required super.difficulty,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as int,
      name: json['name'] as String,
      icon: json['icon'] as String,
      questionsCompleted: json['questionsCompleted'] as int? ?? 0,
      totalQuestions: json['totalQuestions'] as int? ?? 10,
      difficulty: json['difficulty'] as String? ?? 'easy',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'questionsCompleted': questionsCompleted,
      'totalQuestions': totalQuestions,
      'difficulty': difficulty,
    };
  }

  // Dummy categories matching Open Trivia DB with varied difficulties
  static List<CategoryModel> dummyCategories() {
    return const [
      CategoryModel(
        id: 9,
        name: 'General Knowledge',
        icon: '🧠',
        questionsCompleted: 0,
        totalQuestions: 10,
        difficulty: 'easy',
      ),
      CategoryModel(
        id: 18,
        name: 'Science: Computers',
        icon: '💻',
        questionsCompleted: 0,
        totalQuestions: 10,
        difficulty: 'medium',
      ),
      CategoryModel(
        id: 21,
        name: 'Sports',
        icon: '⚽',
        questionsCompleted: 0,
        totalQuestions: 10,
        difficulty: 'easy',
      ),
      CategoryModel(
        id: 23,
        name: 'History',
        icon: '📚',
        questionsCompleted: 0,
        totalQuestions: 10,
        difficulty: 'hard',
      ),
      CategoryModel(
        id: 17,
        name: 'Science & Nature',
        icon: '🔬',
        questionsCompleted: 0,
        totalQuestions: 10,
        difficulty: 'medium',
      ),
    ];
  }
}
