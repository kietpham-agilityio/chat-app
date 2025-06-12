part of 'home_cubit.dart';

enum HomeStatus { initial, loading, success, failure }

final class HomeState extends Equatable {
  const HomeState({
    this.chats = const [],
    this.status = HomeStatus.initial,
    this.errorMessage,
  });

  final List<ChatRoomModel> chats;
  final HomeStatus status;
  final String? errorMessage;

  HomeState copyWith({
    List<ChatRoomModel>? chats,
    HomeStatus? status,
    String? errorMessage,
  }) {
    return HomeState(
      chats: chats ?? this.chats,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [chats, status, errorMessage];
}
