part of 'my_account_bloc.dart';

class MyAccountState extends Equatable {
  const MyAccountState({
    this.fullName = const FullName.pure(),
    this.email = const Email.pure(),
    this.phoneNumber = const PhoneNumber.pure(),
    this.country = const CountryInput.pure(),
    this.countries = const [],
    this.isValidForm = false,
    this.status = MyAccountStatus.initial,
    this.imageFile,
    this.avatarUrl,
    this.errorMessage,
  });

  final FullName fullName;
  final Email email;
  final PhoneNumber phoneNumber;
  final CountryInput country;
  final List<String> countries;
  final bool isValidForm;
  final MyAccountStatus status;
  final ImageFile? imageFile;
  final String? avatarUrl;
  final String? errorMessage;

  MyAccountState copyWith({
    FullName? fullName,
    Email? email,
    PhoneNumber? phoneNumber,
    CountryInput? country,
    List<String>? countries,
    bool? isValidForm,
    MyAccountStatus? status,
    ImageFile? imageFile,
    String? errorMessage,
    String? avatarUrl,
  }) {
    return MyAccountState(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      country: country ?? this.country,
      countries: countries ?? this.countries,
      isValidForm: isValidForm ?? this.isValidForm,
      status: status ?? this.status,
      imageFile: imageFile ?? this.imageFile,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    fullName,
    email,
    phoneNumber,
    country,
    countries,
    isValidForm,
    status,
    imageFile,
    avatarUrl,
    errorMessage,
  ];
}

enum MyAccountStatus {
  initial,
  loading,
  success,
  failure,
  profileUpdated,
  countriesFetching,
}
