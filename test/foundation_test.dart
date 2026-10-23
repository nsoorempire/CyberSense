import 'package:cyber_sense/core/network/api_exception.dart';
import 'package:cyber_sense/config/theme/app_colors.dart';
import 'package:cyber_sense/core/storage/token_store.dart';
import 'package:cyber_sense/data/mock/mock_store.dart';
import 'package:cyber_sense/state/account_controller.dart';
import 'package:cyber_sense/state/auth_controller.dart';
import 'package:cyber_sense/state/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cyber_sense/app.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    MockStore.latency = Duration.zero;
  });

  test('brand color and mock admin login', () async {
    expect(AppColors.primary, const Color(0xFF3B0066));
    final prefs = await SharedPreferences.getInstance();
    final store = MockStore(prefs);
    await store.load();
    final repo = MockAuthRepository(store);
    final challenge = await repo.login(email: 'admin@cybersense.app', password: 'Admin#2026', deviceName: 'test');
    expect(challenge.devCode, isNotNull);
    await expectLater(
      repo.verifyOtp(challengeId: challenge.id, code: '000000', deviceName: 'test'),
      throwsA(isA<ApiException>()),
    );
    final result = await repo.verifyOtp(challengeId: challenge.id, code: challenge.devCode!, deviceName: 'test');
    expect(result.user?.role, 'admin');
    expect(result.accessToken, isNotNull);

    final account = MockAccountRepository(store);
    final stats = await account.stats(result.accessToken!);
    expect(stats.total, greaterThan(1));
    final users = await account.users(result.accessToken!);
    expect(users.any((user) => user.email == 'user@cybersense.app'), isTrue);
  });

  testWidgets('splash opens onboarding in English', (tester) async {
    final prefs = await SharedPreferences.getInstance();
    final settings = SettingsController(prefs);
    await settings.setLocale(const Locale('en'));
    final memory = MemoryTokenStore();
    final store = MockStore(prefs);
    await store.load();
    final auth = AuthController(
      repository: MockAuthRepository(store),
      persistent: memory,
      memory: MemoryTokenStore(),
      active: ActiveTokenStore(memory),
      settings: settings,
    );
    await auth.restore();
    final account = AccountController(repository: MockAccountRepository(store), auth: auth);
    await tester.pumpWidget(CyberSenseApp(settings: settings, auth: auth, account: account));
    expect(find.text('Cyber Sense'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 1700));
    await tester.pumpAndSettle();
    expect(find.text('Next'), findsOneWidget);
    expect(find.text('Security, with a clear identity'), findsOneWidget);
  });
}
