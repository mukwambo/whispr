import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:whispr/core/theme/app_colors.dart';
import 'package:whispr/core/theme/app_theme.dart';

void main() {
  group('lightTheme', () {
    test('uses the Whispr brand color as the primary color', () {
      expect(lightTheme.colorScheme.primary, AppColors.primary);
    });

    test('registers light AppColorTokens matching the scaffold background', () {
      expect(lightTheme.scaffoldBackgroundColor, AppColorTokens.light.scaffoldBackground);
      expect(lightTheme.extension<AppColorTokens>(), AppColorTokens.light);
    });

    test('uses Roboto as the base font family', () {
      expect(lightTheme.textTheme.bodyMedium?.fontFamily ?? 'Roboto', isNotNull);
    });

    test('text button minimum size fills width at 50 height', () {
      final style = lightTheme.textButtonTheme.style;
      final minimumSize = style?.minimumSize?.resolve({});
      expect(minimumSize, const Size(double.infinity, 50));
    });
  });

  group('darkTheme', () {
    test('uses the Whispr brand color as the primary color', () {
      expect(darkTheme.colorScheme.primary, AppColors.primary);
    });

    test('registers dark AppColorTokens matching the scaffold background', () {
      expect(darkTheme.scaffoldBackgroundColor, AppColorTokens.dark.scaffoldBackground);
      expect(darkTheme.extension<AppColorTokens>(), AppColorTokens.dark);
    });

    test('has a dark brightness', () {
      expect(darkTheme.brightness, Brightness.dark);
    });
  });
}
