import 'dart:async';

import 'package:chat_app/models/conversation.dart';
import 'package:chat_app/models/models.dart' show ChatRoomModel;
import 'package:chat_app/repositories/repositories.dart'
    show ConversationRepository;
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({required ConversationRepository conversationRepository})
    : _repository = conversationRepository,
      super(const HomeState());

  final ConversationRepository _repository;

  Future<void> start(String userId) async {
    // Listen realtime changes
    _repository.listenToRelatedTables(
      userId: userId,
      onChanged: () async {
        final convos = await _repository.fetchUserConversations(userId);
        emit(state.copyWith(conversations: convos, status: HomeStatus.success));
      },
    );

    // Initial fetch
    final convos = await _repository.fetchUserConversations(userId);
    emit(state.copyWith(conversations: convos, status: HomeStatus.success));
  }

  void dispose() {
    // _convoChannel?.unsubscribe();
    // _memberChannel?.unsubscribe();
    // _profileChannel?.unsubscribe();
  }

  @override
  Future<void> close() {
    // _convoChannel?.unsubscribe();
    // _memberChannel?.unsubscribe();
    // _profileChannel?.unsubscribe();
    return super.close();
  }
}
