// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Something went wrong`
  String get errorUnknown {
    return Intl.message(
      'Something went wrong',
      name: 'errorUnknown',
      desc: '',
      args: [],
    );
  }

  /// `Invalid email format. Example: email@domain`
  String get errorInvalidEmail {
    return Intl.message(
      'Invalid email format. Example: email@domain',
      name: 'errorInvalidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Must be at 8 characters with letters and numbers`
  String get errorInvalidPassword {
    return Intl.message(
      'Must be at 8 characters with letters and numbers',
      name: 'errorInvalidPassword',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get errorInvalidConfirmedPassword {
    return Intl.message(
      'Passwords do not match',
      name: 'errorInvalidConfirmedPassword',
      desc: '',
      args: [],
    );
  }

  /// `Phone number format (e.g., 0981234567)`
  String get errorInvalidPhoneNumber {
    return Intl.message(
      'Phone number format (e.g., 0981234567)',
      name: 'errorInvalidPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Full name must be at least two words`
  String get errorInvalidFullName {
    return Intl.message(
      'Full name must be at least two words',
      name: 'errorInvalidFullName',
      desc: '',
      args: [],
    );
  }

  /// `Email Address`
  String get generalEmailAddress {
    return Intl.message(
      'Email Address',
      name: 'generalEmailAddress',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email address`
  String get generalEmailAddressHint {
    return Intl.message(
      'Enter your email address',
      name: 'generalEmailAddressHint',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get generalPassword {
    return Intl.message(
      'Password',
      name: 'generalPassword',
      desc: '',
      args: [],
    );
  }

  /// `Enter your password`
  String get generalPasswordHint {
    return Intl.message(
      'Enter your password',
      name: 'generalPasswordHint',
      desc: '',
      args: [],
    );
  }

  /// `Confirmed Password`
  String get generalConfirmedPassword {
    return Intl.message(
      'Confirmed Password',
      name: 'generalConfirmedPassword',
      desc: '',
      args: [],
    );
  }

  /// `Re-enter your password`
  String get generalConfirmedPasswordHint {
    return Intl.message(
      'Re-enter your password',
      name: 'generalConfirmedPasswordHint',
      desc: '',
      args: [],
    );
  }

  /// `Full Name`
  String get generalFullName {
    return Intl.message(
      'Full Name',
      name: 'generalFullName',
      desc: '',
      args: [],
    );
  }

  /// `Enter your full name`
  String get generalFullNameHint {
    return Intl.message(
      'Enter your full name',
      name: 'generalFullNameHint',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get generalPhoneNumber {
    return Intl.message(
      'Phone Number',
      name: 'generalPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Enter your phone number`
  String get generalPhoneNumberHint {
    return Intl.message(
      'Enter your phone number',
      name: 'generalPhoneNumberHint',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to Chat`
  String get loginTitle {
    return Intl.message(
      'Welcome to Chat',
      name: 'loginTitle',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get loginBtn {
    return Intl.message('Login', name: 'loginBtn', desc: '', args: []);
  }

  /// `Create a new account`
  String get loginCreateAccountBtn {
    return Intl.message(
      'Create a new account',
      name: 'loginCreateAccountBtn',
      desc: '',
      args: [],
    );
  }

  /// `Forgot your password?`
  String get loginForgotPasswordBtn {
    return Intl.message(
      'Forgot your password?',
      name: 'loginForgotPasswordBtn',
      desc: '',
      args: [],
    );
  }

  /// `Create account`
  String get createAccountTitle {
    return Intl.message(
      'Create account',
      name: 'createAccountTitle',
      desc: '',
      args: [],
    );
  }

  /// `Create a new account to start chatting`
  String get createAccountSubTitle {
    return Intl.message(
      'Create a new account to start chatting',
      name: 'createAccountSubTitle',
      desc: '',
      args: [],
    );
  }

  /// `Create an account`
  String get createAccountBtn {
    return Intl.message(
      'Create an account',
      name: 'createAccountBtn',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[Locale.fromSubtags(languageCode: 'en')];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
