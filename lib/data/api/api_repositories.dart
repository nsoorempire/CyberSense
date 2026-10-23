import '../../core/network/api_client.dart';
import '../auth_repository.dart';
import '../models.dart';

class ApiAuthRepository implements AuthRepository {
  ApiAuthRepository(this._api);

  final ApiClient _api;

  @override
  Future<OtpChallenge> login({required String email, required String password, required String deviceName}) async {
    final json = await _api.post('/auth/login', {'email': email.trim().toLowerCase(), 'password': password, 'device_name': deviceName}, auth: false);
    return OtpChallenge.fromJson(json);
  }

  @override
  Future<OtpChallenge> register({
    required String fullName,
    required String email,
    required String countryCode,
    required String phone,
    required String password,
    required String deviceName,
  }) async {
    final json = await _api.post('/auth/register', {
      'full_name': fullName.trim(),
      'email': email.trim().toLowerCase(),
      'country_code': countryCode,
      'phone': phone,
      'password': password,
      'device_name': deviceName,
    }, auth: false);
    return OtpChallenge.fromJson(json);
  }

  @override
  Future<AuthResult> verifyOtp({required String challengeId, required String code, required String deviceName}) async {
    final json = await _api.post('/auth/verify-otp', {
      'challenge_id': challengeId,
      'code': code,
      'device_name': deviceName,
    }, auth: false);
    return AuthResult.fromJson(json);
  }

  @override
  Future<OtpChallenge> resendOtp(String challengeId) async {
    final json = await _api.post('/auth/resend-otp', {'challenge_id': challengeId}, auth: false);
    return OtpChallenge.fromJson(json);
  }

  @override
  Future<OtpChallenge> forgotPassword({required String countryCode, required String phone, required String deviceName}) async {
    final json = await _api.post('/auth/forgot-password', {
      'country_code': countryCode,
      'phone': phone,
      'device_name': deviceName,
    }, auth: false);
    return OtpChallenge.fromJson(json);
  }

  @override
  Future<void> resetPassword({required String resetToken, required String newPassword}) async {
    await _api.post('/auth/reset-password', {'reset_token': resetToken, 'new_password': newPassword}, auth: false);
  }

  @override
  Future<UserProfile> me(String accessToken) async {
    return UserProfile.fromJson(await _api.get('/users/me'));
  }

  @override
  Future<void> logout(String accessToken) => _api.delete('/auth/logout');

  @override
  Future<UserProfile> updateProfile({
    required String accessToken,
    required String fullName,
    required String countryCode,
    required String phone,
  }) async {
    final json = await _api.patch('/users/me', {
      'full_name': fullName.trim(),
      'country_code': countryCode,
      'phone': phone,
    });
    return UserProfile.fromJson(json);
  }

  @override
  Future<void> changePassword({
    required String accessToken,
    required String currentPassword,
    required String newPassword,
  }) async {
    await _api.post('/users/me/password', {'current_password': currentPassword, 'new_password': newPassword});
  }
}

class ApiAccountRepository implements AccountRepository {
  ApiAccountRepository(this._api);

  final ApiClient _api;

  @override
  Future<List<LoginActivity>> activity(String accessToken) async {
    final json = await _api.get('/activity');
    return (json['items'] as List).map((item) => LoginActivity.fromJson(Map<String, dynamic>.from(item as Map))).toList();
  }

  @override
  Future<void> revokeAllSessions(String accessToken) => _api.delete('/sessions');

  @override
  Future<void> revokeSession(String accessToken, String sessionId) => _api.delete('/sessions/$sessionId');

  @override
  Future<List<UserSession>> sessions(String accessToken) async {
    final json = await _api.get('/sessions');
    return (json['items'] as List).map((item) => UserSession.fromJson(Map<String, dynamic>.from(item as Map))).toList();
  }

  @override
  Future<UserStats> stats(String accessToken) async => UserStats.fromJson(await _api.get('/users/stats'));

  @override
  Future<UserProfile> updateUser(String accessToken, String userId, {String? role, bool? isActive, bool? isBanned, bool delete = false}) async {
    final json = await _api.patch('/users/$userId', {
      if (role != null) 'role': role,
      if (isActive != null) 'is_active': isActive,
      if (isBanned != null) 'is_banned': isBanned,
      if (delete) 'deleted': true,
    });
    return UserProfile.fromJson(json);
  }

  @override
  Future<List<UserProfile>> users(String accessToken, {String query = '', String status = 'all'}) async {
    final json = await _api.get('/users', query: {
      if (query.trim().isNotEmpty) 'q': query.trim(),
      if (status != 'all') 'status': status,
    });
    return (json['items'] as List).map((item) => UserProfile.fromJson(Map<String, dynamic>.from(item as Map))).toList();
  }
}
