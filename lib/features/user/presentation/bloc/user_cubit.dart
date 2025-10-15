import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/user_remote_datasource.dart';
import '../../domain/entities/register_user_params.dart';
import 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserRemoteDataSource userRemoteDataSource;
  static const int _limit = 10;

  UserCubit({required this.userRemoteDataSource}) : super(UserInitial());

  Future<void> getUsers({bool isRefresh = false}) async {
    try {
      if (state is UserInitial || isRefresh) {
        emit(const UserLoading(isFirstFetch: true));
        final response = await userRemoteDataSource.getUsers(page: 1, limit: _limit);
        emit(
          UserLoaded(
            users: response.data,
            filteredUsers: response.data,
            paginationInfo: response.paginationInfo,
            hasReachedMax: response.data.length < _limit,
            isLoading: false,
          ),
        );
        return;
      }

      if (state is UserLoaded) {
        final currentState = state as UserLoaded;
        if (currentState.hasReachedMax) return;

        // Emit current state with loading indicator
        emit(currentState.copyWith(isLoading: true));

        final nextPage = currentState.paginationInfo.currentPage + 1;
        final response = await userRemoteDataSource.getUsers(page: nextPage, limit: _limit);

        // Combine existing and new data
        final updatedUsers = [...currentState.users, ...response.data];
        final searchQuery = currentState.searchQuery;

        // Apply current search filter to new combined data
        final filteredUsers = searchQuery.isEmpty
            ? updatedUsers
            : updatedUsers.where((user) {
                final lowercaseName = user.name.toLowerCase();
                final lowercaseEmail = user.email.toLowerCase();
                final lowercaseQuery = searchQuery.toLowerCase();
                return lowercaseName.contains(lowercaseQuery) || lowercaseEmail.contains(lowercaseQuery);
              }).toList();

        emit(
          currentState.copyWith(
            users: updatedUsers,
            filteredUsers: filteredUsers,
            paginationInfo: response.paginationInfo,
            hasReachedMax: response.data.length < _limit,
            isLoading: false,
          ),
        );
      }
    } catch (e) {
      if (state is UserLoaded) {
        // Keep existing data and show error toast/snackbar instead of full error state
        final currentState = state as UserLoaded;
        emit(currentState.copyWith(isLoading: false));
      } else {
        emit(UserError(e.toString()));
      }
    }
  }

  void searchUsers(String query) {
    if (state is UserLoaded) {
      final currentState = state as UserLoaded;
      final lowercaseQuery = query.toLowerCase();

      final filteredUsers = currentState.users.where((user) {
        final lowercaseName = user.name.toLowerCase();
        final lowercaseEmail = user.email.toLowerCase();

        return lowercaseName.contains(lowercaseQuery) || lowercaseEmail.contains(lowercaseQuery);
      }).toList();

      emit(
        currentState.copyWith(
          filteredUsers: filteredUsers,
          searchQuery: query,
          // Reset loading state when searching
          isLoading: false,
        ),
      );
    }
  }

  Future<void> registerUser(RegisterUserParams params) async {
    try {
      final user = await userRemoteDataSource.registerUser(params);
      
      // If we have a loaded state, add the new user to the list
      if (state is UserLoaded) {
        final currentState = state as UserLoaded;
        final updatedUsers = [user, ...currentState.users];
        
        emit(currentState.copyWith(
          users: updatedUsers,
          filteredUsers: currentState.searchQuery.isEmpty 
              ? updatedUsers 
              : updatedUsers.where((u) {
                  final lowercaseName = u.name.toLowerCase();
                  final lowercaseEmail = u.email.toLowerCase();
                  final lowercaseQuery = currentState.searchQuery.toLowerCase();
                  return lowercaseName.contains(lowercaseQuery) || 
                         lowercaseEmail.contains(lowercaseQuery);
                }).toList(),
        ));
      }
    } catch (