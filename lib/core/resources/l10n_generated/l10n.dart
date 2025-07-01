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
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
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
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `An unknown exception occurred. Please try again.`
  String get errorUnknown {
    return Intl.message(
      'An unknown exception occurred. Please try again.',
      name: 'errorUnknown',
      desc: '',
      args: [],
    );
  }

  /// `This user has been disabled. Please contact support for help.`
  String get errorUserDisabled {
    return Intl.message(
      'This user has been disabled. Please contact support for help.',
      name: 'errorUserDisabled',
      desc: '',
      args: [],
    );
  }

  /// `An account already exists for that email.`
  String get errorEmailAlreadyInUse {
    return Intl.message(
      'An account already exists for that email.',
      name: 'errorEmailAlreadyInUse',
      desc: '',
      args: [],
    );
  }

  /// `Operation is not allowed. Please contact support.`
  String get errorOperationNotAllowed {
    return Intl.message(
      'Operation is not allowed. Please contact support.',
      name: 'errorOperationNotAllowed',
      desc: '',
      args: [],
    );
  }

  /// `Email is not found, please create an account.`
  String get errorEmailNotFound {
    return Intl.message(
      'Email is not found, please create an account.',
      name: 'errorEmailNotFound',
      desc: '',
      args: [],
    );
  }

  /// `Incorrect password, please try again.`
  String get errorWrongPassword {
    return Intl.message(
      'Incorrect password, please try again.',
      name: 'errorWrongPassword',
      desc: '',
      args: [],
    );
  }

  /// `Invalid email format.`
  String get errorInvalidEmail {
    return Intl.message(
      'Invalid email format.',
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

  /// `Phone number format.`
  String get errorInvalidPhoneNumber {
    return Intl.message(
      'Phone number format.',
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

  /// `Failed to send message. Please try again.`
  String get errorFailedToSendMessage {
    return Intl.message(
      'Failed to send message. Please try again.',
      name: 'errorFailedToSendMessage',
      desc: '',
      args: [],
    );
  }

  /// `Failed to create chat room. Please try again.`
  String get errorFailedToCreateChatRoom {
    return Intl.message(
      'Failed to create chat room. Please try again.',
      name: 'errorFailedToCreateChatRoom',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load more messages. Please try again.`
  String get errorFailedToLoadMoreMessages {
    return Intl.message(
      'Failed to load more messages. Please try again.',
      name: 'errorFailedToLoadMoreMessages',
      desc: '',
      args: [],
    );
  }

  /// `Failed to getting am I blocked status. Please try again.`
  String get errorFailedToGettingAmIBlocked {
    return Intl.message(
      'Failed to getting am I blocked status. Please try again.',
      name: 'errorFailedToGettingAmIBlocked',
      desc: '',
      args: [],
    );
  }

  /// `Failed to getting is user blocked status. Please try again.`
  String get errorFailedToGettingIsUserBlocked {
    return Intl.message(
      'Failed to getting is user blocked status. Please try again.',
      name: 'errorFailedToGettingIsUserBlocked',
      desc: '',
      args: [],
    );
  }

  /// `Failed to pick image. Please try again.`
  String get errorFailedToPickImage {
    return Intl.message(
      'Failed to pick image. Please try again.',
      name: 'errorFailedToPickImage',
      desc: '',
      args: [],
    );
  }

  /// `Failed to sign up. Please try again.`
  String get errorFailedToSignUp {
    return Intl.message(
      'Failed to sign up. Please try again.',
      name: 'errorFailedToSignUp',
      desc: '',
      args: [],
    );
  }

  /// `User not found. Please try again.`
  String get errorUserNotFound {
    return Intl.message(
      'User not found. Please try again.',
      name: 'errorUserNotFound',
      desc: '',
      args: [],
    );
  }

  /// `Failed to get user data. Please try again.`
  String get errorFailedToGetUserData {
    return Intl.message(
      'Failed to get user data. Please try again.',
      name: 'errorFailedToGetUserData',
      desc: '',
      args: [],
    );
  }

  /// `User data not found. Please try again.`
  String get errorUserDataNotFound {
    return Intl.message(
      'User data not found. Please try again.',
      name: 'errorUserDataNotFound',
      desc: '',
      args: [],
    );
  }

  /// `Failed to update user data. Please try again.`
  String get errorFailedToUpdateUserData {
    return Intl.message(
      'Failed to update user data. Please try again.',
      name: 'errorFailedToUpdateUserData',
      desc: '',
      args: [],
    );
  }

  /// `Failed to sign out. Please try again.`
  String get errorFailedToSignOut {
    return Intl.message(
      'Failed to sign out. Please try again.',
      name: 'errorFailedToSignOut',
      desc: '',
      args: [],
    );
  }

  /// `Failed to add FCM token. Please try again.`
  String get errorFailedToAddFCMToken {
    return Intl.message(
      'Failed to add FCM token. Please try again.',
      name: 'errorFailedToAddFCMToken',
      desc: '',
      args: [],
    );
  }

  /// `Failed to remove FCM token. Please try again.`
  String get errorFailedToRemoveFCMToken {
    return Intl.message(
      'Failed to remove FCM token. Please try again.',
      name: 'errorFailedToRemoveFCMToken',
      desc: '',
      args: [],
    );
  }

  /// `Failed to sign in. Please try again.`
  String get errorFailedToSignIn {
    return Intl.message(
      'Failed to sign in. Please try again.',
      name: 'errorFailedToSignIn',
      desc: '',
      args: [],
    );
  }

  /// `Failed to get chat rooms. Please try again.`
  String get errorFailedToGetChatRooms {
    return Intl.message(
      'Failed to get chat rooms. Please try again.',
      name: 'errorFailedToGetChatRooms',
      desc: '',
      args: [],
    );
  }

  /// `Failed to search users. Please try again.`
  String get errorFailedToSearchUsers {
    return Intl.message(
      'Failed to search users. Please try again.',
      name: 'errorFailedToSearchUsers',
      desc: '',
      args: [],
    );
  }

  /// `Failed to get messages. Please try again.`
  String get errorFailedToGetMessages {
    return Intl.message(
      'Failed to get messages. Please try again.',
      name: 'errorFailedToGetMessages',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load user info. Please try again.`
  String get errorFailedToLoadUserInfo {
    return Intl.message(
      'Failed to load user info. Please try again.',
      name: 'errorFailedToLoadUserInfo',
      desc: '',
      args: [],
    );
  }

  /// `Failed to mark messages as read. Please try again.`
  String get errorFailedToMarkMessagesAsRead {
    return Intl.message(
      'Failed to mark messages as read. Please try again.',
      name: 'errorFailedToMarkMessagesAsRead',
      desc: '',
      args: [],
    );
  }

  /// `One or both users not found. Please try again.`
  String get errorOneOrBothUsersNotFound {
    return Intl.message(
      'One or both users not found. Please try again.',
      name: 'errorOneOrBothUsersNotFound',
      desc: '',
      args: [],
    );
  }

  /// `Failed to get or create chat room. Please try again.`
  String get errorFailedToGetOrCreateChatRoom {
    return Intl.message(
      'Failed to get or create chat room. Please try again.',
      name: 'errorFailedToGetOrCreateChatRoom',
      desc: '',
      args: [],
    );
  }

  /// `Failed to find chat room existence. Please try again.`
  String get errorFailedToFindChatRoomExistence {
    return Intl.message(
      'Failed to find chat room existence. Please try again.',
      name: 'errorFailedToFindChatRoomExistence',
      desc: '',
      args: [],
    );
  }

  /// `Failed to parse user data. Please try again.`
  String get errorFailedToParseUserData {
    return Intl.message(
      'Failed to parse user data. Please try again.',
      name: 'errorFailedToParseUserData',
      desc: '',
      args: [],
    );
  }

  /// `Unexpected error checking block status. Please try again.`
  String get errorUnexpectedErrorCheckingBlockStatus {
    return Intl.message(
      'Unexpected error checking block status. Please try again.',
      name: 'errorUnexpectedErrorCheckingBlockStatus',
      desc: '',
      args: [],
    );
  }

  /// `Failed to check if user is blocked. Please try again.`
  String get errorFailedToCheckIfUserIsBlocked {
    return Intl.message(
      'Failed to check if user is blocked. Please try again.',
      name: 'errorFailedToCheckIfUserIsBlocked',
      desc: '',
      args: [],
    );
  }

  /// `Failed to block user. Please try again.`
  String get errorFailedToBlockUser {
    return Intl.message(
      'Failed to block user. Please try again.',
      name: 'errorFailedToBlockUser',
      desc: '',
      args: [],
    );
  }

  /// `Failed to unblock user. Please try again.`
  String get errorFailedToUnblockUser {
    return Intl.message(
      'Failed to unblock user. Please try again.',
      name: 'errorFailedToUnblockUser',
      desc: '',
      args: [],
    );
  }

  /// `There was an error getting typing status.`
  String get errorFailedToGetTypingStatus {
    return Intl.message(
      'There was an error getting typing status.',
      name: 'errorFailedToGetTypingStatus',
      desc: '',
      args: [],
    );
  }

  /// `Failed to parse typing status. Please try again.`
  String get errorFailedToParseTypingStatus {
    return Intl.message(
      'Failed to parse typing status. Please try again.',
      name: 'errorFailedToParseTypingStatus',
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

  /// `Country`
  String get generalCountry {
    return Intl.message(
      'Country',
      name: 'generalCountry',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get generalSearch {
    return Intl.message(
      'Search',
      name: 'generalSearch',
      desc: '',
      args: [],
    );
  }

  /// `Unknown User`
  String get generalUnknownUser {
    return Intl.message(
      'Unknown User',
      name: 'generalUnknownUser',
      desc: '',
      args: [],
    );
  }

  /// `Show Password`
  String get semanticShowPassword {
    return Intl.message(
      'Show Password',
      name: 'semanticShowPassword',
      desc: '',
      args: [],
    );
  }

  /// `Hide Password`
  String get semanticHidePassword {
    return Intl.message(
      'Hide Password',
      name: 'semanticHidePassword',
      desc: '',
      args: [],
    );
  }

  /// `Chat with {name}`
  String semanticChatWith(String name) {
    return Intl.message(
      'Chat with $name',
      name: 'semanticChatWith',
      desc: '',
      args: [name],
    );
  }

  /// `Navigate to the personal information editing screen`
  String get semanticGoToEditProfile {
    return Intl.message(
      'Navigate to the personal information editing screen',
      name: 'semanticGoToEditProfile',
      desc: '',
      args: [],
    );
  }

  /// `Go back`
  String get semanticGoBack {
    return Intl.message(
      'Go back',
      name: 'semanticGoBack',
      desc: '',
      args: [],
    );
  }

  /// `More options`
  String get semanticMoreOptions {
    return Intl.message(
      'More options',
      name: 'semanticMoreOptions',
      desc: '',
      args: [],
    );
  }

  /// `Change avatar`
  String get semanticChangeAvatar {
    return Intl.message(
      'Change avatar',
      name: 'semanticChangeAvatar',
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
    return Intl.message(
      'Login',
      name: 'loginBtn',
      desc: '',
      args: [],
    );
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

  /// `Forgot password?`
  String get loginForgotPasswordBtn {
    return Intl.message(
      'Forgot password?',
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

  /// `Chats`
  String get homeTitle {
    return Intl.message(
      'Chats',
      name: 'homeTitle',
      desc: '',
      args: [],
    );
  }

  /// `Let's start chatting`
  String get homeSubTitle {
    return Intl.message(
      'Let\'s start chatting',
      name: 'homeSubTitle',
      desc: '',
      args: [],
    );
  }

  /// `Type in the search bar to find and select a contact to start a new chat.`
  String get homeDescription {
    return Intl.message(
      'Type in the search bar to find and select a contact to start a new chat.',
      name: 'homeDescription',
      desc: '',
      args: [],
    );
  }

  /// `Search for users`
  String get searchDescriptionInitPage {
    return Intl.message(
      'Search for users',
      name: 'searchDescriptionInitPage',
      desc: '',
      args: [],
    );
  }

  /// `No users found`
  String get searchDescriptionEmptyPage {
    return Intl.message(
      'No users found',
      name: 'searchDescriptionEmptyPage',
      desc: '',
      args: [],
    );
  }

  /// `Search contacts`
  String get searchHint {
    return Intl.message(
      'Search contacts',
      name: 'searchHint',
      desc: '',
      args: [],
    );
  }

  /// `Block User`
  String get chatMessageBlockBtn {
    return Intl.message(
      'Block User',
      name: 'chatMessageBlockBtn',
      desc: '',
      args: [],
    );
  }

  /// `Unblock User`
  String get chatMessageUnblockBtn {
    return Intl.message(
      'Unblock User',
      name: 'chatMessageUnblockBtn',
      desc: '',
      args: [],
    );
  }

  /// `Block User`
  String get chatMessageDialogBlockUserTitle {
    return Intl.message(
      'Block User',
      name: 'chatMessageDialogBlockUserTitle',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to block {name}`
  String chatMessageDialogBlockUserContent(String name) {
    return Intl.message(
      'Are you sure you want to block $name',
      name: 'chatMessageDialogBlockUserContent',
      desc: '',
      args: [name],
    );
  }

  /// `Cancel`
  String get chatMessageCancelBtn {
    return Intl.message(
      'Cancel',
      name: 'chatMessageCancelBtn',
      desc: '',
      args: [],
    );
  }

  /// `You've blocked messages from {name}`
  String chatMessageBlockedByMeBannerTitle(String name) {
    return Intl.message(
      'You\'ve blocked messages from $name',
      name: 'chatMessageBlockedByMeBannerTitle',
      desc: '',
      args: [name],
    );
  }

  /// `You have been blocked by {name}`
  String chatMessageBlockedByOtherBannerTitle(String name) {
    return Intl.message(
      'You have been blocked by $name',
      name: 'chatMessageBlockedByOtherBannerTitle',
      desc: '',
      args: [name],
    );
  }

  /// `You can't message {name} in this chat, and you won't receive their messages.`
  String chatMessageBlockedByOtherBannerDescription(String name) {
    return Intl.message(
      'You can\'t message $name in this chat, and you won\'t receive their messages.',
      name: 'chatMessageBlockedByOtherBannerDescription',
      desc: '',
      args: [name],
    );
  }

  /// `Are you sure you want to unblock {name}`
  String chatMessageDialogUnblockUserContent(String name) {
    return Intl.message(
      'Are you sure you want to unblock $name',
      name: 'chatMessageDialogUnblockUserContent',
      desc: '',
      args: [name],
    );
  }

  /// `Start typing...`
  String get chatMessageTextFieldHint {
    return Intl.message(
      'Start typing...',
      name: 'chatMessageTextFieldHint',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profileTitle {
    return Intl.message(
      'Profile',
      name: 'profileTitle',
      desc: '',
      args: [],
    );
  }

  /// `My Account`
  String get profileMyAccountBtn {
    return Intl.message(
      'My Account',
      name: 'profileMyAccountBtn',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get profileLogoutBtn {
    return Intl.message(
      'Logout',
      name: 'profileLogoutBtn',
      desc: '',
      args: [],
    );
  }

  /// `My Account`
  String get myAccountTitle {
    return Intl.message(
      'My Account',
      name: 'myAccountTitle',
      desc: '',
      args: [],
    );
  }

  /// `Update successfully`
  String get myAccountUpdateSuccess {
    return Intl.message(
      'Update successfully',
      name: 'myAccountUpdateSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Choose photo`
  String get myAccountChoosePhoto {
    return Intl.message(
      'Choose photo',
      name: 'myAccountChoosePhoto',
      desc: '',
      args: [],
    );
  }

  /// `Take a photo`
  String get myAccountTakeAPhotoBtn {
    return Intl.message(
      'Take a photo',
      name: 'myAccountTakeAPhotoBtn',
      desc: '',
      args: [],
    );
  }

  /// `Select from gallery`
  String get myAccountSelectFromGalleryBtn {
    return Intl.message(
      'Select from gallery',
      name: 'myAccountSelectFromGalleryBtn',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get myAccountUpdateBtn {
    return Intl.message(
      'Update',
      name: 'myAccountUpdateBtn',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
    ];
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
