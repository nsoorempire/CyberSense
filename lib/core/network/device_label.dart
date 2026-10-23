import 'dart:io';

import 'package:flutter/foundation.dart';

String deviceLabel() {
  if (kIsWeb) return 'Web';
  try {
    final version = Platform.operatingSystemVersion.split(' ').first;
    final os = switch (Platform.operatingSystem) {
      'ios' => 'iOS',
      'android' => 'Android',
      'macos' => 'macOS',
      _ => Platform.operatingSystem,
    };
    return '$os $version';
  } catch (_) {
    return 'Unknown device';
  }
}
