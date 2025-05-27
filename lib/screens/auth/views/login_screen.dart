import 'package:chat_app/core/resources/l10n_generated/l10n.dart' show S;
import 'package:chat_app/core/router/app_router.dart' show AppPaths;
import 'package:chat_app/core/themes/app_palette.dart' show CAPalette;
import 'package:chat_app/core/widgets/assets.dart';
import 'package:chat_app/core/widgets/buttons.dart';
import 'package:chat_app/core/widgets/text.dart';
import 'package:chat_app/core/widgets/text_field.dart';
import 'package:chat_app/core/widgets/widgets.dart' show WzSnackBar;
import 'package:chat_app/screens/auth/cubit/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';

part 'login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => LoginCubit(),
        child: BlocListener<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state.status.isFailure) {
              WzSnackBar.error(
                context,
                message: state.errorMessage ?? S.of(context).errorUnknown,
              );
            }
          },
          child: _LoginForm(),
        ),
      ),
    );
  }
}
