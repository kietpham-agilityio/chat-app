import 'package:chat_app/core/utils/validations.dart'
    show Email, FullName, PhoneNumber;
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

part 'my_account_event.dart';
part 'my_account_state.dart';

class MyAccountBloc extends Bloc<MyAccountEvent, MyAccountState> {
  MyAccountBloc() : super(const MyAccountState()) {
    on<InitialEvent>(_onInitial);
    on<FullNameChangedEvent>(_onFullNameChanged);
    on<FullNameValidationEvent>(_onFullNameValidation);
    on<PhoneNumberChangedEvent>(_onPhoneNumberChanged);
    on<PhoneNumberValidationEvent>(_onPhoneNumberValidation);
    on<ClearAddressEvent>(_onClear);
  }

  Future<void> _onInitial(
    InitialEvent event,
    Emitter<MyAccountState> emit,
  ) async {
    emit(state.copyWith(status: MyAccountStatus.loading));

    final email = event.email;
    final fullName = event.fullName;
    final phoneNumber = event.phoneNumber;

    emit(
      state.copyWith(
        email: Email.pure(email),
        fullName: FullName.pure(fullName),
        phoneNumber: PhoneNumber.pure(phoneNumber),
        status: MyAccountStatus.success,
      ),
    );
  }

  void _onFullNameChanged(
    FullNameChangedEvent event,
    Emitter<MyAccountState> emit,
  ) {
    final fullName = FullName.pure(event.value);

    emit(state.copyWith(fullName: fullName));
  }

  void _onFullNameValidation(
    FullNameValidationEvent event,
    Emitter<MyAccountState> emit,
  ) {
    final fullName = FullName.dirty(event.value);

    emit(
      state.copyWith(
        fullName: fullName,
        isValid: Formz.validate([fullName, state.phoneNumber]),
      ),
    );
  }

  void _onPhoneNumberChanged(
    PhoneNumberChangedEvent event,
    Emitter<MyAccountState> emit,
  ) {
    final phoneNumber = PhoneNumber.pure(event.value);

    emit(
      state.copyWith(
        phoneNumber: phoneNumber,
        isValid: Formz.validate([state.fullName, phoneNumber]),
      ),
    );
  }

  void _onPhoneNumberValidation(
    PhoneNumberValidationEvent event,
    Emitter<MyAccountState> emit,
  ) {
    final value = event.value;
    final phoneNumber = PhoneNumber.dirty(value);

    emit(
      state.copyWith(
        phoneNumber: phoneNumber,
        isValid: Formz.validate([state.fullName, phoneNumber]),
      ),
    );
  }

  void _onClear(ClearAddressEvent event, Emitter<MyAccountState> emit) {
    emit(state.copyWith(isValid: false, status: MyAccountStatus.success));
  }
}
