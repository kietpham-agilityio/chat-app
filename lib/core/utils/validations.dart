import 'package:formz/formz.dart';

/// Validation errors [FormzInput].
enum ValidationError {
  /// Generic invalid error.
  invalid,
}

// The Email class is a form input validation class for email fields.
// It extends FormzInput with a String value and a ValidationError type.
class Email extends FormzInput<String, ValidationError> {
  // Constructor for an unmodified or "pure" email input.
  const Email.pure([super.value = '']) : super.pure();

  // Constructor for a modified or "dirty" email input.
  const Email.dirty([super.value = '']) : super.dirty();

  // Regular expression to validate the email format.
  static final _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  // Validator method to check if the email format is valid.
  @override
  ValidationError? validator(String value) {
    return _emailRegex.hasMatch(value) ? null : ValidationError.invalid;
  }
}

// Password class extends FormzInput to handle password validation.
// It uses a regular expression to ensure passwords contain at least
// one letter, one number, and are at least 8 characters long.
class Password extends FormzInput<String, ValidationError> {
  // Constructor for pure Password input, representing an unmodified input.
  const Password.pure([super.value = '']) : super.pure();

  // Constructor for dirty Password input, representing a modified input.
  const Password.dirty([super.value = '']) : super.dirty();

  // Regular expression to validate password criteria.
  static final _passwordRegExp = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$',
  );

  @override
  ValidationError? validator(String? value) {
    // Check if the value matches the password criteria.
    return _passwordRegExp.hasMatch(value ?? '')
        ? null
        : ValidationError.invalid;
  }
}
