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
    this.country,
    this.city,
    this.district,
  });

  final String email;
  final String fullName;
  final String phoneNumber;
  final String? country;
  final String? city;
  final String? district;

  @override
  List<Object?> get props => [
    email,
    fullName,
    phoneNumber,
    country,
    city,
    district,
  ];
}

class CountryChangedEvent extends MyAccountEvent {
  const CountryChangedEvent(this.value);

  final String value;

  @override
  List<Object> get props => [value];
}

class CityChangedEvent extends MyAccountEvent {
  const CityChangedEvent(this.value);

  final String value;

  @override
  List<Object> get props => [value];
}

class DistrictChangedEvent extends MyAccountEvent {
  const DistrictChangedEvent(this.value);

  final String value;

  @override
  List<Object> get props => [value];
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

class ClearAddressEvent extends MyAccountEvent {}

class FetchCountriesEvent extends MyAccountEvent {}

class FetchCitiesEvent extends MyAccountEvent {
  const FetchCitiesEvent(this.country);

  final String country;

  @override
  List<Object> get props => [country];
}

class FetchDistrictsEvent extends MyAccountEvent {
  const FetchDistrictsEvent(this.city);

  final String city;

  @override
  List<Object> get props => [city];
}
