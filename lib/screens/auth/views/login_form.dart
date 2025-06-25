part of 'login_screen.dart';

class _LoginForm extends StatelessWidget {
  const _LoginForm();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CAAssets.logo(),
              SizedBox(height: 28),
              CAHeadlineSmallText(text: S.of(context).loginTitle),
              SizedBox(height: 64),
              _EmailInput(),
              SizedBox(height: 16),
              _PasswordInput(),
              _LoginBtn(),
              SizedBox(height: 16),
              _CreateNewAccountBtn(),
              SizedBox(height: 8),
              CATextButtons(text: S.of(context).loginForgotPasswordBtn),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  const _EmailInput();

  @override
  Widget build(BuildContext context) {
    final focusNode = FocusNode();

    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return CATextField(
          key: const Key('loginForm_emailInput_textField'),
          keyboardType: TextInputType.emailAddress,
          focusNode: focusNode,
          onChanged: (value) => context.read<LoginCubit>().emailChanged(value),
          hintText: S.of(context).generalEmailAddress,
          errorMessage: state.email.displayError != null
              ? S.of(context).errorInvalidEmail
              : null,
          onTapOutside: () =>
              context.read<LoginCubit>().emailValidation(state.email.value),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  const _PasswordInput();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) =>
          previous.password != current.password ||
          previous.isObscured != current.isObscured,
      builder: (context, state) {
        return CATextField(
          key: const Key('loginForm_passwordInput_textField'),
          hintText: S.of(context).generalPassword,
          obscureText: state.isObscured,
          onChanged: (password) =>
              context.read<LoginCubit>().passwordChanged(password),
          suffixIcon: IconButton(
            onPressed: context.read<LoginCubit>().passwordVisibilityChanged,
            icon: Semantics(
              label: state.isObscured
                  ? S.of(context).semanticShowPassword
                  : S.of(context).semanticHidePassword,
              child: Icon(
                !state.isObscured
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: context.colorScheme.tertiaryContainer,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _LoginBtn extends StatelessWidget {
  const _LoginBtn();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.isValid != current.isValid,
      builder: (context, state) {
        return CAElevatedButton(
          text: S.of(context).loginBtn,
          isDisabled: !state.isValid,
          onPressed: context.read<LoginCubit>().logInWithCredentials,
        );
      },
    );
  }
}

class _CreateNewAccountBtn extends StatelessWidget {
  const _CreateNewAccountBtn();

  @override
  Widget build(BuildContext context) {
    return CAElevatedButton(
      backgroundColor: context.colorScheme.secondary,
      foregroundColor: context.colorScheme.tertiaryContainer,
      text: S.of(context).loginCreateAccountBtn,
      onPressed: () => context.pushNamed(AppPaths.signUp.name),
    );
  }
}
