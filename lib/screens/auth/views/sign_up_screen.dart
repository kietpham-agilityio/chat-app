import 'package:chat_app/core/resources/l10n_generated/l10n.dart';
import 'package:chat_app/core/themes/themes.dart' show CAPalette;
import 'package:chat_app/core/widgets/widgets.dart';
import 'package:chat_app/repositories/repositories.dart' show AuthRepository;
import 'package:chat_app/screens/auth/states/sign_up_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:loader_overlay/loader_overlay.dart';

part 'sign_up_form.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
        appBar: CAAppBar(
          title: CATitleMediumText(text: S.of(context).createAccountTitle),
          leading: CAIconButtons(
            icon: CAAssets.arrowLeft(),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: BlocProvider(
          create: (_) => SignUpCubit(context.read<AuthRepository>()),
          child: BlocListener<SignUpCubit, SignUpState>(
            listener: (context, state) {
              if (state.status.isFailure) {
                WzSnackBar.error(
                  context,
                  message: state.errorMessage ?? S.of(context).errorUnknown,
                );
              }

              if (state.status.isInProgress) {
                context.loaderOverlay.show();
              } else {
                context.loaderOverlay.hide();
              }
            },
            child: _SignUpForm(),
          ),
        ),
      ),
    );
  }
}
