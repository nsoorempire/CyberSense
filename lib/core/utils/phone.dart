String digitsOnly(String value) => value.replaceAll(RegExp(r'\D'), '');

String toE164(String dial, String national) {
  final code = digitsOnly(dial);
  final number = digitsOnly(national);
  return '+$code$number';
}

String maskPhone(String e164) {
  if (e164.length <= 6) return e164;
  final start = e164.substring(0, e164.length > 6 ? 4 : 2);
  final end = e164.substring(e164.length - 3);
  return '$start••••$end';
}

bool isValidNationalPhone(String value) {
  final digits = digitsOnly(value);
  return digits.length >= 7 && digits.length <= 12;
}
