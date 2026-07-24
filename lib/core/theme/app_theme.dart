import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

/// The light theme. `colorScheme`/`textTheme.titleLarge` stay exactly as
/// they were - that's what renders the "Whispr" wordmark - everything else
/// is the calm, restrained-accent styling described in
/// `app_colors.dart`/`app_text_styles.dart`.
final lightTheme = _buildTheme(AppColorTokens.light, Brightness.light);

/// The dark theme - same shapes and spacing as [lightTheme], only the color
/// tokens differ (see [AppColorTokens.dark]).
final darkTheme = _buildTheme(AppColorTokens.dark, Brightness.dark);

ThemeData _buildTheme(AppColorTokens tokens, Brightness brightness) {
  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    fontFamily: 'Roboto',
    extensions: [tokens],
    colorScheme: ColorScheme.fromSeed(
      seedColor: tokens.primary,
      primary: tokens.primary,
      secondary: tokens.onPrimary,
      brightness: brightness,
    ),
    scaffoldBackgroundColor: tokens.scaffoldBackground,
    appBarTheme: AppBarTheme(
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
        color: tokens.primary,
      ),
    ),
    textTheme: const TextTheme(
      titleSmall: AppTextStyles.titleSmall,
      titleMedium: AppTextStyles.titleMedium,
      titleLarge: AppTextStyles.titleLarge,
      labelSmall: AppTextStyles.labelSmall,
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        textStyle: AppTextStyles.button,
        minimumSize: const Size(double.infinity, 50),
        backgroundColor: tokens.primary,
        foregroundColor: tokens.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.0),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: tokens.surface,
      prefixIconColor: tokens.inkFaint,
      suffixIconColor: tokens.inkFaint,
      labelStyle: AppTextStyles.fieldLabel.copyWith(color: tokens.inkMuted),
      floatingLabelStyle: AppTextStyles.fieldLabelFloating.copyWith(color: tokens.inkMuted),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      errorStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: tokens.error,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: tokens.divider, width: 1),
        borderRadius: BorderRadius.circular(14.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: tokens.divider, width: 1),
        borderRadius: BorderRadius.circular(14.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: tokens.primary, width: 1.4),
        borderRadius: BorderRadius.circular(14.0),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: tokens.error, width: 1),
        borderRadius: BorderRadius.circular(14.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: tokens.error, width: 1.4),
        borderRadius: BorderRadius.circular(14.0),
      ),
    ),
  );
}
