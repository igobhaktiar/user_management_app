import 'package:equatable/equatable.dart';
import '../../../../core/models/pagination_info.dart';
import '../../domain/entities/user.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {
  final bool isFirstFetch;

  const UserLoading({this.isFirstFetch = false});

  @override
  List<Object?> get props => [isFirstFetch];
}

class UserLoaded extends UserState {
  final List<User> users;
  final List<User> filteredUsers;
  final String searchQuery;
  final PaginationInfo paginationInfo;
  final bool hasReachedMax;
  final bool isLoading;

  const UserLoaded({
    required this.users,
    required this.filteredUsers,
    required this.paginationInfo,
    this.searchQuery = '',
    this.hasReachedMax = false,
    this.isLoading = false,
  });

  @override
  List<Object?> get props => [users, filteredUsers, searchQuery, paginationInfo, hasReachedMax];

  UserLoaded copyWith({
    List<User>? users,
    List<User>? filteredUsers,
    String? searchQuery,
    PaginationInfo? paginationInfo,
    bool? hasReachedMax,
    bool? isLoading,
  }) {
    return UserLoaded(
      users: users ?? this.users,
      filteredUsers: filteredUsers ?? this.filteredUsers,
      searchQuery: searchQuery ?? this.searchQuery,
      paginationInfo: paginationInfo ?? this.paginationInfo,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class UserError extends UserState {
  final String message;

  const UserError(this.message);

  @override
  List<Object?> get props => [message];
}
