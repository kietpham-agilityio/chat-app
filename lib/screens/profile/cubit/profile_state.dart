import 'package:equatable/equatable.dart';

enum ProfileStatus { initial, loading, success, failure, openSettings }

class ProfileState extends Equatable {
  const ProfileState({
    this.isNotificationEnabled = false,
    this.status = ProfileStatus.initial,
  });

  final bool isNotificationEnabled;
  final ProfileStatus status;

  ProfileState copyWith({bool? isNotificationEnabled, ProfileStatus? status}) {
    return ProfileState(
      isNotificationEnabled:
          isNotificationEnabled ?? this.isNotificationEnabled,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [isNotificationEnabled, status];
}
