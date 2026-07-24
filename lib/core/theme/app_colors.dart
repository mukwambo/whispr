import 'package:flutter/material.dart';

/// Fixed brand colors - the wordmark's colors (intro/sign-in screens) -
/// and must not change between light and dark mode.
class AppColors {
  const AppColors._();

  static const primary = Color(0xffff4165);
  static const onPrimary = Color(0xfffffefe);
}

/// Brightness-aware design tokens for everything else. `primary`/`onPrimary`
/// are carried here too (unchanged across modes) so call sites only ever
/// need one source - `context.appColors` - instead of mixing fixed
/// [AppColors] constants with brightness-aware ones.
///
/// Registered on [ThemeData] via `extensions`, so `context.appColors`
/// always resolves to whichever of [light]/[dark] is active - the same
/// mechanism [ThemeData.colorScheme] uses, just for our own semantic names.
@immutable
class AppColorTokens extends ThemeExtension<AppColorTokens> {
  final Color primary;
  final Color onPrimary;
  final Color scaffoldBackground;
  final Color surface;
  final Color ink;
  final Color inkMuted;
  final Color inkFaint;
  final Color divider;
  final Color error;

  const AppColorTokens({
    required this.primary,
    required this.onPrimary,
    required this.scaffoldBackground,
    required this.surface,
    required this.ink,
    required this.inkMuted,
    required this.inkFaint,
    required this.divider,
    required this.error,
  });

  static const light = AppColorTokens(
    primary: AppColors.primary,
    onPrimary: AppColors.onPrimary,
    scaffoldBackground: Color(0xffffffff),
    surface: Color(0xffffffff),
    ink: Color(0xff1f2126),
    inkMuted: Color(0xff6b7280),
    inkFaint: Color(0xff9aa1ac),
    divider: Color(0xffe6e2df),
    error: Color(0xffd64545),
  );

  static const dark = AppColorTokens(
    primary: AppColors.primary,
    onPrimary: AppColors.onPrimary,
    scaffoldBackground: Color(0xff121214),
    surface: Color(0xff1c1c1f),
    ink: Color(0xfff2f1f3),
    inkMuted: Color(0xff9aa1ac),
    inkFaint: Color(0xff767e89),
    divider: Color(0xff34343a),
    error: Color(0xffff6b6b),
  );

  @override
  AppColorTokens copyWith({
    Color? primary,
    Color? onPrimary,
    Color? scaffoldBackground,
    Color? surface,
    Color? ink,
    Color? inkMuted,
    Color? inkFaint,
    Color? divider,
    Color? error,
  }) {
    return AppColorTokens(
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      scaffoldBackground: scaffoldBackground ?? this.scaffoldBackground,
      surface: surface ?? this.surface,
      ink: ink ?? this.ink,
      inkMuted: inkMuted ?? this.inkMuted,
      inkFaint: inkFaint ?? this.inkFaint,
      divider: divider ?? this.divider,
      error: error ?? this.error,
    );
  }

  @override
  AppColorTokens lerp(ThemeExtension<AppColorTokens>? other, double t) {
    if (other is! AppColorTokens) return this;
    return AppColorTokens(
      primary: Color.lerp(primary, other.primary, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      scaffoldBackground: Color.lerp(scaffoldBackground, other.scaffoldBackground, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      ink: Color.lerp(ink, other.ink, t)!,
      inkMuted: Color.lerp(inkMuted, other.inkMuted, t)!,
      inkFaint: Color.lerp(inkFaint, other.inkFaint, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      error: Color.lerp(error, other.error, t)!,
    );
  }
}

extension AppColorTokensContext on BuildContext {
  /// The active brightness-aware token set - e.g. `context.appColors.ink`.
  AppColorTokens get appColors => Theme.of(this).extension<AppColorTokens>()!;
}
