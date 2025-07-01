import 'package:chat_app/core/resources/l10n_generated/l10n.dart';
import 'package:chat_app/repositories/auth_repository.dart';
import 'package:chat_app/screens/auth/states/login_cubit.dart';
import 'package:chat_app/screens/auth/views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../auth_mocks.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  group('LoginScreen', () {
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
          child: BlocProvider<LoginCubit>(
            create: (context) => LoginCubit(context.read<AuthRepository>()),
            child: const LoginScreen(),
          ),
        ),
      );
    }

    group('UI Elements', () {
      testWidgets('should display correct placeholder texts', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        // Check email placeholder
        expect(find.text('Email Address'), findsOneWidget);

        // Check password placeholder
        expect(find.text('Password'), findsOneWidget);
      });
    });

    group('Email Input', () {
      testWidgets('should update email when user types', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        final emailField = find.byKey(
          const Key('loginForm_emailInput_textField'),
        );
        await tester.enterText(emailField, AuthMocks.mockEmail);
        await tester.pump();

        expect(find.text(AuthMocks.mockEmail), findsOneWidget);
      });

      testWidgets('should not show error for valid email', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        final emailField = find.byKey(
          const Key('loginForm_emailInput_textField'),
        );

        // Enter valid email
        await tester.enterText(emailField, AuthMocks.mockEmail);
        await tester.tap(emailField);
        await tester.pump();

        // Tap outside to trigger validation
        await tester.tapAt(const Offset(0, 0));
        await tester.pump();

        // Should not show error message
        expect(find.text('Invalid email address'), findsNothing);
      });
    });

    group('Password Input', () {
      testWidgets('should update password when user types', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        final passwordField = find.byKey(
          const Key('loginForm_passwordInput_textField'),
        );
        await tester.enterText(passwordField, AuthMocks.mockPassword);
        await tester.pump();

        expect(find.text(AuthMocks.mockPassword), findsOneWidget);
      });
    });

    group('Accessibility', () {
      testWidgets('should support keyboard navigation', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        final emailField = find.byKey(
          const Key('loginForm_emailInput_textField'),
        );

        // Focus email field
        await tester.tap(emailField);
        await tester.pump();

        // Navigate to password field
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pump();
      });
    });
  });
}
