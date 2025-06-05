part of 'my_account_bloc.dart';

abstract class MyAccountEvent extends Equatable {
  const MyAccountEvent();

  @override
  List<Object?> get props => [];
}

class InitialEvent extends MyAccountEvent {
  const InitialEvent({
    required this.email,
    required this.fullName,
    required this.phoneNumber,
    this.avatarUrl,
  });

  final String email;
  final String fullName;
  final String phoneNumber;
  final String? avatarUrl;

  @override
  List<Object?> get props => [email, fullName, phoneNumber, avatarUrl];
}

class FullNameChangedEvent extends MyAccountEvent {
  const FullNameChangedEvent(this.value);

  final String value;

  @override
  List<Object> get props => [value];
}

class FullNameValidationEvent extends MyAccountEvent {
  const FullNameValidationEvent(this.value);

  final String value;

  @override
  List<Object> get props => [value];
}

class PhoneNumberChangedEvent extends MyAccountEvent {
  const PhoneNumberChangedEvent(this.value);

  final String value;

  @override
  List<Object> get props => [value];
}

class PhoneNumberValidationEvent extends MyAccountEvent {
  const PhoneNumberValidationEvent(this.value);

  final String value;

  @override
  List<Object> get props => [value];
}

class AvatarChangedEvent extends MyAccountEvent {
  const AvatarChangedEvent(this.source);

  final ImageSource source;

  @override
  List<Object> get props => [source];
}

class UpdateUserInfoEvent extends MyAccountEvent {
  const UpdateUserInfoEvent();

  @override
  List<Object> get props => [];
}
