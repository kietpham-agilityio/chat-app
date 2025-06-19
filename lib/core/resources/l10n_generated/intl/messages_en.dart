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
        "errorEmailNotFound": MessageLookupByLibrary.simpleMessage(
            "Email is not found, please create an account."),
        "errorFailedToAddFCMToken": MessageLookupByLibrary.simpleMessage(
            "Failed to add FCM token. Please try again."),
        "errorFailedToBlockUser": MessageLookupByLibrary.simpleMessage(
            "Failed to block user. Please try again."),
        "errorFailedToCheckIfUserIsBlocked":
            MessageLookupByLibrary.simpleMessage(
                "Failed to check if user is blocked. Please try again."),
        "errorFailedToCreateChatRoom": MessageLookupByLibrary.simpleMessage(
            "Failed to create chat room. Please try again."),
        "errorFailedToFindChatRoomExistence":
            MessageLookupByLibrary.simpleMessage(
                "Failed to find chat room existence. Please try again."),
        "errorFailedToGetChatRooms": MessageLookupByLibrary.simpleMessage(
            "Failed to get chat rooms. Please try again."),
        "errorFailedToGetMessages": MessageLookupByLibrary.simpleMessage(
            "Failed to get messages. Please try again."),
        "errorFailedToGetOrCreateChatRoom":
            MessageLookupByLibrary.simpleMessage(
                "Failed to get or create chat room. Please try again."),
        "errorFailedToGetUserData": MessageLookupByLibrary.simpleMessage(
            "Failed to get user data. Please try again."),
        "errorFailedToGettingAmIBlocked": MessageLookupByLibrary.simpleMessage(
            "Failed to getting am I blocked status. Please try again."),
        "errorFailedToGettingIsUserBlocked":
            MessageLookupByLibrary.simpleMessage(
                "Failed to getting is user blocked status. Please try again."),
        "errorFailedToLoadMoreMessages": MessageLookupByLibrary.simpleMessage(
            "Failed to load more messages. Please try again."),
        "errorFailedToLoadUserInfo": MessageLookupByLibrary.simpleMessage(
            "Failed to load user info. Please try again."),
        "errorFailedToMarkMessagesAsRead": MessageLookupByLibrary.simpleMessage(
            "Failed to mark messages as read. Please try again."),
        "errorFailedToParseUserData": MessageLookupByLibrary.simpleMessage(
            "Failed to parse user data. Please try again."),
        "errorFailedToPickImage": MessageLookupByLibrary.simpleMessage(
            "Failed to pick image. Please try again."),
        "errorFailedToRemoveFCMToken": MessageLookupByLibrary.simpleMessage(
            "Failed to remove FCM token. Please try again."),
        "errorFailedToSearchUsers": MessageLookupByLibrary.simpleMessage(
            "Failed to search users. Please try again."),
        "errorFailedToSendMessage": MessageLookupByLibrary.simpleMessage(
            "Failed to send message. Please try again."),
        "errorFailedToSignIn": MessageLookupByLibrary.simpleMessage(
            "Failed to sign in. Please try again."),
        "errorFailedToSignOut": MessageLookupByLibrary.simpleMessage(
            "Failed to sign out. Please try again."),
        "errorFailedToSignUp": MessageLookupByLibrary.simpleMessage(
            "Failed to sign up. Please try again."),
        "errorFailedToUnblockUser": MessageLookupByLibrary.simpleMessage(
            "Failed to unblock user. Please try again."),
        "errorFailedToUpdateUserData": MessageLookupByLibrary.simpleMessage(
            "Failed to update user data. Please try again."),
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
        "errorOneOrBothUsersNotFound": MessageLookupByLibrary.simpleMessage(
            "One or both users not found. Please try again."),
        "errorOperationNotAllowed": MessageLookupByLibrary.simpleMessage(
            "Operation is not allowed. Please contact support."),
        "errorUnexpectedErrorCheckingBlockStatus":
            MessageLookupByLibrary.simpleMessage(
                "Unexpected error checking block status. Please try again."),
        "errorUnknown": MessageLookupByLibrary.simpleMessage(
            "An unknown exception occurred. Please try again."),
        "errorUserDataNotFound": MessageLookupByLibrary.simpleMessage(
            "User data not found. Please try again."),
        "errorUserDisabled": MessageLookupByLibrary.simpleMessage(
            "This user has been disabled. Please contact support for help."),
        "errorUserNotFound": MessageLookupByLibrary.simpleMessage(
            "User not found. Please try again."),
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
        "generalSearch": MessageLookupByLibrary.simpleMessage("Search"),
        "generalUnknownUser":
            MessageLookupByLibrary.simpleMessage("Unknown User"),
        "homeDescription": MessageLookupByLibrary.simpleMessage(
            "Type in the search bar to find and select a contact to start a new chat."),
        "homeSubTitle":
            MessageLookupByLibrary.simpleMessage("Let\'s start chatting"),
        "homeTitle": MessageLookupByLibrary.simpleMessage("Chats"),
        "loginBtn": MessageLookupByLibrary.simpleMessage("Login"),
        "loginCreateAccountBtn":
            MessageLookupByLibrary.simpleMessage("Create a new account"),
        "loginForgotPasswordBtn":
            MessageLookupByLibrary.simpleMessage("Forgot your password?"),
        "loginTitle": MessageLookupByLibrary.simpleMessage("Welcome to Chat"),
        "myAccountChoosePhoto":
            MessageLookupByLibrary.simpleMessage("Choose photo"),
        "myAccountSelectFromGalleryBtn":
            MessageLookupByLibrary.simpleMessage("Select from gallery"),
        "myAccountTakeAPhotoBtn":
            MessageLookupByLibrary.simpleMessage("Take a photo"),
        "myAccountTitle": MessageLookupByLibrary.simpleMessage("My Account"),
        "myAccountUpdateBtn": MessageLookupByLibrary.simpleMessage("Update"),
        "myAccountUpdateSuccess":
            MessageLookupByLibrary.simpleMessage("Update successfully"),
        "profileLogoutBtn": MessageLookupByLibrary.simpleMessage("Logout"),
        "profileMyAccountBtn":
            MessageLookupByLibrary.simpleMessage("My Account"),
        "profileTitle": MessageLookupByLibrary.simpleMessage("Profile"),
        "searchDescriptionEmptyPage":
            MessageLookupByLibrary.simpleMessage("No users found"),
        "searchDescriptionInitPage":
            MessageLookupByLibrary.simpleMessage("Search for users")
      };
}
