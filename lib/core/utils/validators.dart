import 'package:email_validator/email_validator.dart';

import '../localization/generated/app_localizations.dart';
import 'phone.dart';

class AppValidators {
  const AppValidators(this.s);

  final S s;

  static final _password = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z0-9]).{8,128}$');

  String? name(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return s.validationName;
    if (text.length < 2 || text.length > 80) return s.validationName;
    return null;
  }

  String? email(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return s.validationRequired;
    if (!EmailValidator.validate(text)) return s.validationEmail;
    return null;
  }

  String? password(String? value) {
    final text = value ?? '';
    if (text.isEmpty) return s.validationRequired;
    if (text.length < 8) return s.validationPassword;
    if (!_password.hasMatch(text)) return s.validationPasswordStrength;
    return null;
  }

  String? confirmPassword(String? value, String original) {
    if ((value ?? '').isEmpty) return s.validationRequired;
    if (value != original) return s.validationPasswordMatch;
    return null;
  }

  String? phone(String? value) {
    if ((value ?? '').trim().isEmpty) return s.validationRequired;
    if (!isValidNationalPhone(value!)) return s.validationPhone;
    return null;
  }

  String? otp(String? value) {
    final text = digitsOnly(value ?? '');
    if (text.length != 6) return s.validationOtp;
    return null;
  }
}
