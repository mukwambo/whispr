import 'package:flutter/material.dart';

/// Brand color tokens for Whispr.
///
/// `primary` and `onPrimary` are the wordmark's colors (intro/sign-in
/// screens) and must not change. Everywhere else, `primary` is used
/// sparingly - the one accent that means "this is interactive" (the CTA,
/// a focused field, a text link) - so it keeps its meaning instead of
/// becoming visual noise.
class AppColors {
  const AppColors._();

  static const primary = Color(0xffff4165);
  static const onPrimary = Color(0xfffffefe);

  static const scaffoldBackground = Color(0xffffffff);
  static const surface = Color(0xffffffff);

  static const ink = Color(0xff1f2126);
  static const inkMuted = Color(0xff6b7280);
  static const inkFaint = Color(0xff9aa1ac);

  static const divider = Color(0xffe6e2df);
  static const error = Color(0xffd64545);
}
