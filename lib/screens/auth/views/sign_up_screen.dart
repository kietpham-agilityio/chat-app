import 'package:chat_app/core/resources/l10n_generated/l10n.dart';
import 'package:chat_app/core/themes/themes.dart' show CAPalette;
import 'package:chat_app/core/widgets/widgets.dart';
import 'package:chat_app/screens/auth/cubit/sign_up_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

part 'sign_up_form.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpCubit(),
      child: BlocListener<SignUpCubit, SignUpState>(
        listener: (context, state) {
          if (state.status.isFailure) {
            WzSnackBar.error(
              context,
              message: state.errorMessage ?? S.of(context).errorUnknown,
            );
          }
        },
        child: Scaffold(
          appBar: CAAppBar(
            title: CATitleMediumText(text: S.of(context).createAccountTitle),
            leading: CAIconButtons(
              icon: CAAssets.arrowLeft(),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: _SignUpForm(),
        ),
      ),
    );
  }
}
