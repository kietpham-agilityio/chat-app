part of 'search_cubit.dart';

enum SearchStatus { initial, loading, success, failure }

class SearchState extends Equatable {
  const SearchState({
    this.users = const [],
    this.status = SearchStatus.initial,
    this.errorMessage,
  });

  final List<UserModel> users;
  final SearchStatus status;
  final String? errorMessage;

  SearchState copyWith({
    List<UserModel>? users,
    SearchStatus? status,
    String? errorMessage,
  }) {
    return SearchState(
      users: users ?? this.users,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}
