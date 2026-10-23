import 'package:flutter/material.dart';

import '../localization/generated/app_localizations.dart';

extension ContextX on BuildContext {
  S get s => S.of(this);

  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  ColorScheme get colors => Theme.of(this).colorScheme;

  TextTheme get text => Theme.of(this).textTheme;
}
