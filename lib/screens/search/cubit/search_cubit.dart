import 'package:chat_app/models/models.dart' show UserModel;
import 'package:chat_app/repositories/repositories.dart' show ChatRepository;
import 'package:equatable/equatable.dart' show Equatable;
import 'package:flutter_bloc/flutter_bloc.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit({required ChatRepository chatRepository})
    : _authRepository = chatRepository,
      super(const SearchState());

  final ChatRepository _authRepository;

  Future<void> searchUser(String username) async {
    emit(state.copyWith(status: SearchStatus.loading));

    final res = await _authRepository.searchUser(searchText: username);

    res.fold(
      (l) => emit(
        state.copyWith(errorMessage: l.message, status: SearchStatus.failure),
      ),
      (r) => emit(state.copyWith(users: r.items, status: SearchStatus.success)),
    );
  }
}
