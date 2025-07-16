import 'package:equatable/equatable.dart';

enum ProfileStatus { initial, loading, success, failure, openSettings }

class ProfileState extends Equatable {
  const ProfileState({
    this.isNotificationEnabled = false,
    this.status = ProfileStatus.initial,
    this.afterOpenSettings = false,
  });

  final bool isNotificationEnabled;
  final ProfileStatus status;
  final bool afterOpenSettings;

  ProfileState copyWith({
    bool? isNotificationEnabled,
    ProfileStatus? status,
    bool? afterOpenSettings,
  }) {
    return ProfileState(
      isNotificationEnabled:
          isNotificationEnabled ?? this.isNotificationEnabled,
      status: status ?? this.status,
      afterOpenSettings: afterOpenSettings ?? this.afterOpenSettings,
    );
  }

  @override
  List<Object?> get props => [isNotificationEnabled, status, afterOpenSettings];
}
