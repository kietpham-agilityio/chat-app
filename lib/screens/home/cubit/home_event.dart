part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {}

class HomeInitializeEvent extends HomeEvent {
  HomeInitializeEvent(this.currentUserId);

  final String currentUserId;

  @override
  List<Object?> get props => [currentUserId];
}
