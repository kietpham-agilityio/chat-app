import 'dart:developer' show log;

import 'package:chat_app/core/extensions/context_extensions.dart';
import 'package:chat_app/core/extensions/string_extensions.dart';
import 'package:chat_app/core/router/app_router.dart';
import 'package:chat_app/core/widgets/divider.dart';
import 'package:chat_app/core/widgets/list_tile.dart';
import 'package:chat_app/core/widgets/widgets.dart'
    show
        CAAppBar,
        CAAssets,
        CACircleAvatar,
        CAIconButtons,
        CATextField,
        CATitleMediumText;
import 'package:chat_app/repositories/repositories.dart' show ChatRepository;
import 'package:chat_app/screens/search/cubit/search_cubit.dart'
    show SearchCubit, SearchState, SearchStatus;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: BlocProvider(
        create: (context) =>
            SearchCubit(chatRepository: context.read<ChatRepository>()),
        child: BlocListener<SearchCubit, SearchState>(
          listener: (BuildContext context, SearchState state) {
            if (state.status == SearchStatus.loading) {
              context.loaderOverlay.show();
            } else {
              context.loaderOverlay.hide();
            }
          },
          child: Scaffold(
            appBar: CAAppBar(
              title: CATitleMediumText(text: 'Search'),
              leading: CAIconButtons(
                icon: CAAssets.arrowLeft(),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: Column(
              children: [
                SizedBox(height: 32),
                BlocBuilder<SearchCubit, SearchState>(
                  builder: (context, state) {
                    return Hero(
                      tag: 'searchInputHero',
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: Material(
                          color: Colors.transparent,
                          child: CATextField(
                            key: const Key('searchInput_textField'),
                            suffixIcon: Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: CAAssets.search(
                                width: 24,
                                height: 24,
                                color: context.colorScheme.tertiaryFixed,
                              ),
                            ),
                            onSubmitted: (value) {
                              log("search value: $value");
                              context.read<SearchCubit>().searchUser(value);
                            },
                            autofocus: true,
                            keyboardType: TextInputType.text,
                            hintText: 'Search',
                          ),
                        ),
                      ),
                    );
                  },
                ),
                Expanded(
                  child: BlocBuilder<SearchCubit, SearchState>(
                    builder: (context, state) {
                      if (state.users.isEmpty) {
                        if (state.status == SearchStatus.initial ||
                            state.status == SearchStatus.success) {
                          return const Center(child: Text('Search for users'));
                        } else if (state.status == SearchStatus.failure) {
                          return const Center(child: Text('No users found'));
                        }
                      }

                      return ListView.separated(
                        itemCount: state.users.length,
                        separatorBuilder: (context, index) => const CADivider(),
                        itemBuilder: (_, index) {
                          if (index == state.users.length - 1) {
                            return Column(
                              children: [
                                CAListTile(
                                  title: Text(
                                    state.users[index].fullName
                                        .capitalizeWords(),
                                  ),
                                  leading: CACircleAvatar(
                                    url: state.users[index].avatarUrl ?? '',
                                    avatarSize: 32,
                                  ),
                                  onTap: () {
                                    context.pushNamed(
                                      AppPaths.chat.name,
                                      queryParameters: {
                                        'receiverId': state.users[index].uid,
                                        'receiverName':
                                            state.users[index].fullName,
                                        'receiverAvatarUrl':
                                            state.users[index].avatarUrl,
                                      },
                                    );
                                  },
                                ),
                                CADivider(),
                              ],
                            );
                          }
                          return CAListTile(
                            title: Text(
                              state.users[index].fullName.capitalizeWords(),
                            ),
                            leading: CACircleAvatar(
                              url: state.users[index].avatarUrl ?? '',
                              avatarSize: 32,
                            ),
                            onTap: () {
                              context.pushNamed(
                                AppPaths.chat.name,
                                queryParameters: {
                                  'receiverId': state.users[index].uid,
                                  'receiverName': state.users[index].fullName,
                                  'receiverAvatarUrl':
                                      state.users[index].avatarUrl,
                                },
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
