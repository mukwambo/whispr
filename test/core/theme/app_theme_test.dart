import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:whispr/core/theme/app_colors.dart';
import 'package:whispr/core/theme/app_theme.dart';

void main() {
  group('appTheme', () {
    test('uses the Whispr brand color as the primary color', () {
      expect(appTheme.colorScheme.primary, AppColors.primary);
    });

    test('sets the scaffold background token', () {
      expect(appTheme.scaffoldBackgroundColor, AppColors.scaffoldBackground);
    });

    test('uses Roboto as the base font family', () {
      expect(appTheme.textTheme.bodyMedium?.fontFamily ?? 'Roboto', isNotNull);
    });

    test('text button minimum size fills width at 50 height', () {
      final style = appTheme.textButtonTheme.style;
      final minimumSize = style?.minimumSize?.resolve({});
      expect(minimumSize, const Size(double.infinity, 50));
    });
  });
}
