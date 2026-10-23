import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData light(Locale locale) => _build(Brightness.light, locale);

  static ThemeData dark(Locale locale) => _build(Brightness.dark, locale);

  static ThemeData _build(Brightness brightness, Locale locale) {
    final isLight = brightness == Brightness.light;
    final family = locale.languageCode == 'ar' ? 'Cairo' : 'Inter';
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: brightness,
    ).copyWith(
      primary: AppColors.primary,
      onPrimary: Colors.white,
      secondary: AppColors.accent,
      onSecondary: Colors.white,
      surface: isLight ? AppColors.lightSurface : AppColors.darkSurface,
      onSurface: isLight ? AppColors.lightTextPrimary : AppColors.darkTextPrimary,
      error: AppColors.error,
      onError: Colors.white,
      outline: isLight ? AppColors.lightInputBorder : AppColors.darkInputBorder,
    );

    final text = _textTheme(family, scheme.onSurface, isLight ? AppColors.lightTextSecondary : AppColors.darkTextSecondary);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: isLight ? AppColors.lightScaffold : AppColors.darkScaffold,
      textTheme: text,
      fontFamily: family,
      splashFactory: InkSparkle.splashFactory,
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: scheme.onSurface,
        centerTitle: false,
        titleTextStyle: text.titleLarge,
      ),
      cardTheme: CardThemeData(
        color: isLight ? AppColors.lightCard : AppColors.darkCard,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: isLight ? AppColors.lightDivider : AppColors.darkDivider),
        ),
      ),
      dividerTheme: DividerThemeData(color: isLight ? AppColors.lightDivider : AppColors.darkDivider, thickness: 1),
      dialogTheme: DialogThemeData(
        backgroundColor: isLight ? AppColors.lightSurface : AppColors.darkCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(color: AppColors.primary),
      navigationBarTheme: NavigationBarThemeData(
        height: 68,
        backgroundColor: isLight ? AppColors.lightSurface : AppColors.darkSurface,
        indicatorColor: isLight ? AppColors.primarySurface : const Color(0xFF2A1240),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          final color = selected
              ? (isLight ? AppColors.primary : AppColors.iconActiveDark)
              : (isLight ? AppColors.lightTextSecondary : AppColors.darkTextSecondary);
          return text.labelMedium?.copyWith(color: color, fontWeight: selected ? FontWeight.w600 : FontWeight.w500);
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected
                ? (isLight ? AppColors.primary : AppColors.iconActiveDark)
                : (isLight ? AppColors.lightTextSecondary : AppColors.darkTextSecondary),
          );
        }),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isLight ? AppColors.lightInputFill : AppColors.darkInputFill,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: text.bodyMedium?.copyWith(color: isLight ? AppColors.lightTextHint : AppColors.darkTextHint),
        labelStyle: text.bodyMedium?.copyWith(color: isLight ? AppColors.lightTextSecondary : AppColors.darkTextSecondary),
        border: _border(isLight ? AppColors.lightInputBorder : AppColors.darkInputBorder),
        enabledBorder: _border(isLight ? AppColors.lightInputBorder : AppColors.darkInputBorder),
        focusedBorder: _border(AppColors.primary, 1.6),
        errorBorder: _border(AppColors.error),
        focusedErrorBorder: _border(AppColors.error, 1.6),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.primary;
          return Colors.transparent;
        }),
        side: BorderSide(color: isLight ? AppColors.lightInputBorder : AppColors.darkInputBorder),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
    );
  }

  static OutlineInputBorder _border(Color color, [double width = 1]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  static TextTheme _textTheme(String family, Color primary, Color secondary) {
    TextStyle style(double size, FontWeight weight, double height, {Color? color}) {
      final wght = switch (weight) {
        FontWeight.w500 => 500.0,
        FontWeight.w600 => 600.0,
        FontWeight.w700 => 700.0,
        _ => 400.0,
      };
      final variations = <FontVariation>[
        FontVariation('wght', wght),
        if (family == 'Cairo') const FontVariation('slnt', 0) else const FontVariation('opsz', 24),
      ];
      return TextStyle(
        fontFamily: family,
        fontFamilyFallback: family == 'Inter' ? const ['Cairo'] : const ['Inter'],
        fontWeight: weight,
        fontVariations: variations,
        fontSize: size,
        height: height,
        color: color ?? primary,
      );
    }

    return TextTheme(
      displaySmall: style(32, FontWeight.w700, 1.2),
      headlineMedium: style(26, FontWeight.w700, 1.25),
      headlineSmall: style(22, FontWeight.w700, 1.3),
      titleLarge: style(20, FontWeight.w600, 1.3),
      titleMedium: style(16, FontWeight.w600, 1.35),
      titleSmall: style(14, FontWeight.w600, 1.35),
      bodyLarge: style(16, FontWeight.w400, 1.5),
      bodyMedium: style(14, FontWeight.w400, 1.45),
      bodySmall: style(12, FontWeight.w400, 1.4, color: secondary),
      labelLarge: style(14, FontWeight.w600, 1.2),
      labelMedium: style(12, FontWeight.w500, 1.2),
    );
  }
}
