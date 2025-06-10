import 'package:chat_app/core/notifications/notifications_service.dart';
import 'package:chat_app/core/router/app_router.dart' show AppPaths, AppRouter;
import 'package:chat_app/repositories/repositories.dart'
    show AuthRepository, ChatRepository;
import 'package:chat_app/screens/auth/states/auth_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show FirebaseFirestore;
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'
    show
        BlocProvider,
        MultiBlocProvider,
        MultiRepositoryProvider,
        ReadContext,
        RepositoryProvider;

class AppProvider extends StatelessWidget {
  const AppProvider({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<FirebaseFirestore>(
          lazy: false,
          create: (context) => FirebaseFirestore.instance,
        ),
        RepositoryProvider<FirebaseAuth>(
          lazy: false,
          create: (context) => FirebaseAuth.instance,
        ),
        RepositoryProvider<AuthRepository>(
          lazy: false,
          create: (context) => AuthRepository(),
        ),
        RepositoryProvider<ChatRepository>(
          lazy: true,
          create: (context) => ChatRepository(),
        ),
        RepositoryProvider<NotificationsService>(
          lazy: false,
          create: (context) => NotificationsService()
            ..configure(
              onReply: (replyNotifis) {},
              onMessageOpenedApp: (notificationsResponse) {
                NotificationHandler.navigate(
                  notification: notificationsResponse,
                  onChatDetailsRedirect: (notifsRes) {
                    AppRouter.router.pushNamed(
                      AppPaths.chat.name,
                      queryParameters: {
                        'receiverId': notifsRes.accountId,
                        'receiverName': notifsRes.accountName,
                      },
                    );
                  },
                );
              },
            ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            lazy: true,
            create: (context) =>
                AuthBloc(authRepository: context.read<AuthRepository>())
                  ..add(const AuthCheckAuthentication()),
          ),
        ],
        child: child,
      ),
    );
  }
}
