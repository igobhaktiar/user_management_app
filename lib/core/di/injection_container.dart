import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../../features/user/data/datasources/user_remote_datasource.dart';
import '../../features/user/presentation/bloc/user_cubit.dart';
import '../../features/stock/data/datasources/stock_local_datasource.dart';
import '../../features/stock/data/repositories/stock_repository_impl.dart';
import '../../features/stock/domain/repositories/stock_repository.dart';
import '../../features/stock/domain/usecases/add_transaction.dart';
import '../../features/stock/domain/usecases/get_monthly_summary.dart';
import '../../features/stock/domain/usecases/get_products.dart';
import '../../features/stock/domain/usecases/get_transactions.dart';
import '../../features/stock/presentation/bloc/stock_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Bloc / Cubit
  sl.registerFactory(() => UserCubit(userRemoteDataSource: sl()));
  sl.registerFactory(() => StockCubit(getProducts: sl(), getTransactions: sl(), addTransaction: sl(), getMonthlySummary: sl()));

  // Use cases - Stock
  sl.registerLazySingleton(() => GetProducts(repository: sl()));
  sl.registerLazySingleton(() => GetTransactions(repository: sl()));
  sl.registerLazySingleton(() => AddTransaction(repository: sl()));
  sl.registerLazySingleton(() => GetMonthlySummary(repository: sl()));

  // Repository
  sl.registerLazySingleton<StockRepository>(() => StockRepositoryImpl(localDatasource: sl()));

  // Data sources
  sl.registerLazySingleton<UserRemoteDataSource>(() => UserRemoteDataSourceImpl(dio: sl()));
  sl.registerLazySingleton<StockLocalDatasource>(() => StockLocalDatasource());

  // External
  sl.registerLazySingleton(() => Dio());
}
