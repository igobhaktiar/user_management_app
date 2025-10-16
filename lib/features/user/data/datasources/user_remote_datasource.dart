import 'package:dio/dio.dart';
import '../../../../core/models/pagination_info.dart';
import '../../domain/entities/register_user_params.dart';
import '../models/user_model.dart';

class PaginatedResponse<T> {
  final List<T> data;
  final PaginationInfo paginationInfo;

  PaginatedResponse({required this.data, required this.paginationInfo});
}

abstract class UserRemoteDataSource {
  Future<PaginatedResponse<UserModel>> getUsers({required int page, required int limit});
  Future<UserModel> registerUser(RegisterUserParams params);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final Dio dio;
  final String token = 'dd919b680842f582640955b79779c1b051e2a151ddb457b0e1779b214c95ced2';
  final String baseUrl = 'https://gorest.co.in/public/v2';

  UserRemoteDataSourceImpl({required this.dio});

  @override
  Future<PaginatedResponse<UserModel>> getUsers({required int page, required int limit}) async {
    try {
      final response = await dio.get(
        '$baseUrl/users',
        queryParameters: {'page': page, 'per_page': limit},
        options: Options(headers: {'Authorization': 'Bearer $token'}, validateStatus: (status) => status! < 500),
      );

      if (response.statusCode == 200) {
        final paginationInfo = PaginationInfo.fromHeaders(response.headers.map);
        final users = (response.data as List).map((json) => UserModel.fromJson(json)).toList();

        return PaginatedResponse(data: users, paginationInfo: paginationInfo);
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<UserModel> registerUser(RegisterUserParams params) async {
    try {
      final response = await dio.post(
        '$baseUrl/users',
        data: params.toJson(),
        options: Options(
          headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json', 'Content-Type': 'application/json'},
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 201) {
        return UserModel.fromJson(response.data);
      } else {
        if (response.data is Map) {
          final List<String> errors = [];
          (response.data as Map).forEach((key, value) {
            if (value is List) {
              errors.addAll(value.map((e) => '$key: $e').cast<String>());
            } else {
              errors.add('$key: $value');
            }
          });
          throw Exception(errors.join('\n'));
        }
        throw Exception('Failed to register user');
      }
    } on DioException catch (e) {
      if (e.response?.data != null && e.response!.data is Map) {
        final List<String> errors = [];
        (e.response!.data as Map).forEach((key, value) {
          if (value is List) {
            errors.addAll(value.map((e) => '$key: $e').cast<String>());
          } else {
            errors.add('$key: $value');
          }
        });
        throw Exception(errors.join('\n'));
      }
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
