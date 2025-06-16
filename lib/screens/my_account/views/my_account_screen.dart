import 'package:chat_app/core/extensions/context_extensions.dart';
import 'package:chat_app/core/extensions/string_extensions.dart';
import 'package:chat_app/core/resources/l10n_generated/l10n.dart';
import 'package:chat_app/core/widgets/widgets.dart'
    show
        CAAppBar,
        CAAssets,
        CACircleAvatar,
        CAElevatedButton,
        CAHeadlineSmallText,
        CAIconButtons,
        CAListTile,
        CATextField,
        CATitleMediumText,
        CASnackBar;
import 'package:chat_app/repositories/auth_repository.dart';
import 'package:chat_app/screens/my_account/bloc/my_account_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';

class MyAccountScreen extends StatefulWidget {
  const MyAccountScreen({
    super.key,
    required this.email,
    required this.fullName,
    required this.phoneNumber,
    this.avatarUrl,
  });

  final String email;
  final String fullName;
  final String phoneNumber;
  final String? avatarUrl;

  @override
  State<MyAccountScreen> createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  late MyAccountBloc bloc;

  final TextEditingController countryController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController districtsController = TextEditingController();
  final FocusNode countryFocusNode = FocusNode();
  final FocusNode cityFocusNode = FocusNode();
  final FocusNode districtsFocusNode = FocusNode();

  void _showBottomSheet({
    required BuildContext context,
    required MyAccountBloc bloc,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 6),
              Container(
                height: 8,
                width: 32,
                decoration: BoxDecoration(
                  color: context.colorScheme.tertiary,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: CAHeadlineSmallText(text: 'Choose photo'),
                    ),
                    SizedBox(height: 16),
                    CAListTile(
                      title: Text('Take a photo'),
                      leading: CAAssets.camera(),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      onTap: () {
                        bloc.add(AvatarChangedEvent(ImageSource.camera));
                        context.pop();
                      },
                    ),
                    CAListTile(
                      title: Text('Select from gallery'),
                      leading: CAAssets.gallery(),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      onTap: () {
                        bloc.add(AvatarChangedEvent(ImageSource.gallery));
                        context.pop();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    bloc = MyAccountBloc(authRepository: context.read<AuthRepository>());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: BlocProvider(
        create: (context) => bloc
          ..add(
            InitialEvent(
              email: widget.email,
              fullName: widget.fullName,
              phoneNumber: widget.phoneNumber,
              avatarUrl: widget.avatarUrl,
            ),
          ),
        child: BlocListener<MyAccountBloc, MyAccountState>(
          listener: (context, state) {
            if (state.status == MyAccountStatus.loading) {
              context.loaderOverlay.show();
            } else {
              context.loaderOverlay.hide();
            }
            if (state.status == MyAccountStatus.profileUpdated) {
              CASnackBar.success(context, message: 'Updated successfully');
              context.loaderOverlay.hide();
            }
            if (state.status == MyAccountStatus.failure &&
                state.errorMessage != '') {
              CASnackBar.error(context, message: state.errorMessage ?? '');
              context.loaderOverlay.hide();
            }
          },
          child: Scaffold(
            appBar: CAAppBar(
              title: CATitleMediumText(text: 'My Account'),
              leading: CAIconButtons(
                icon: CAAssets.arrowLeft(),
                onPressed: () => context.pop(),
              ),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 22),
                      Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: BlocBuilder<MyAccountBloc, MyAccountState>(
                              builder: (context, state) {
                                if (state.imageFile != null) {
                                  return ClipOval(
                                    child: Image.file(
                                      state.imageFile!.value!,
                                      fit: BoxFit.cover,
                                      width: 96,
                                      height: 96,
                                    ),
                                  );
                                }

                                return Hero(
                                  tag: 'avatar',
                                  child: Material(
                                    color: Colors.transparent,
                                    child: CACircleAvatar(
                                      url:
                                          state.avatarUrl ??
                                          widget.avatarUrl ??
                                          '',
                                      avatarSize: 96,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Positioned(
                            right: -5,
                            child: CAIconButtons(
                              backgroundColor: context.colorScheme.primary,
                              icon: CAAssets.plus(
                                color: context.colorScheme.onPrimary,
                              ),
                              size: 32,
                              onPressed: () => _showBottomSheet(
                                context: context,
                                bloc: bloc,
                              ),
                            ),
                          ),
                        ],
                      ),
                      _EmailInput(),
                      _FullNameInput(),
                      _PhoneNumberInput(),
                      SizedBox(height: 20),
                      _SubmitButton(),
                    ],
                  ),
                ),
              ),
            ),
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
    final TextEditingController emailController = TextEditingController();

    return BlocBuilder<MyAccountBloc, MyAccountState>(
      buildWhen: (previous, current) {
        final shouldRebuild = previous.email != current.email;

        if (shouldRebuild && previous.email.value.isEmpty) {
          emailController.text = current.email.value;
        }

        return shouldRebuild;
      },
      builder: (context, state) {
        return CATextField(
          key: const Key('myAccountForm_emailInput_textField'),
          enabled: false,
          controller: emailController,
          focusNode: focusNode,
          keyboardType: TextInputType.emailAddress,
          title: S.of(context).generalEmailAddress,
          errorMessage: state.email.displayError != null
              ? S.of(context).errorInvalidEmail
              : null,
        );
      },
    );
  }
}

class _FullNameInput extends StatelessWidget {
  const _FullNameInput();

  @override
  Widget build(BuildContext context) {
    final focusNode = FocusNode();
    final TextEditingController fullNameController = TextEditingController();

    return BlocBuilder<MyAccountBloc, MyAccountState>(
      buildWhen: (previous, current) {
        final shouldRebuild = previous.fullName != current.fullName;

        if (shouldRebuild && previous.fullName.value.isEmpty) {
          fullNameController.text = current.fullName.value.capitalizeWords();
        }

        return shouldRebuild;
      },
      builder: (context, state) {
        return CATextField(
          key: const Key('myAccountForm_fullnameInput_textField'),
          focusNode: focusNode,
          controller: fullNameController,
          title: S.of(context).generalFullName,
          errorMessage: state.fullName.displayError != null
              ? S.of(context).errorInvalidFullName
              : null,
          onChanged: (value) =>
              context.read<MyAccountBloc>().add(FullNameChangedEvent(value)),
          onTapOutside: () => context.read<MyAccountBloc>().add(
            FullNameValidationEvent(state.fullName.value),
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
    final TextEditingController phoneNumberController = TextEditingController();

    return BlocBuilder<MyAccountBloc, MyAccountState>(
      buildWhen: (previous, current) {
        final shouldRebuild = previous.phoneNumber != current.phoneNumber;

        if (shouldRebuild && previous.phoneNumber.value.isEmpty) {
          phoneNumberController.text = current.phoneNumber.value;
        }

        return shouldRebuild;
      },
      builder: (context, state) {
        return CATextField(
          key: const Key('signUpForm_phoneNumberInput_textField'),
          focusNode: focusNode,
          controller: phoneNumberController,
          title: S.of(context).generalPhoneNumber,
          keyboardType: TextInputType.number,
          errorMessage: state.phoneNumber.displayError != null
              ? S.of(context).errorInvalidPhoneNumber
              : null,
          onChanged: (value) =>
              context.read<MyAccountBloc>().add(PhoneNumberChangedEvent(value)),
          onTapOutside: () => context.read<MyAccountBloc>().add(
            PhoneNumberValidationEvent(state.phoneNumber.value),
          ),
        );
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<MyAccountBloc, MyAccountState, bool>(
      selector: (MyAccountState state) {
        return state.isValidForm;
      },
      builder: (context, isValid) {
        return CAElevatedButton(
          isDisabled: !isValid,
          onPressed: () =>
              context.read<MyAccountBloc>().add(UpdateUserInfoEvent()),
          text: 'Update',
        );
      },
    );
  }
}
