import 'package:bloc_test/bloc_test.dart';
import 'package:chat_app/core/utils/failure.dart';
import 'package:chat_app/models/models.dart';
import 'package:chat_app/repositories/repositories.dart';
import 'package:chat_app/screens/search/cubit/search_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockChatRepository extends Mock implements ChatRepository {}

class FakeUserModel extends Fake implements UserModel {}

class FakePaginatedResult extends Fake implements PaginatedResult<UserModel> {}

void main() {
  late MockChatRepository mockChatRepository;
  late SearchCubit searchCubit;

  setUpAll(() {
    registerFallbackValue(FakeUserModel());
    registerFallbackValue(FakePaginatedResult());
  });

  setUp(() {
    mockChatRepository = MockChatRepository();
    searchCubit = SearchCubit(chatRepository: mockChatRepository);
  });

  tearDown(() {
    searchCubit.close();
  });

  group('SearchCubit', () {
    const username = 'testuser';
    final user = FakeUserModel();
    final users = [user];
    final paginatedResult = PaginatedResult<UserModel>(
      items: users,
      lastDoc: null,
    );

    blocTest<SearchCubit, SearchState>(
      'emits [loading, success] when searchUser succeeds',
      build: () {
        when(
          () => mockChatRepository.searchUser(searchText: username),
        ).thenAnswer((_) async => Right(paginatedResult));
        return searchCubit;
      },
      act: (cubit) => cubit.searchUser(username),
      expect: () => [
        const SearchState(status: SearchStatus.loading),
        SearchState(users: users, status: SearchStatus.success),
      ],
    );

    blocTest<SearchCubit, SearchState>(
      'emits [loading, failure] when searchUser fails',
      build: () {
        when(
          () => mockChatRepository.searchUser(searchText: username),
        ).thenAnswer((_) async => Left(Failure('error')));
        return searchCubit;
      },
      act: (cubit) => cubit.searchUser(username),
      expect: () => [
        const SearchState(status: SearchStatus.loading),
        const SearchState(status: SearchStatus.failure, errorMessage: 'error'),
      ],
    );
  });
}
