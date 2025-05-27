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

  /// `Invalid email`
  String get errorInvalidEmail {
    return Intl.message(
      'Invalid email',
      name: 'errorInvalidEmail',
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

  /// `Password`
  String get generalPassword {
    return Intl.message(
      'Password',
      name: 'generalPassword',
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
