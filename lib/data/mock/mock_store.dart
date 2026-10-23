// The in-memory records are an implementation detail of this library.
// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_config.dart';
import '../../core/network/api_exception.dart';
import '../../core/utils/phone.dart';
import '../auth_repository.dart';
import '../models.dart';

class MockStore {
  MockStore(this._prefs);

  static Duration latency = const Duration(milliseconds: 420);
  static const _key = 'mock_db_v1';
  static const _maxAttempts = 5;

  final SharedPreferences _prefs;
  final List<_User> users = [];
  final List<_Otp> otps = [];
  final List<_Session> sessions = [];
  final List<_Activity> activities = [];
  final List<_Reset> resets = [];

  Future<void> load() async {
    final raw = _prefs.getString(_key);
    if (raw == null) {
      _seed();
      await save();
      return;
    }
    final data = jsonDecode(raw) as Map<String, dynamic>;
    users
      ..clear()
      ..addAll((data['users'] as List).map((item) => _User.fromJson(Map<String, dynamic>.from(item as Map))));
    otps
      ..clear()
      ..addAll((data['otps'] as List).map((item) => _Otp.fromJson(Map<String, dynamic>.from(item as Map))));
    sessions
      ..clear()
      ..addAll((data['sessions'] as List).map((item) => _Session.fromJson(Map<String, dynamic>.from(item as Map))));
    activities
      ..clear()
      ..addAll((data['activities'] as List).map((item) => _Activity.fromJson(Map<String, dynamic>.from(item as Map))));
    resets
      ..clear()
      ..addAll((data['resets'] as List).map((item) => _Reset.fromJson(Map<String, dynamic>.from(item as Map))));
  }

  Future<void> save() async {
    final data = {
      'users': users.map((item) => item.toJson()).toList(),
      'otps': otps.map((item) => item.toJson()).toList(),
      'sessions': sessions.map((item) => item.toJson()).toList(),
      'activities': activities.map((item) => item.toJson()).toList(),
      'resets': resets.map((item) => item.toJson()).toList(),
    };
    await _prefs.setString(_key, jsonEncode(data));
  }

  void _seed() {
    final now = DateTime.now().toUtc();
    final admin = _User(
      id: '11111111-1111-4111-8111-111111111111',
      fullName: 'Cyber Sense Admin',
      email: AppConfig.demoAdminEmail,
      countryCode: '+971',
      phoneNational: '500000001',
      phoneE164: '+971500000001',
      passwordHash: hashSecret(AppConfig.demoAdminPassword),
      role: 'admin',
      isActive: true,
      isBanned: false,
      isVerified: true,
      createdAt: now.subtract(const Duration(days: 120)),
    );
    final user = _User(
      id: '22222222-2222-4222-8222-222222222222',
      fullName: 'Lina Haddad',
      email: AppConfig.demoUserEmail,
      countryCode: '+971',
      phoneNational: '500000002',
      phoneE164: '+971500000002',
      passwordHash: hashSecret(AppConfig.demoUserPassword),
      role: 'user',
      isActive: true,
      isBanned: false,
      isVerified: true,
      createdAt: now.subtract(const Duration(days: 40)),
      lastLoginAt: now.subtract(const Duration(hours: 5)),
    );
    users.addAll([
      admin,
      user,
      _person('Sara Ahmed', 'sara@cybersense.app', '500000003', 'user', now.subtract(const Duration(days: 18)), active: true),
      _person('Omar Hassan', 'omar@cybersense.app', '500000004', 'user', now.subtract(const Duration(days: 12)), banned: true),
      _person('Maya Khalid', 'maya@cybersense.app', '500000005', 'user', now.subtract(const Duration(days: 9)), active: false),
      _person('Yusuf Nasser', 'yusuf@cybersense.app', '500000006', 'user', now.subtract(const Duration(days: 4))),
      _person('Huda Ali', 'huda@cybersense.app', '500000007', 'admin', now.subtract(const Duration(days: 60))),
      _person('Karim Fadel', 'karim@cybersense.app', '500000008', 'user', now.subtract(const Duration(days: 2)), banned: true),
    ]);
    activities.addAll([
      _Activity(id: _id(), userId: user.id, userName: user.fullName, email: user.email, success: true, deviceName: 'iOS 18', ipAddress: '10.0.0.8', createdAt: now.subtract(const Duration(hours: 5))),
      _Activity(id: _id(), userId: user.id, userName: user.fullName, email: user.email, success: false, deviceName: 'Android 15', ipAddress: '10.0.0.14', reason: 'INVALID_CREDENTIALS', createdAt: now.subtract(const Duration(days: 1))),
      _Activity(id: _id(), userId: admin.id, userName: admin.fullName, email: admin.email, success: true, deviceName: 'macOS', ipAddress: '10.0.0.2', createdAt: now.subtract(const Duration(hours: 2))),
    ]);
  }

  _User _person(String name, String email, String phone, String role, DateTime created, {bool active = true, bool banned = false}) {
    return _User(
      id: _id(),
      fullName: name,
      email: email,
      countryCode: '+971',
      phoneNational: phone,
      phoneE164: '+971$phone',
      passwordHash: hashSecret('Demo#2026'),
      role: role,
      isActive: active,
      isBanned: banned,
      isVerified: true,
      createdAt: created,
    );
  }
}

String hashSecret(String value) => sha256.convert(utf8.encode('cybersense-mock::$value')).toString();

String _id() {
  final random = Random.secure();
  final bytes = List<int>.generate(16, (_) => random.nextInt(256));
  bytes[6] = (bytes[6] & 0x0f) | 0x40;
  bytes[8] = (bytes[8] & 0x3f) | 0x80;
  final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20)}';
}

class MockAuthRepository implements AuthRepository {
  MockAuthRepository(this.store);

  final MockStore store;

  Future<T> _pause<T>(T value) async {
    if (MockStore.latency > Duration.zero) await Future<void>.delayed(MockStore.latency);
    return value;
  }

  @override
  Future<OtpChallenge> login({required String email, required String password, required String deviceName}) async {
    final user = _byEmail(email);
    if (user == null || user.deletedAt != null || user.passwordHash != hashSecret(password)) {
      _log(email: email, user: user, success: false, deviceName: deviceName, reason: 'INVALID_CREDENTIALS');
      await store.save();
      await _pause(null);
      throw const ApiException(code: 'INVALID_CREDENTIALS');
    }
    if (user.isBanned) {
      _log(email: email, user: user, success: false, deviceName: deviceName, reason: 'ACCOUNT_BANNED');
      await store.save();
      await _pause(null);
      throw const ApiException(code: 'ACCOUNT_BANNED');
    }
    if (!user.isActive) {
      _log(email: email, user: user, success: false, deviceName: deviceName, reason: 'ACCOUNT_INACTIVE');
      await store.save();
      await _pause(null);
      throw const ApiException(code: 'ACCOUNT_INACTIVE');
    }
    final challenge = _issue(phone: user.phoneE164, purpose: 'login', userId: user.id, deviceName: deviceName);
    await store.save();
    return _pause(challenge);
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
    final normalized = email.trim().toLowerCase();
    final e164 = toE164(countryCode, phone);
    if (store.users.any((item) => item.deletedAt == null && item.email == normalized)) {
      await _pause(null);
      throw const ApiException(code: 'EMAIL_IN_USE');
    }
    if (store.users.any((item) => item.deletedAt == null && item.phoneE164 == e164)) {
      await _pause(null);
      throw const ApiException(code: 'PHONE_IN_USE');
    }
    final challenge = _issue(
      phone: e164,
      purpose: 'signup',
      deviceName: deviceName,
      pending: {
        'full_name': fullName.trim(),
        'email': normalized,
        'country_code': countryCode,
        'phone_national': digitsOnly(phone),
        'phone_e164': e164,
        'password_hash': hashSecret(password),
      },
    );
    await store.save();
    return _pause(challenge);
  }

  @override
  Future<AuthResult> verifyOtp({required String challengeId, required String code, required String deviceName}) async {
    final otp = _otp(challengeId);
    _ensureUsable(otp);
    if (otp.code != code.trim()) {
      otp.attempts += 1;
      await store.save();
      await _pause(null);
      final left = MockStore._maxAttempts - otp.attempts;
      if (left <= 0) throw const ApiException(code: 'TOO_MANY_ATTEMPTS', attemptsLeft: 0);
      throw ApiException(code: 'INVALID_OTP', attemptsLeft: left);
    }
    otp.consumedAt = DateTime.now().toUtc();
    if (otp.purpose == 'reset') {
      final token = _id();
      store.resets.add(_Reset(token: token, userId: otp.userId!, expiresAt: DateTime.now().toUtc().add(const Duration(minutes: 10))));
      await store.save();
      return _pause(AuthResult(resetToken: token));
    }
    late _User user;
    if (otp.purpose == 'signup') {
      final pending = otp.pending!;
      user = _User(
        id: _id(),
        fullName: pending['full_name']!,
        email: pending['email']!,
        countryCode: pending['country_code']!,
        phoneNational: pending['phone_national']!,
        phoneE164: pending['phone_e164']!,
        passwordHash: pending['password_hash']!,
        role: 'user',
        isActive: true,
        isBanned: false,
        isVerified: true,
        createdAt: DateTime.now().toUtc(),
      );
      store.users.add(user);
    } else {
      user = store.users.firstWhere((item) => item.id == otp.userId);
    }
    user.lastLoginAt = DateTime.now().toUtc();
    final session = _openSession(user.id, deviceName);
    _log(email: user.email, user: user, success: true, deviceName: deviceName);
    await store.save();
    return _pause(AuthResult(accessToken: 'mock.${user.id}.${session.id}', refreshToken: session.refresh, user: user.profile));
  }

  @override
  Future<OtpChallenge> resendOtp(String challengeId) async {
    final otp = _otp(challengeId);
    if (otp.consumedAt != null) {
      await _pause(null);
      throw const ApiException(code: 'OTP_EXPIRED');
    }
    final wait = otp.createdAt.add(const Duration(seconds: 60)).difference(DateTime.now().toUtc());
    if (!wait.isNegative && wait.inSeconds > 0) {
      await _pause(null);
      throw const ApiException(code: 'RESEND_TOO_SOON');
    }
    otp.code = _code();
    otp.attempts = 0;
    otp.createdAt = DateTime.now().toUtc();
    otp.expiresAt = otp.createdAt.add(const Duration(minutes: 5));
    await store.save();
    return _pause(_challenge(otp));
  }

  @override
  Future<OtpChallenge> forgotPassword({required String countryCode, required String phone, required String deviceName}) async {
    final e164 = toE164(countryCode, phone);
    _User? user;
    for (final item in store.users) {
      if (item.deletedAt == null && item.phoneE164 == e164) {
        user = item;
        break;
      }
    }
    if (user == null) {
      await _pause(null);
      throw const ApiException(code: 'PHONE_NOT_FOUND');
    }
    if (user.isBanned) {
      await _pause(null);
      throw const ApiException(code: 'ACCOUNT_BANNED');
    }
    final challenge = _issue(phone: e164, purpose: 'reset', userId: user.id, deviceName: deviceName);
    await store.save();
    return _pause(challenge);
  }

  @override
  Future<void> resetPassword({required String resetToken, required String newPassword}) async {
    _Reset? reset;
    for (final item in store.resets) {
      if (item.token == resetToken && item.usedAt == null) {
        reset = item;
        break;
      }
    }
    if (reset == null || reset.expiresAt.isBefore(DateTime.now().toUtc())) {
      await _pause(null);
      throw const ApiException(code: 'OTP_EXPIRED');
    }
    final user = store.users.firstWhere((item) => item.id == reset!.userId);
    user.passwordHash = hashSecret(newPassword);
    reset.usedAt = DateTime.now().toUtc();
    for (final session in store.sessions.where((item) => item.userId == user.id && item.revokedAt == null)) {
      session.revokedAt = DateTime.now().toUtc();
    }
    await store.save();
    await _pause(null);
  }

  @override
  Future<UserProfile> me(String accessToken) async {
    final session = _sessionFromToken(accessToken);
    final user = store.users.firstWhere((item) => item.id == session.userId);
    return _pause(user.profile);
  }

  @override
  Future<void> logout(String accessToken) async {
    final session = _sessionFromToken(accessToken);
    session.revokedAt = DateTime.now().toUtc();
    await store.save();
    await _pause(null);
  }

  @override
  Future<UserProfile> updateProfile({
    required String accessToken,
    required String fullName,
    required String countryCode,
    required String phone,
  }) async {
    final session = _sessionFromToken(accessToken);
    final user = store.users.firstWhere((item) => item.id == session.userId);
    final e164 = toE164(countryCode, phone);
    if (store.users.any((item) => item.id != user.id && item.deletedAt == null && item.phoneE164 == e164)) {
      await _pause(null);
      throw const ApiException(code: 'PHONE_IN_USE');
    }
    user
      ..fullName = fullName.trim()
      ..countryCode = countryCode
      ..phoneNational = digitsOnly(phone)
      ..phoneE164 = e164;
    await store.save();
    return _pause(user.profile);
  }

  @override
  Future<void> changePassword({
    required String accessToken,
    required String currentPassword,
    required String newPassword,
  }) async {
    final session = _sessionFromToken(accessToken);
    final user = store.users.firstWhere((item) => item.id == session.userId);
    if (user.passwordHash != hashSecret(currentPassword)) {
      await _pause(null);
      throw const ApiException(code: 'INVALID_CREDENTIALS');
    }
    user.passwordHash = hashSecret(newPassword);
    await store.save();
    await _pause(null);
  }

  _User? _byEmail(String email) {
    final normalized = email.trim().toLowerCase();
    for (final user in store.users) {
      if (user.email == normalized) return user;
    }
    return null;
  }

  _Otp _otp(String id) {
    for (final otp in store.otps) {
      if (otp.id == id) return otp;
    }
    throw const ApiException(code: 'INVALID_OTP');
  }

  void _ensureUsable(_Otp otp) {
    if (otp.consumedAt != null) throw const ApiException(code: 'INVALID_OTP');
    if (otp.expiresAt.isBefore(DateTime.now().toUtc())) throw const ApiException(code: 'OTP_EXPIRED');
    if (otp.attempts >= MockStore._maxAttempts) throw const ApiException(code: 'TOO_MANY_ATTEMPTS', attemptsLeft: 0);
  }

  OtpChallenge _issue({required String phone, required String purpose, String? userId, required String deviceName, Map<String, String>? pending}) {
    for (final existing in store.otps.where((item) => item.phone == phone && item.purpose == purpose && item.consumedAt == null)) {
      existing.consumedAt = DateTime.now().toUtc();
    }
    final otp = _Otp(
      id: _id(),
      userId: userId,
      phone: phone,
      purpose: purpose,
      code: _code(),
      createdAt: DateTime.now().toUtc(),
      expiresAt: DateTime.now().toUtc().add(const Duration(minutes: 5)),
      pending: pending,
      deviceName: deviceName,
    );
    store.otps.add(otp);
    return _challenge(otp);
  }

  OtpChallenge _challenge(_Otp otp) {
    return OtpChallenge(
      id: otp.id,
      maskedPhone: maskPhone(otp.phone),
      purpose: otp.purpose,
      expiresIn: 300,
      resendIn: 60,
      attemptsLeft: MockStore._maxAttempts - otp.attempts,
      devCode: otp.code,
    );
  }

  _Session _openSession(String userId, String deviceName) {
    final session = _Session(
      id: _id(),
      userId: userId,
      refresh: _id(),
      deviceName: deviceName,
      ipAddress: '10.0.0.8',
      createdAt: DateTime.now().toUtc(),
      lastUsedAt: DateTime.now().toUtc(),
    );
    store.sessions.add(session);
    return session;
  }

  _Session _sessionFromToken(String token) {
    final parts = token.split('.');
    if (parts.length < 3) throw const ApiException(code: 'UNAUTHORIZED');
    for (final session in store.sessions) {
      if (session.id == parts[2] && session.revokedAt == null && session.userId == parts[1]) {
        session.lastUsedAt = DateTime.now().toUtc();
        return session;
      }
    }
    throw const ApiException(code: 'UNAUTHORIZED');
  }

  void _log({required String email, _User? user, required bool success, required String deviceName, String? reason}) {
    store.activities.insert(
      0,
      _Activity(
        id: _id(),
        userId: user?.id,
        userName: user?.fullName,
        email: email.trim().toLowerCase(),
        success: success,
        deviceName: deviceName,
        ipAddress: '10.0.0.8',
        reason: reason,
        createdAt: DateTime.now().toUtc(),
      ),
    );
  }

  String _code() => (100000 + Random.secure().nextInt(900000)).toString();
}

class MockAccountRepository implements AccountRepository {
  MockAccountRepository(this.store);

  final MockStore store;

  @override
  Future<UserStats> stats(String accessToken) async {
    _requireAdmin(accessToken);
    final visible = store.users.where((item) => item.deletedAt == null);
    return UserStats(
      total: visible.length,
      active: visible.where((item) => item.isActive && !item.isBanned).length,
      banned: visible.where((item) => item.isBanned).length,
      inactive: visible.where((item) => !item.isActive && !item.isBanned).length,
    );
  }

  @override
  Future<List<UserProfile>> users(String accessToken, {String query = '', String status = 'all'}) async {
    _requireAdmin(accessToken);
    final q = query.trim().toLowerCase();
    final list = store.users.where((item) {
      if (item.deletedAt != null) return false;
      final matchesStatus = switch (status) {
        'active' => item.isActive && !item.isBanned,
        'banned' => item.isBanned,
        'inactive' => !item.isActive && !item.isBanned,
        _ => true,
      };
      if (!matchesStatus) return false;
      if (q.isEmpty) return true;
      return item.fullName.toLowerCase().contains(q) || item.email.contains(q) || item.phoneE164.contains(q);
    }).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list.map((item) => item.profile).toList();
  }

  @override
  Future<UserProfile> updateUser(String accessToken, String userId, {String? role, bool? isActive, bool? isBanned, bool delete = false}) async {
    final actor = _requireAdmin(accessToken);
    final user = store.users.firstWhere((item) => item.id == userId, orElse: () => throw const ApiException(code: 'UNKNOWN'));
    if (actor.id == user.id && (role != null || isActive != null || isBanned != null || delete)) {
      throw const ApiException(code: 'FORBIDDEN');
    }
    if (delete) {
      user.deletedAt = DateTime.now().toUtc();
      for (final session in store.sessions.where((item) => item.userId == user.id)) {
        session.revokedAt ??= DateTime.now().toUtc();
      }
    } else {
      if (role != null) user.role = role;
      if (isActive != null) user.isActive = isActive;
      if (isBanned != null) {
        user.isBanned = isBanned;
        if (isBanned) user.isActive = false;
        if (!isBanned && !user.isActive) user.isActive = true;
      }
    }
    await store.save();
    return user.profile;
  }

  @override
  Future<List<LoginActivity>> activity(String accessToken) async {
    final actor = _actor(accessToken);
    final rows = actor.role == 'admin' ? store.activities : store.activities.where((item) => item.userId == actor.id);
    final list = rows.toList()..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list
        .take(50)
        .map((item) => LoginActivity(
              id: item.id,
              userName: item.userName,
              email: item.email,
              success: item.success,
              deviceName: item.deviceName,
              ipAddress: item.ipAddress,
              reason: item.reason,
              createdAt: item.createdAt,
            ))
        .toList();
  }

  @override
  Future<List<UserSession>> sessions(String accessToken) async {
    final actor = _actor(accessToken);
    final currentId = accessToken.split('.')[2];
    final rows = store.sessions.where((item) => item.userId == actor.id && item.revokedAt == null).toList()
      ..sort((a, b) => b.lastUsedAt.compareTo(a.lastUsedAt));
    return rows
        .map((item) => UserSession(
              id: item.id,
              deviceName: item.deviceName,
              ipAddress: item.ipAddress,
              createdAt: item.createdAt,
              lastUsedAt: item.lastUsedAt,
              current: item.id == currentId,
            ))
        .toList();
  }

  @override
  Future<void> revokeSession(String accessToken, String sessionId) async {
    final actor = _actor(accessToken);
    final session = store.sessions.firstWhere((item) => item.id == sessionId && item.userId == actor.id);
    session.revokedAt = DateTime.now().toUtc();
    await store.save();
  }

  @override
  Future<void> revokeAllSessions(String accessToken) async {
    final actor = _actor(accessToken);
    for (final session in store.sessions.where((item) => item.userId == actor.id && item.revokedAt == null)) {
      session.revokedAt = DateTime.now().toUtc();
    }
    await store.save();
  }

  _User _actor(String accessToken) {
    final parts = accessToken.split('.');
    if (parts.length < 3) throw const ApiException(code: 'UNAUTHORIZED');
    final alive = store.sessions.any((item) => item.id == parts[2] && item.revokedAt == null);
    if (!alive) throw const ApiException(code: 'UNAUTHORIZED');
    return store.users.firstWhere((item) => item.id == parts[1] && item.deletedAt == null);
  }

  _User _requireAdmin(String accessToken) {
    final user = _actor(accessToken);
    if (user.role != 'admin') throw const ApiException(code: 'FORBIDDEN');
    return user;
  }
}

class _User {
  _User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.countryCode,
    required this.phoneNational,
    required this.phoneE164,
    required this.passwordHash,
    required this.role,
    required this.isActive,
    required this.isBanned,
    required this.isVerified,
    required this.createdAt,
    this.lastLoginAt,
    this.deletedAt,
  });

  final String id;
  String fullName;
  String email;
  String countryCode;
  String phoneNational;
  String phoneE164;
  String passwordHash;
  String role;
  bool isActive;
  bool isBanned;
  bool isVerified;
  DateTime createdAt;
  DateTime? lastLoginAt;
  DateTime? deletedAt;

  UserProfile get profile => UserProfile(
        id: id,
        fullName: fullName,
        email: email,
        countryCode: countryCode,
        phoneNational: phoneNational,
        phoneE164: phoneE164,
        role: role,
        isActive: isActive,
        isBanned: isBanned,
        isVerified: isVerified,
        createdAt: createdAt,
        lastLoginAt: lastLoginAt,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'full_name': fullName,
        'email': email,
        'country_code': countryCode,
        'phone_national': phoneNational,
        'phone_e164': phoneE164,
        'password_hash': passwordHash,
        'role': role,
        'is_active': isActive,
        'is_banned': isBanned,
        'is_verified': isVerified,
        'created_at': createdAt.toIso8601String(),
        'last_login_at': lastLoginAt?.toIso8601String(),
        'deleted_at': deletedAt?.toIso8601String(),
      };

  factory _User.fromJson(Map<String, dynamic> json) => _User(
        id: json['id'] as String,
        fullName: json['full_name'] as String,
        email: json['email'] as String,
        countryCode: json['country_code'] as String,
        phoneNational: json['phone_national'] as String,
        phoneE164: json['phone_e164'] as String,
        passwordHash: json['password_hash'] as String,
        role: json['role'] as String,
        isActive: json['is_active'] as bool,
        isBanned: json['is_banned'] as bool,
        isVerified: json['is_verified'] as bool,
        createdAt: DateTime.parse(json['created_at'] as String),
        lastLoginAt: json['last_login_at'] == null ? null : DateTime.parse(json['last_login_at'] as String),
        deletedAt: json['deleted_at'] == null ? null : DateTime.parse(json['deleted_at'] as String),
      );
}

class _Otp {
  _Otp({
    required this.id,
    required this.phone,
    required this.purpose,
    required this.code,
    required this.createdAt,
    required this.expiresAt,
    this.userId,
    this.pending,
    this.deviceName = '',
    this.attempts = 0,
    this.consumedAt,
  });

  final String id;
  String? userId;
  String phone;
  String purpose;
  String code;
  DateTime createdAt;
  DateTime expiresAt;
  int attempts;
  DateTime? consumedAt;
  Map<String, String>? pending;
  String deviceName;

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'phone': phone,
        'purpose': purpose,
        'code': code,
        'created_at': createdAt.toIso8601String(),
        'expires_at': expiresAt.toIso8601String(),
        'attempts': attempts,
        'consumed_at': consumedAt?.toIso8601String(),
        'pending': pending,
        'device_name': deviceName,
      };

  factory _Otp.fromJson(Map<String, dynamic> json) => _Otp(
        id: json['id'] as String,
        userId: json['user_id'] as String?,
        phone: json['phone'] as String,
        purpose: json['purpose'] as String,
        code: json['code'] as String,
        createdAt: DateTime.parse(json['created_at'] as String),
        expiresAt: DateTime.parse(json['expires_at'] as String),
        attempts: json['attempts'] as int? ?? 0,
        consumedAt: json['consumed_at'] == null ? null : DateTime.parse(json['consumed_at'] as String),
        pending: json['pending'] == null ? null : Map<String, String>.from(json['pending'] as Map),
        deviceName: json['device_name'] as String? ?? '',
      );
}

class _Session {
  _Session({
    required this.id,
    required this.userId,
    required this.refresh,
    required this.deviceName,
    required this.ipAddress,
    required this.createdAt,
    required this.lastUsedAt,
    this.revokedAt,
  });

  final String id;
  final String userId;
  final String refresh;
  String deviceName;
  String ipAddress;
  DateTime createdAt;
  DateTime lastUsedAt;
  DateTime? revokedAt;

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'refresh': refresh,
        'device_name': deviceName,
        'ip_address': ipAddress,
        'created_at': createdAt.toIso8601String(),
        'last_used_at': lastUsedAt.toIso8601String(),
        'revoked_at': revokedAt?.toIso8601String(),
      };

  factory _Session.fromJson(Map<String, dynamic> json) => _Session(
        id: json['id'] as String,
        userId: json['user_id'] as String,
        refresh: json['refresh'] as String,
        deviceName: json['device_name'] as String,
        ipAddress: json['ip_address'] as String,
        createdAt: DateTime.parse(json['created_at'] as String),
        lastUsedAt: DateTime.parse(json['last_used_at'] as String),
        revokedAt: json['revoked_at'] == null ? null : DateTime.parse(json['revoked_at'] as String),
      );
}

class _Activity {
  _Activity({
    required this.id,
    required this.email,
    required this.success,
    required this.deviceName,
    required this.ipAddress,
    required this.createdAt,
    this.userId,
    this.userName,
    this.reason,
  });

  final String id;
  final String? userId;
  final String? userName;
  final String email;
  final bool success;
  final String deviceName;
  final String ipAddress;
  final String? reason;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'user_name': userName,
        'email': email,
        'success': success,
        'device_name': deviceName,
        'ip_address': ipAddress,
        'reason': reason,
        'created_at': createdAt.toIso8601String(),
      };

  factory _Activity.fromJson(Map<String, dynamic> json) => _Activity(
        id: json['id'] as String,
        userId: json['user_id'] as String?,
        userName: json['user_name'] as String?,
        email: json['email'] as String,
        success: json['success'] as bool,
        deviceName: json['device_name'] as String,
        ipAddress: json['ip_address'] as String,
        reason: json['reason'] as String?,
        createdAt: DateTime.parse(json['created_at'] as String),
      );
}

class _Reset {
  _Reset({required this.token, required this.userId, required this.expiresAt, this.usedAt});

  final String token;
  final String userId;
  final DateTime expiresAt;
  DateTime? usedAt;

  Map<String, dynamic> toJson() => {
        'token': token,
        'user_id': userId,
        'expires_at': expiresAt.toIso8601String(),
        'used_at': usedAt?.toIso8601String(),
      };

  factory _Reset.fromJson(Map<String, dynamic> json) => _Reset(
        token: json['token'] as String,
        userId: json['user_id'] as String,
        expiresAt: DateTime.parse(json['expires_at'] as String),
        usedAt: json['used_at'] == null ? null : DateTime.parse(json['used_at'] as String),
      );
}
