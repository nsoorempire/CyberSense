import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class TokenStore {
  Future<String?> readAccess();
  Future<String?> readRefresh();
  Future<void> save({required String access, required String refresh});
  Future<void> clear();
}

class MemoryTokenStore implements TokenStore {
  String? _access;
  String? _refresh;

  @override
  Future<void> clear() async {
    _access = null;
    _refresh = null;
  }

  @override
  Future<String?> readAccess() async => _access;

  @override
  Future<String?> readRefresh() async => _refresh;

  @override
  Future<void> save({required String access, required String refresh}) async {
    _access = access;
    _refresh = refresh;
  }
}

class SecureTokenStore implements TokenStore {
  SecureTokenStore({FlutterSecureStorage? storage, SharedPreferences? fallback})
      : _storage = storage ?? const FlutterSecureStorage(),
        _fallback = fallback;

  final FlutterSecureStorage _storage;
  SharedPreferences? _fallback;
  static const _accessKey = 'cs_access';
  static const _refreshKey = 'cs_refresh';

  Future<SharedPreferences> get _prefs async => _fallback ??= await SharedPreferences.getInstance();

  @override
  Future<void> clear() async {
    try {
      await _storage.delete(key: _accessKey);
      await _storage.delete(key: _refreshKey);
    } catch (_) {
      final prefs = await _prefs;
      await prefs.remove(_accessKey);
      await prefs.remove(_refreshKey);
    }
  }

  @override
  Future<String?> readAccess() => _read(_accessKey);

  @override
  Future<String?> readRefresh() => _read(_refreshKey);

  Future<String?> _read(String key) async {
    try {
      return await _storage.read(key: key);
    } catch (_) {
      return (await _prefs).getString(key);
    }
  }

  @override
  Future<void> save({required String access, required String refresh}) async {
    try {
      await _storage.write(key: _accessKey, value: access);
      await _storage.write(key: _refreshKey, value: refresh);
    } catch (_) {
      final prefs = await _prefs;
      await prefs.setString(_accessKey, access);
      await prefs.setString(_refreshKey, refresh);
    }
  }
}

class ActiveTokenStore implements TokenStore {
  ActiveTokenStore(this.current);

  TokenStore current;

  @override
  Future<void> clear() => current.clear();

  @override
  Future<String?> readAccess() => current.readAccess();

  @override
  Future<String?> readRefresh() => current.readRefresh();

  @override
  Future<void> save({required String access, required String refresh}) {
    return current.save(access: access, refresh: refresh);
  }
}
