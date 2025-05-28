part of 'sign_up_screen.dart';

class _SignUpForm extends StatelessWidget {
  const _SignUpForm();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CAAssets.logo(),
              SizedBox(height: 28),

              CAHeadlineSmallText(text: S.of(context).createAccountSubTitle),
              SizedBox(height: 28),

              _FullNameInput(),
              SizedBox(height: 4),

              _PhoneNumberInput(),
              SizedBox(height: 4),

              _EmailInput(),
              SizedBox(height: 4),

              _PasswordInput(),
              SizedBox(height: 4),

              _ConfirmedPasswordInput(),
              SizedBox(height: 28),

              _CreateAccountBtn(),
            ],
          ),
        ),
      ),
    );
  }
}

class _FullNameInput extends StatelessWidget {
  const _FullNameInput();

  @override
  Widget build(BuildContext context) {
    final focusNode = FocusNode();

    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.fullName != current.fullName,
      builder: (context, state) {
        return CATextField(
          key: const Key('signUpForm_fullnameInput_textField'),
          focusNode: focusNode,
          title: S.of(context).generalFullName,
          hintText: S.of(context).generalFullNameHint,
          errorMessage:
              state.fullName.displayError != null
                  ? S.of(context).errorInvalidFullName
                  : null,
          onChanged:
              (value) => context.read<SignUpCubit>().fullNameChanged(value),
          onFocusLost:
              () => context.read<SignUpCubit>().fullNameValidation(
                state.fullName.value,
              ),
        );
      },
    );
  }
}

class _PhoneNumberInput extends StatelessWidget {
  const _PhoneNumberInput();

  @override
  Widget build(BuildContext context) {
    final focusNode = FocusNode();

    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen:
          (previous, current) => previous.phoneNumber != current.phoneNumber,
      builder: (context, state) {
        return CATextField(
          key: const Key('signUpForm_phoneNumberInput_textField'),
          focusNode: focusNode,
          title: S.of(context).generalPhoneNumber,
          hintText: S.of(context).generalPhoneNumberHint,
          keyboardType: TextInputType.number,
          errorMessage:
              state.phoneNumber.displayError != null
                  ? S.of(context).errorInvalidPhoneNumber
                  : null,
          onChanged:
              (value) => context.read<SignUpCubit>().phoneNumberChanged(value),
          onFocusLost:
              () => context.read<SignUpCubit>().phoneNumberValidation(
                state.phoneNumber.value,
              ),
        );
      },
    );
  }
}

class _EmailInput extends StatelessWidget {
  const _EmailInput();

  @override
  Widget build(BuildContext context) {
    final focusNode = FocusNode();

    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return CATextField(
          key: const Key('signUpForm_emailInput_textField'),
          focusNode: focusNode,
          keyboardType: TextInputType.emailAddress,
          title: S.of(context).generalEmailAddress,
          hintText: S.of(context).generalEmailAddressHint,
          errorMessage:
              state.email.displayError != null
                  ? S.of(context).errorInvalidEmail
                  : null,
          onChanged: (value) => context.read<SignUpCubit>().emailChanged(value),
          onFocusLost:
              () => context.read<SignUpCubit>().emailValidation(
                state.email.value,
              ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  const _PasswordInput();

  @override
  Widget build(BuildContext context) {
    final focusNode = FocusNode();

    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen:
          (previous, current) =>
              previous.password != current.password ||
              previous.isObscuredPassword != current.isObscuredPassword,
      builder: (context, state) {
        return CATextField(
          key: const Key('signUpForm_passwordInput_textField'),
          focusNode: focusNode,
          title: S.of(context).generalPassword,
          hintText: S.of(context).generalPasswordHint,
          obscureText: state.isObscuredPassword,
          errorMessage:
              state.password.displayError != null
                  ? S.of(context).errorInvalidPassword
                  : null,
          suffixIcon: IconButton(
            onPressed: context.read<SignUpCubit>().passwordVisibilityChanged,
            icon: Icon(
              !state.isObscuredPassword
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: CAPalette.grey[5],
            ),
          ),
          onChanged:
              (password) =>
                  context.read<SignUpCubit>().passwordChanged(password),
          onFocusLost:
              () => context.read<SignUpCubit>().passwordValidation(
                state.password.value,
              ),
        );
      },
    );
  }
}

class _ConfirmedPasswordInput extends StatelessWidget {
  const _ConfirmedPasswordInput();

  @override
  Widget build(BuildContext context) {
    final focusNode = FocusNode();

    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen:
          (previous, current) =>
              previous.confirmedPassword != current.confirmedPassword ||
              previous.password != current.password ||
              previous.isObscuredConfirmedPassword !=
                  current.isObscuredConfirmedPassword,
      builder: (context, state) {
        return CATextField(
          key: const Key('signUpForm_confirmedPasswordInput_textField'),
          focusNode: focusNode,
          title: S.of(context).generalConfirmedPassword,
          hintText: S.of(context).generalConfirmedPasswordHint,
          obscureText: state.isObscuredConfirmedPassword,
          errorMessage:
              state.confirmedPassword.displayError != null
                  ? S.of(context).errorInvalidConfirmedPassword
                  : null,
          suffixIcon: IconButton(
            onPressed:
                context.read<SignUpCubit>().confirmedPasswordVisibilityChanged,
            icon: Icon(
              !state.isObscuredConfirmedPassword
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: CAPalette.grey[5],
            ),
          ),
          onChanged:
              (confirmedPassword) => context
                  .read<SignUpCubit>()
                  .confirmedPasswordChanged(confirmedPassword),
          onFocusLost:
              () => context.read<SignUpCubit>().confirmedPasswordValidation(
                state.confirmedPassword.value,
              ),
        );
      },
    );
  }
}

class _CreateAccountBtn extends StatelessWidget {
  const _CreateAccountBtn();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.isValid != current.isValid,
      builder: (context, state) {
        return CAElevatedButton(
          text: S.of(context).loginBtn,
          isDisabled: !state.isValid,
          onPressed: context.read<SignUpCubit>().signUpFormSubmitted,
        );
      },
    );
  }
}
