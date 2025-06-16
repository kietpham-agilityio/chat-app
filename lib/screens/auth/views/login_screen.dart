import 'package:chat_app/core/extensions/context_extensions.dart';
import 'package:chat_app/core/resources/l10n_generated/l10n.dart' show S;
import 'package:chat_app/core/router/app_router.dart' show AppPaths;
import 'package:chat_app/core/widgets/assets.dart';
import 'package:chat_app/core/widgets/widgets.dart'
    show CAElevatedButton, CAHeadlineSmallText, CATextField, CASnackBar;
import 'package:chat_app/repositories/repositories.dart' show AuthRepository;
import 'package:chat_app/screens/auth/states/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';

part 'login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
        body: BlocProvider(
          create: (_) => LoginCubit(context.read<AuthRepository>()),
          child: BlocListener<LoginCubit, LoginState>(
            listener: (context, state) {
              if (state.status == LoginStatus.failure) {
                CASnackBar.error(
                  context,
                  message: state.errorMessage ?? S.of(context).errorUnknown,
                );
              }

              if (state.status == LoginStatus.inProgress) {
                context.loaderOverlay.show();
              } else {
                context.loaderOverlay.hide();
              }
            },
            child: _LoginForm(),
          ),
        ),
      ),
    );
  }
}
