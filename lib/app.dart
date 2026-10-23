import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'config/routes/app_router.dart';
import 'config/theme/app_theme.dart';
import 'core/localization/generated/app_localizations.dart';
import 'state/account_controller.dart';
import 'state/auth_controller.dart';
import 'state/settings_controller.dart';

class CyberSenseApp extends StatefulWidget {
  const CyberSenseApp({
    super.key,
    required this.settings,
    required this.auth,
    required this.account,
  });

  final SettingsController settings;
  final AuthController auth;
  final AccountController account;

  @override
  State<CyberSenseApp> createState() => _CyberSenseAppState();
}

class _CyberSenseAppState extends State<CyberSenseApp> with WidgetsBindingObserver {
  late final GoRouter _router = createRouter(widget.auth, widget.settings);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _router.dispose();
    super.dispose();
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    widget.settings.onSystemLocaleChanged();
  }

  @override
  Widget build(BuildContext context) {
    final settings = widget.settings;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SettingsController>.value(value: settings),
        ChangeNotifierProvider<AuthController>.value(value: widget.auth),
        ChangeNotifierProvider<AccountController>.value(value: widget.account),
      ],
      child: AnimatedBuilder(
        animation: settings,
        builder: (context, _) {
          final active = settings.resolvedLocale();
          return MaterialApp.router(
            title: 'Cyber Sense',
            debugShowCheckedModeBanner: false,
            locale: active,
            supportedLocales: S.supportedLocales,
            localizationsDelegates: S.localizationsDelegates,
            theme: AppTheme.light(active),
            darkTheme: AppTheme.dark(active),
            themeMode: settings.themeMode,
            routerConfig: _router,
            builder: (context, child) {
              final media = MediaQuery.of(context);
              return MediaQuery(
                data: media.copyWith(textScaler: media.textScaler.clamp(minScaleFactor: 0.9, maxScaleFactor: 1.25)),
                child: child ?? const SizedBox.shrink(),
              );
            },
          );
        },
      ),
    );
  }
}
