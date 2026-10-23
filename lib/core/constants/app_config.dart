class AppConfig {
  AppConfig._();

  static const useMock = bool.fromEnvironment('USE_MOCK', defaultValue: true);
  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://127.0.0.1:8000/api/v1',
  );

  static const demoUserEmail = 'user@cybersense.app';
  static const demoAdminEmail = 'admin@cybersense.app';
  static const demoUserPassword = 'User#2026';
  static const demoAdminPassword = 'Admin#2026';
  static const appVersion = '1.0.0';
}
