import 'package:flutter_quiz_app/features/quiz/data/repositories/quiz_repository_impl.dart';
import 'package:get_it/get_it.dart';
import '../network/api_service.dart';
import '../../features/quiz/data/datasources/quiz_remote_datasource.dart';
import '../../features/quiz/domain/repositories/quiz_repository.dart';
import '../../features/quiz/domain/usecases/fetch_questions.dart';
import '../../features/quiz/presentation/bloc/quiz_bloc.dart';
import '../../features/home/presentation/bloc/home_bloc.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // Core
  sl.registerLazySingleton(() => ApiService());

  // Data sources
  sl.registerLazySingleton<QuizRemoteDataSource>(
    () => QuizRemoteDataSourceImpl(apiService: sl()),
  );

  // Repositories
  sl.registerLazySingleton<QuizRepository>(
    () => QuizRepositoryImpl(remoteDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => FetchQuestions(sl()));

  // BLoCs
  sl.registerFactory(() => QuizBloc(fetchQuestions: sl()));
  sl.registerFactory(() => HomeBloc());
}
