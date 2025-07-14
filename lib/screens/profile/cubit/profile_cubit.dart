import 'package:chat_app/screens/profile/cubit/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(const ProfileState());

  void onPushNotificationToggleChanged(bool value) async {
    emit(state.copyWith(isNotificationEnabled: value));
  }
}
