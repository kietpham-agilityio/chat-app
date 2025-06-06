// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(name) => "You\'ve blocked messages from ${name}";

  static String m1(name) =>
      "You can\'t message ${name} in this chat, and you won\'t receive their messages.";

  static String m2(name) => "You have been blocked by ${name}";

  static String m3(name) => "Are you sure you want to block ${name}";

  static String m4(name) => "Are you sure you want to unblock ${name}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "chatMessageBlockBtn":
            MessageLookupByLibrary.simpleMessage("Block User"),
        "chatMessageBlockedByMeBannerTitle": m0,
        "chatMessageBlockedByOtherBannerDescription": m1,
        "chatMessageBlockedByOtherBannerTitle": m2,
        "chatMessageCancelBtn": MessageLookupByLibrary.simpleMessage("Cancel"),
        "chatMessageDialogBlockUserContent": m3,
        "chatMessageDialogBlockUserTitle":
            MessageLookupByLibrary.simpleMessage("Block User"),
        "chatMessageDialogUnblockUserContent": m4,
        "chatMessageTextFieldHint":
            MessageLookupByLibrary.simpleMessage("Start typing..."),
        "chatMessageUnblockBtn":
            MessageLookupByLibrary.simpleMessage("Unblock User"),
        "createAccountBtn":
            MessageLookupByLibrary.simpleMessage("Create an account"),
        "createAccountSubTitle": MessageLookupByLibrary.simpleMessage(
            "Create a new account to start chatting"),
        "createAccountTitle":
            MessageLookupByLibrary.simpleMessage("Create account"),
        "errorEmailAlreadyInUse": MessageLookupByLibrary.simpleMessage(
            "An account already exists for that email."),
        "errorInvalidConfirmedPassword":
            MessageLookupByLibrary.simpleMessage("Passwords do not match"),
        "errorInvalidEmail": MessageLookupByLibrary.simpleMessage(
            "Invalid email format. Example: email@domain"),
        "errorInvalidFullName": MessageLookupByLibrary.simpleMessage(
            "Full name must be at least two words"),
        "errorInvalidPassword": MessageLookupByLibrary.simpleMessage(
            "Must be at 8 characters with letters and numbers"),
        "errorInvalidPhoneNumber": MessageLookupByLibrary.simpleMessage(
            "Phone number format (e.g., 0981234567)"),
        "errorOperationNotAllowed": MessageLookupByLibrary.simpleMessage(
            "Operation is not allowed. Please contact support."),
        "errorUnknown": MessageLookupByLibrary.simpleMessage(
            "An unknown exception occurred. Please try again."),
        "errorUserDisabled": MessageLookupByLibrary.simpleMessage(
            "This user has been disabled. Please contact support for help."),
        "errorUserNotFound": MessageLookupByLibrary.simpleMessage(
            "Email is not found, please create an account."),
        "errorWrongPassword": MessageLookupByLibrary.simpleMessage(
            "Incorrect password, please try again."),
        "generalConfirmedPassword":
            MessageLookupByLibrary.simpleMessage("Confirmed Password"),
        "generalConfirmedPasswordHint":
            MessageLookupByLibrary.simpleMessage("Re-enter your password"),
        "generalEmailAddress":
            MessageLookupByLibrary.simpleMessage("Email Address"),
        "generalEmailAddressHint":
            MessageLookupByLibrary.simpleMessage("Enter your email address"),
        "generalFullName": MessageLookupByLibrary.simpleMessage("Full Name"),
        "generalFullNameHint":
            MessageLookupByLibrary.simpleMessage("Enter your full name"),
        "generalPassword": MessageLookupByLibrary.simpleMessage("Password"),
        "generalPasswordHint":
            MessageLookupByLibrary.simpleMessage("Enter your password"),
        "generalPhoneNumber":
            MessageLookupByLibrary.simpleMessage("Phone Number"),
        "generalPhoneNumberHint":
            MessageLookupByLibrary.simpleMessage("Enter your phone number"),
        "loginBtn": MessageLookupByLibrary.simpleMessage("Login"),
        "loginCreateAccountBtn":
            MessageLookupByLibrary.simpleMessage("Create a new account"),
        "loginForgotPasswordBtn":
            MessageLookupByLibrary.simpleMessage("Forgot your password?"),
        "loginTitle": MessageLookupByLibrary.simpleMessage("Welcome to Chat")
      };
}
