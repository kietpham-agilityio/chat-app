import 'dart:developer';
import 'dart:io';

import 'package:chat_app/core/utils/validations.dart'
    show ImageFile, Email, FullName, PhoneNumber;
import 'package:chat_app/models/models.dart' show UserModel;
import 'package:chat_app/repositories/repositories.dart' show AuthRepository;
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:image_picker/image_picker.dart' show ImagePicker, ImageSource;
import 'package:permission_handler/permission_handler.dart';

part 'my_account_event.dart';
part 'my_account_state.dart';

class MyAccountBloc extends Bloc<MyAccountEvent, MyAccountState> {
  MyAccountBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const MyAccountState()) {
    on<InitialEvent>(_onInitial);
    on<FullNameChangedEvent>(_onFullNameChanged);
    on<FullNameValidationEvent>(_onFullNameValidation);
    on<PhoneNumberChangedEvent>(_onPhoneNumberChanged);
    on<PhoneNumberValidationEvent>(_onPhoneNumberValidation);
    on<AvatarChangedEvent>(_onChangedAvatar);
    on<UpdateUserInfoEvent>(_onUpdateUserInfo);
  }

  final AuthRepository _authRepository;

  Future<void> _onInitial(
    InitialEvent event,
    Emitter<MyAccountState> emit,
  ) async {
    emit(state.copyWith(status: MyAccountStatus.loading));

    final email = Email.pure(event.email);
    final fullName = FullName.pure(event.fullName);
    final phoneNumber = PhoneNumber.pure(event.phoneNumber);
    final avatarUrl = event.avatarUrl;

    emit(
      state.copyWith(
        email: email,
        fullName: fullName,
        phoneNumber: phoneNumber,
        isValidForm: false,
        status: MyAccountStatus.success,
        avatarUrl: avatarUrl,
      ),
    );
  }

  void _onFullNameChanged(
    FullNameChangedEvent event,
    Emitter<MyAccountState> emit,
  ) {
    final fullName = FullName.pure(event.value);

    emit(state.copyWith(fullName: fullName, status: MyAccountStatus.success));
  }

  void _onFullNameValidation(
    FullNameValidationEvent event,
    Emitter<MyAccountState> emit,
  ) {
    final fullName = FullName.dirty(event.value);

    emit(
      state.copyWith(
        fullName: fullName,
        isValidForm: Formz.validate([fullName, state.phoneNumber]),
        status: MyAccountStatus.success,
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
        isValidForm: Formz.validate([state.fullName, phoneNumber]),
        status: MyAccountStatus.success,
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
        isValidForm: Formz.validate([state.fullName, phoneNumber]),
        status: MyAccountStatus.success,
      ),
    );
  }

  Future<void> _onChangedAvatar(
    AvatarChangedEvent event,
    Emitter<MyAccountState> emit,
  ) async {
    try {
      final picker = ImagePicker();

      if (event.source == ImageSource.camera) {
        final status = await Permission.camera.status;
        if (status.isDenied && Platform.isIOS) {
          await Permission.camera.request();
        } else if (status.isPermanentlyDenied &&
            (Platform.isIOS || Platform.isAndroid)) {
          await openAppSettings();
        }
      }

      final pickedFile = await picker.pickImage(
        source: event.source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        final file = File(pickedFile.path);
        final imageFile = ImageFile.dirty(file);
        emit(
          state.copyWith(
            imageFile: imageFile,
            isValidForm: Formz.validate([
              state.fullName,
              state.email,
              imageFile,
            ]),
            status: MyAccountStatus.success,
          ),
        );
      }
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(errorMessage: 'Failed to pick image'));
    }
  }

  Future<void> _onUpdateUserInfo(
    UpdateUserInfoEvent event,
    Emitter<MyAccountState> emit,
  ) async {
    emit(state.copyWith(status: MyAccountStatus.loading));

    try {
      final user = UserModel(
        uid: FirebaseAuth.instance.currentUser?.uid ?? '',
        fullName: state.fullName.value,
        email: state.email.value,
        phoneNumber: state.phoneNumber.value,
      );
      await _authRepository.updateUserData(
        user: user,
        avatar: state.imageFile?.value,
      );
      emit(
        state.copyWith(
          status: MyAccountStatus.profileUpdated,
          isValidForm: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(errorMessage: "Failed to update user info"));
    }
  }
}
