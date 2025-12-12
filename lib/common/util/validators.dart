import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';

/// This file contains some helper functions used for string validation.

abstract class StringValidator {
  bool isValid(String value);
}

class RegexValidator implements StringValidator {
  RegexValidator({required this.regexSource});
  final String regexSource;

  @override
  bool isValid(String value) {
    try {
      final RegExp regex = RegExp(regexSource);
      final Iterable<Match> matches = regex.allMatches(value);
      for (final match in matches) {
        if (match.start == 0 && match.end == value.length) {
          return true;
        }
      }
      return false;
    } catch (e) {
      assert(false, e.toString());
      return true;
    }
  }
}

class ValidatorInputFormatter implements TextInputFormatter {
  ValidatorInputFormatter({required this.editingValidator});
  final StringValidator editingValidator;

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final bool oldValueValid = editingValidator.isValid(oldValue.text);
    final bool newValueValid = editingValidator.isValid(newValue.text);
    if (oldValueValid && !newValueValid) {
      return oldValue;
    }
    return newValue;
  }
}

class EmailEditingRegexValidator extends RegexValidator {
  EmailEditingRegexValidator() : super(regexSource: '^(|\\S)+\$');
}

class EmailSubmitRegexValidator extends RegexValidator {
  EmailSubmitRegexValidator() : super(regexSource: '^\\S+@\\S+\\.\\S+\$');
}

class PasswordSubmitRegexValidator extends RegexValidator {
  PasswordSubmitRegexValidator() : super(regexSource: r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{4,}$');
}

class NonEmptyStringValidator extends StringValidator {
  @override
  bool isValid(String value) {
    return value.isNotEmpty;
  }
}

class MinLengthStringValidator extends StringValidator {
  MinLengthStringValidator(this.minLength);
  final int minLength;

  @override
  bool isValid(String value) {
    return value.length >= minLength;
  }
}

mixin EmailAndPasswordValidators {
  final StringValidator emailSubmitValidator = EmailSubmitRegexValidator();
  final StringValidator passwordMinLengthValidator = MinLengthStringValidator(4);
  final StringValidator passwordSignInSubmitValidator = NonEmptyStringValidator();

  bool canSubmitEmail(String email) {
    return emailSubmitValidator.isValid(email);
  }

  bool minLengthPassword(String password) {
    return passwordMinLengthValidator.isValid(password);
  }

  String? emailErrorText(String email) {
    final bool showErrorText = !canSubmitEmail(email);
    final String errorText = email.isEmpty ? "Enter your ID, please.".tr() : "The email format is not correct.".tr();

    return showErrorText ? errorText : null;
  }

  String? mobileErrorText(String mobile) {
    return mobile.isEmpty ? "error_no_mobile_number".tr() : null;
  }

  String? passwordErrorText(String password) {
    //final bool showErrorText = !minLengthPassword(password);
    final String errorText = password.isEmpty ? "error_no_password".tr() : '';
    return errorText;
  }

  String? passwordConfirmErrorText(String password, String password2) {
    String errorText = "";
    if (password.isEmpty) {
      errorText = "error_no_password".tr();
    } else if (password != password2) {
      errorText = "error_password_not_match".tr();
    }
    return errorText != "" ? errorText : null;
  }

  String? passwordNewErrorText(String password, String password2) {
    final bool showErrorText = (password.isNotEmpty && password2.isNotEmpty && password == password2);
    final String errorText =
        password.isEmpty ? "error_no_password".tr() : "error_same_password".tr();
    return showErrorText ? errorText : null;
  }
}
