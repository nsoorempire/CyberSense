import 'models.dart';

abstract class AuthRepository {
  Future<OtpChallenge> login({required String email, required String password, required String deviceName});

  Future<OtpChallenge> register({
    required String fullName,
    required String email,
    required String countryCode,
    required String phone,
    required String password,
    required String deviceName,
  });

  Future<AuthResult> verifyOtp({required String challengeId, required String code, required String deviceName});

  Future<OtpChallenge> resendOtp(String challengeId);

  Future<OtpChallenge> forgotPassword({required String countryCode, required String phone, required String deviceName});

  Future<void> resetPassword({required String resetToken, required String newPassword});

  Future<UserProfile> me(String accessToken);

  Future<void> logout(String accessToken);

  Future<UserProfile> updateProfile({
    required String accessToken,
    required String fullName,
    required String countryCode,
    required String phone,
  });

  Future<void> changePassword({
    required String accessToken,
    required String currentPassword,
    required String newPassword,
  });
}

abstract class AccountRepository {
  Future<UserStats> stats(String accessToken);

  Future<List<UserProfile>> users(String accessToken, {String query = '', String status = 'all'});

  Future<UserProfile> updateUser(
    String accessToken,
    String userId, {
    String? role,
    bool? isActive,
    bool? isBanned,
    bool delete = false,
  });

  Future<List<LoginActivity>> activity(String accessToken);

  Future<List<UserSession>> sessions(String accessToken);

  Future<void> revokeSession(String accessToken, String sessionId);

  Future<void> revokeAllSessions(String accessToken);
}
