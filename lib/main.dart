import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/constants/app_config.dart';
import 'core/network/api_client.dart';
import 'core/storage/token_store.dart';
import 'data/api/api_repositories.dart';
import 'data/auth_repository.dart';
import 'data/mock/mock_store.dart';
import 'state/account_controller.dart';
import 'state/auth_controller.dart';
import 'state/settings_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final settings = SettingsController(prefs);
  final persistent = SecureTokenStore(fallback: prefs);
  final memory = MemoryTokenStore();
  final active = ActiveTokenStore(persistent);

  final AuthRepository authRepository;
  final AccountRepository accountRepository;
  ApiClient? api;
  if (AppConfig.useMock) {
    final store = MockStore(prefs);
    await store.load();
    authRepository = MockAuthRepository(store);
    accountRepository = MockAccountRepository(store);
  } else {
    api = ApiClient(active);
    authRepository = ApiAuthRepository(api);
    accountRepository = ApiAccountRepository(api);
  }

  final auth = AuthController(
    repository: authRepository,
    persistent: persistent,
    memory: memory,
    active: active,
    settings: settings,
  );
  api?.onSessionExpired = auth.forceLogout;
  final account = AccountController(repository: accountRepository, auth: auth);
  await auth.restore();

  runApp(CyberSenseApp(settings: settings, auth: auth, account: account));
}
