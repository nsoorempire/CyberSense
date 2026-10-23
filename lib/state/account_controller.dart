import 'package:flutter/foundation.dart';

import '../data/auth_repository.dart';
import '../data/models.dart';
import 'auth_controller.dart';

class AccountController extends ChangeNotifier {
  AccountController({required AccountRepository repository, required AuthController auth})
      : _repository = repository,
        _auth = auth;

  final AccountRepository _repository;
  final AuthController _auth;

  UserStats? stats;
  List<UserProfile> users = [];
  List<LoginActivity> activities = [];
  List<UserSession> sessions = [];
  bool loadingStats = false;
  bool loadingUsers = false;
  bool loadingActivity = false;
  bool loadingSessions = false;
  Object? statsError;
  Object? usersError;
  Object? activityError;
  Object? sessionsError;
  String userQuery = '';
  String userStatus = 'all';

  String? get _token => _auth.accessToken;

  Future<void> loadStats() async {
    final token = _token;
    if (token == null) return;
    loadingStats = true;
    statsError = null;
    notifyListeners();
    try {
      stats = await _repository.stats(token);
    } catch (error) {
      statsError = error;
    } finally {
      loadingStats = false;
      notifyListeners();
    }
  }

  Future<void> loadUsers({String? query, String? status}) async {
    final token = _token;
    if (token == null) return;
    if (query != null) userQuery = query;
    if (status != null) userStatus = status;
    loadingUsers = true;
    usersError = null;
    notifyListeners();
    try {
      users = await _repository.users(token, query: userQuery, status: userStatus);
    } catch (error) {
      usersError = error;
    } finally {
      loadingUsers = false;
      notifyListeners();
    }
  }

  Future<UserProfile> updateUser(String id, {String? role, bool? isActive, bool? isBanned, bool delete = false}) async {
    final token = _token;
    if (token == null) throw StateError('Signed out');
    final updated = await _repository.updateUser(token, id, role: role, isActive: isActive, isBanned: isBanned, delete: delete);
    if (delete) {
      users = users.where((item) => item.id != id).toList();
    } else {
      users = users.map((item) => item.id == id ? updated : item).toList();
    }
    notifyListeners();
    await loadStats();
    await loadUsers();
    return updated;
  }

  Future<void> loadActivity() async {
    final token = _token;
    if (token == null) return;
    loadingActivity = true;
    activityError = null;
    notifyListeners();
    try {
      activities = await _repository.activity(token);
    } catch (error) {
      activityError = error;
    } finally {
      loadingActivity = false;
      notifyListeners();
    }
  }

  Future<void> loadSessions() async {
    final token = _token;
    if (token == null) return;
    loadingSessions = true;
    sessionsError = null;
    notifyListeners();
    try {
      sessions = await _repository.sessions(token);
    } catch (error) {
      sessionsError = error;
    } finally {
      loadingSessions = false;
      notifyListeners();
    }
  }

  Future<bool> revokeSession(String id) async {
    final token = _token;
    if (token == null) return false;
    await _repository.revokeSession(token, id);
    final current = id == _auth.sessionId;
    if (current) {
      await _auth.forceLogout();
      return true;
    }
    await loadSessions();
    return false;
  }

  Future<void> revokeAll() async {
    final token = _token;
    if (token == null) return;
    await _repository.revokeAllSessions(token);
    await _auth.forceLogout();
  }
}
