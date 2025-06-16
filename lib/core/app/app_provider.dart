import 'package:chat_app/core/notifications/notifications_service.dart';
import 'package:chat_app/core/router/app_router.dart';
import 'package:chat_app/repositories/repositories.dart'
    show AuthRepository, ChatRepository;
import 'package:chat_app/screens/auth/states/auth_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show FirebaseFirestore;
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:firebase_storage/firebase_storage.dart' show FirebaseStorage;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'
    show
        BlocProvider,
        MultiBlocProvider,
        MultiRepositoryProvider,
        ReadContext,
        RepositoryProvider;

class AppProvider extends StatelessWidget {
  const AppProvider({
    required this.child,
    required this.authNotifier,
    super.key,
  });

  final Widget child;
  final AuthNotifier authNotifier;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          lazy: false,
          create: (context) => AuthRepository(
            auth: FirebaseAuth.instance,
            firestore: FirebaseFirestore.instance,
            firebaseStorage: FirebaseStorage.instance,
          ),
        ),
        RepositoryProvider<ChatRepository>(
          lazy: true,
          create: (context) => ChatRepository(
            auth: FirebaseAuth.instance,
            firestore: FirebaseFirestore.instance,
          ),
        ),
        RepositoryProvider<NotificationsService>(
          lazy: false,
          create: (context) {
            final service = NotificationsService();
            service.configure(
              onMessageOpenedApp: (notificationsResponse) {
                NotificationHandler.navigate(
                  notification: notificationsResponse,
                  onChatDetailsRedirect: (notifsRes) {
                    AppRouter.router(authNotifier).pushNamed(
                      AppPaths.chat.name,
                      queryParameters: {
                        'receiverId': notifsRes.accountId,
                        'receiverName': notifsRes.accountName,
                      },
                    );
                  },
                );
              },
            );

            return service;
          },
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
