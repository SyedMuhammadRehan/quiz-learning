import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.imageUrl,
    required super.rank,
    required super.score,
    required super.quizzesTaken,
    required super.totalQuizzes,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
      rank: json['rank'] as int,
      score: json['score'] as int,
      quizzesTaken: json['quizzesTaken'] as int,
      totalQuizzes: json['totalQuizzes'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'rank': rank,
      'score': score,
      'quizzesTaken': quizzesTaken,
      'totalQuizzes': totalQuizzes,
    };
  }

  // Dummy user for testing (starts fresh with no progress)
  static UserModel dummy() {
    return const UserModel(
      id: '1',
      name: 'John Doe',
      imageUrl: 'https://picsum.photos/150/150?random=1',
      rank: 1,
      score: 0,
      quizzesTaken: 0,
      totalQuizzes: 50,
    );
  }
}
