import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends ChangeNotifier {
  SettingsController(this._prefs) {
    final code = _prefs.getString(_localeKey);
    if (code == 'ar' || code == 'en') _locale = Locale(code!);
    _themeMode = switch (_prefs.getString(_themeKey)) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
    _onboardingDone = _prefs.getBool(_onboardingKey) ?? false;
    _rememberedEmail = _prefs.getString(_emailKey);
  }

  static const _localeKey = 'locale_code';
  static const _themeKey = 'theme_mode';
  static const _onboardingKey = 'onboarding_done';
  static const _emailKey = 'remembered_email';

  final SharedPreferences _prefs;
  Locale? _locale;
  ThemeMode _themeMode = ThemeMode.system;
  bool _onboardingDone = false;
  String? _rememberedEmail;

  Locale? get savedLocale => _locale;
  ThemeMode get themeMode => _themeMode;
  bool get onboardingDone => _onboardingDone;
  String? get rememberedEmail => _rememberedEmail;

  Locale resolvedLocale() {
    if (_locale != null) return _locale!;
    final code = WidgetsBinding.instance.platformDispatcher.locale.languageCode;
    return Locale(code == 'ar' ? 'ar' : 'en');
  }

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    await _prefs.setString(_localeKey, locale.languageCode);
    notifyListeners();
  }

  Future<void> setTheme(ThemeMode mode) async {
    _themeMode = mode;
    await _prefs.setString(_themeKey, switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    });
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    _onboardingDone = true;
    await _prefs.setBool(_onboardingKey, true);
    notifyListeners();
  }

  void onSystemLocaleChanged() {
    if (_locale == null) notifyListeners();
  }

  Future<void> setRememberedEmail(String? email) async {
    _rememberedEmail = email;
    if (email == null || email.isEmpty) {
      await _prefs.remove(_emailKey);
    } else {
      await _prefs.setString(_emailKey, email);
    }
    notifyListeners();
  }
}
