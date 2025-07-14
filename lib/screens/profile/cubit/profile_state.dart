import 'package:equatable/equatable.dart';

enum ProfileStatus { initial, loading, success, failure }

class ProfileState extends Equatable {
  const ProfileState({
    this.isNotificationEnabled = false,
    this.status = ProfileStatus.initial,
  });

  final bool isNotificationEnabled;
  final ProfileStatus status;

  ProfileState copyWith({bool? isNotificationEnabled}) {
    return ProfileState(
      isNotificationEnabled:
          isNotificationEnabled ?? this.isNotificationEnabled,
    );
  }

  @override
  List<Object?> get props => [isNotificationEnabled, status];
}
