import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../core/network/device_label.dart';
import '../core/storage/token_store.dart';
import '../data/auth_repository.dart';
import '../data/models.dart';
import 'settings_controller.dart';

class AuthController extends ChangeNotifier {
  AuthController({
    required AuthRepository repository,
    required TokenStore persistent,
    required TokenStore memory,
    required ActiveTokenStore active,
    required SettingsController settings,
  })  : _repository = repository,
        _persistent = persistent,
        _memory = memory,
        _active = active,
        _settings = settings;

  final AuthRepository _repository;
  final TokenStore _persistent;
  final TokenStore _memory;
  final ActiveTokenStore _active;
  final SettingsController _settings;

  bool restored = false;
  bool splashDone = false;
  bool remember = true;
  UserProfile? user;
  String? accessToken;
  String? sessionId;
  OtpChallenge? pendingChallenge;
  String? resetToken;

  bool get ready => restored && splashDone;
  bool get isAuthenticated => user != null && accessToken != null;
  bool get isAdmin => user?.isAdmin ?? false;

  Future<void> restore() async {
    final access = await _persistent.readAccess();
    if (access != null) {
      _active.current = _persistent;
      try {
        user = await _repository.me(access);
        accessToken = access;
        sessionId = readSessionId(access);
      } catch (_) {
        await _persistent.clear();
        user = null;
        accessToken = null;
      }
    }
    restored = true;
    notifyListeners();
  }

  void finishSplash() {
    if (splashDone) return;
    splashDone = true;
    notifyListeners();
  }

  Future<void> forceLogout() async {
    await _persistent.clear();
    await _memory.clear();
    user = null;
    accessToken = null;
    sessionId = null;
    pendingChallenge = null;
    resetToken = null;
    notifyListeners();
  }

  Future<OtpChallenge> login({required String email, required String password, required bool rememberMe}) async {
    remember = rememberMe;
    final challenge = await _repository.login(email: email, password: password, deviceName: deviceLabel());
    pendingChallenge = challenge;
    await _settings.setRememberedEmail(rememberMe ? email.trim() : null);
    notifyListeners();
    return challenge;
  }

  Future<OtpChallenge> register({
    required String fullName,
    required String email,
    required String countryCode,
    required String phone,
    required String password,
  }) async {
    remember = true;
    final challenge = await _repository.register(
      fullName: fullName,
      email: email,
      countryCode: countryCode,
      phone: phone,
      password: password,
      deviceName: deviceLabel(),
    );
    pendingChallenge = challenge;
    notifyListeners();
    return challenge;
  }

  Future<OtpChallenge> forgotPassword({required String countryCode, required String phone}) async {
    final challenge = await _repository.forgotPassword(countryCode: countryCode, phone: phone, deviceName: deviceLabel());
    pendingChallenge = challenge;
    resetToken = null;
    notifyListeners();
    return challenge;
  }

  Future<void> verifyOtp(String code) async {
    final challenge = pendingChallenge;
    if (challenge == null) return;
    final result = await _repository.verifyOtp(challengeId: challenge.id, code: code, deviceName: deviceLabel());
    if (result.resetToken != null) {
      resetToken = result.resetToken;
      notifyListeners();
      return;
    }
    await _adopt(result);
  }

  Future<OtpChallenge> resend() async {
    final challenge = pendingChallenge;
    if (challenge == null) {
      throw StateError('No challenge');
    }
    final next = await _repository.resendOtp(challenge.id);
    pendingChallenge = next;
    notifyListeners();
    return next;
  }

  Future<void> resetPassword(String newPassword) async {
    final token = resetToken;
    if (token == null) return;
    await _repository.resetPassword(resetToken: token, newPassword: newPassword);
    resetToken = null;
    pendingChallenge = null;
    notifyListeners();
  }

  Future<void> updateProfile({required String fullName, required String countryCode, required String phone}) async {
    final token = accessToken;
    if (token == null) return;
    user = await _repository.updateProfile(accessToken: token, fullName: fullName, countryCode: countryCode, phone: phone);
    notifyListeners();
  }

  Future<void> changePassword({required String currentPassword, required String newPassword}) async {
    final token = accessToken;
    if (token == null) return;
    await _repository.changePassword(accessToken: token, currentPassword: currentPassword, newPassword: newPassword);
  }

  Future<void> logout() async {
    final token = accessToken;
    if (token != null) {
      try {
        await _repository.logout(token);
      } catch (_) {}
    }
    await forceLogout();
  }

  Future<void> _adopt(AuthResult result) async {
    final access = result.accessToken;
    final refresh = result.refreshToken;
    final profile = result.user;
    if (access == null || refresh == null || profile == null) return;
    final target = remember ? _persistent : _memory;
    final other = remember ? _memory : _persistent;
    _active.current = target;
    await target.save(access: access, refresh: refresh);
    await other.clear();
    accessToken = access;
    sessionId = readSessionId(access);
    user = profile;
    pendingChallenge = null;
    resetToken = null;
    notifyListeners();
  }
}

String? readSessionId(String token) {
  if (token.startsWith('mock.')) {
    final parts = token.split('.');
    return parts.length >= 3 ? parts[2] : null;
  }
  final parts = token.split('.');
  if (parts.length < 2) return null;
  try {
    final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
    final data = jsonDecode(payload);
    if (data is Map) return data['sid']?.toString();
  } catch (_) {}
  return null;
}
