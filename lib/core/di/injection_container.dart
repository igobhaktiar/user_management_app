import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../../features/user/data/datasources/user_remote_datasource.dart';
import '../../features/user/presentation/bloc/user_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Bloc / Cubit
  sl.registerFactory(() => UserCubit(userRemoteDataSource: sl()));

  // Data sources
  sl.registerLazySingleton<UserRemoteDataSource>(() => UserRemoteDataSourceImpl(dio: sl()));

  // External
  sl.registerLazySingleton(() => Dio());
}
