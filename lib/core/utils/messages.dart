import '../localization/generated/app_localizations.dart';
import '../network/api_exception.dart';

String messageFor(S s, Object error) {
  if (error is ApiException) {
    return switch (error.code) {
      'INVALID_CREDENTIALS' => s.invalidCredentials,
      'ACCOUNT_BANNED' => s.accountBanned,
      'ACCOUNT_INACTIVE' => s.accountInactive,
      'INVALID_OTP' => s.otpFailed,
      'OTP_EXPIRED' => s.otpExpired,
      'TOO_MANY_ATTEMPTS' => s.tooManyAttempts,
      'RESEND_TOO_SOON' => s.resendTooSoon,
      'PHONE_NOT_FOUND' => s.phoneNotFound,
      'EMAIL_IN_USE' => s.emailInUse,
      'PHONE_IN_USE' => s.phoneInUse,
      'OTP_SEND_FAILED' => s.otpSendFailed,
      'FORBIDDEN' => s.forbidden,
      'NETWORK' => s.networkError,
      'SERVER' => s.serverError,
      'UNAUTHORIZED' => s.unauthorizedError,
      'VALIDATION' => error.message ?? s.validationRequired,
      _ => error.message ?? s.unknownError,
    };
  }
  return s.unknownError;
}
