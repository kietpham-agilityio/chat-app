part of 'my_account_bloc.dart';

class MyAccountState extends Equatable {
  final FullName fullName;
  final Email email;
  final PhoneNumber phoneNumber;
  final bool isValid;
  final MyAccountStatus status;

  const MyAccountState({
    this.fullName = const FullName.pure(),
    this.email = const Email.pure(),
    this.phoneNumber = const PhoneNumber.pure(),
    this.isValid = false,
    this.status = MyAccountStatus.initial,
  });

  bool get isEnabledClearButton =>
      (fullName.value.isNotEmpty && fullName.isValid) ||
      (email.value.isNotEmpty && email.isValid) ||
      (phoneNumber.value.isNotEmpty && phoneNumber.isValid);

  MyAccountState copyWith({
    FullName? fullName,
    Email? email,
    PhoneNumber? phoneNumber,
    bool? isValid,
    MyAccountStatus? status,
  }) {
    return MyAccountState(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isValid: isValid ?? this.isValid,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
    fullName,
    email,
    phoneNumber,
    isValid,
    isEnabledClearButton,
    status,
  ];
}

enum MyAccountStatus { initial, loading, success, failure }
