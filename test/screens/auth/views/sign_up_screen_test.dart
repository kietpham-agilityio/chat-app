import 'package:chat_app/core/resources/l10n_generated/l10n.dart';
import 'package:chat_app/repositories/auth_repository.dart';
import 'package:chat_app/screens/auth/states/sign_up_cubit.dart';
import 'package:chat_app/screens/auth/views/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../auth_mocks.dart';

void main() {
  group('SignUpScreen', () {
    late MockAuthRepository mockAuthRepository;

    setUpAll(() async {
      // Initialize localization
      await S.delegate.load(const Locale('en'));
    });

    setUp(() {
      mockAuthRepository = MockAuthRepository();
    });

    Widget createWidgetUnderTest() {
      return MaterialApp(
        localizationsDelegates: const [S.delegate],
        supportedLocales: const [Locale('en')],
        home: RepositoryProvider<AuthRepository>(
          create: (_) => mockAuthRepository,
          child: BlocProvider<SignUpCubit>(
            create: (context) => SignUpCubit(context.read<AuthRepository>()),
            child: const SignUpScreen(),
          ),
        ),
      );
    }

    group('UI Elements', () {
      testWidgets('should display correct placeholder texts', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        expect(find.text('Full Name'), findsOneWidget);
        expect(find.text('Phone Number'), findsOneWidget);
        expect(find.text('Email Address'), findsOneWidget);
        expect(find.text('Password'), findsOneWidget);
        expect(find.text('Confirmed Password'), findsOneWidget);
        expect(find.text('Create an account'), findsOneWidget);
      });
    });

    group('Input Fields', () {
      testWidgets('should update full name when user types', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        final fullNameField = find.byKey(
          const Key('signUpForm_fullnameInput_textField'),
        );
        await tester.enterText(fullNameField, AuthMocks.mockFullName);
        await tester.pump();

        expect(find.text(AuthMocks.mockFullName), findsOneWidget);
      });

      testWidgets('should update phone number when user types', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        final phoneField = find.byKey(
          const Key('signUpForm_phoneNumberInput_textField'),
        );
        await tester.enterText(phoneField, AuthMocks.mockPhoneNumber);
        await tester.pump();

        expect(find.text(AuthMocks.mockPhoneNumber), findsOneWidget);
      });

      testWidgets('should update email when user types', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        final emailField = find.byKey(
          const Key('signUpForm_emailInput_textField'),
        );
        await tester.enterText(emailField, AuthMocks.mockEmail);
        await tester.pump();

        expect(find.text(AuthMocks.mockEmail), findsOneWidget);
      });

      testWidgets('should update password when user types', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        final passwordField = find.byKey(
          const Key('signUpForm_passwordInput_textField'),
        );
        await tester.enterText(passwordField, AuthMocks.mockPassword);
        await tester.pump();

        expect(find.text(AuthMocks.mockPassword), findsOneWidget);
      });

      testWidgets('should update confirmed password when user types', (
        tester,
      ) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        final confirmedPasswordField = find.byKey(
          const Key('signUpForm_confirmedPasswordInput_textField'),
        );
        await tester.enterText(confirmedPasswordField, AuthMocks.mockPassword);
        await tester.pump();

        expect(find.text(AuthMocks.mockPassword), findsOneWidget);
      });
    });

    group('Validation', () {
      testWidgets('should not show error for valid email', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        final emailField = find.byKey(
          const Key('signUpForm_emailInput_textField'),
        );
        await tester.enterText(emailField, AuthMocks.mockEmail);
        await tester.tap(emailField);
        await tester.pump();
        await tester.tapAt(const Offset(0, 0));
        await tester.pump();

        expect(find.text('Invalid email format.'), findsNothing);
      });

      testWidgets('should not show error for valid full name', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        final fullNameField = find.byKey(
          const Key('signUpForm_fullnameInput_textField'),
        );
        await tester.enterText(fullNameField, AuthMocks.mockFullName);
        await tester.tap(fullNameField);
        await tester.pump();
        await tester.tapAt(const Offset(0, 0));
        await tester.pump();

        expect(find.text('Full name must be at least two words'), findsNothing);
      });
    });

    group('Create Account Button', () {
      testWidgets('should be disabled when form is invalid', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        final createAccountBtn = find.text('Create an account');
        final buttonWidget = tester.widget<ElevatedButton>(
          find.ancestor(
            of: createAccountBtn,
            matching: find.byType(ElevatedButton),
          ),
        );
        expect(buttonWidget.enabled, isFalse);
      });
    });
  });
}
