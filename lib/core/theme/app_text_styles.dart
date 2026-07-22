import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Text style tokens.
///
/// `titleLarge` renders the "Whispr" wordmark (intro screen) and must not
/// change. The older `titleMedium`/`titleSmall`/`labelSmall` roles are kept
/// as-is for compatibility but are no longer used by page content - pages
/// now reference the purpose-named styles below directly, so a style's name
/// says what it's for instead of borrowing an unrelated Material role.
class AppTextStyles {
  const AppTextStyles._();

  static const titleSmall = TextStyle(
    fontSize: 16,
  );

  static const titleMedium = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );

  static const titleLarge = TextStyle(
    fontSize: 55,
    fontFamily: 'Pacifico',
    color: AppColors.onPrimary,
  );

  static const labelSmall = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );

  /// A page's title (e.g. "Create your account"). Calm, not shouty: medium
  /// weight rather than bold, ink rather than the accent color.
  static const pageTitle = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w600,
    color: AppColors.ink,
    height: 1.25,
    letterSpacing: -0.3,
  );

  /// Supporting copy directly under a page title.
  static const subtitle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.inkMuted,
    height: 1.5,
  );

  /// Small tracked caption - divider labels, section eyebrows.
  static const caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.inkFaint,
    letterSpacing: 0.8,
  );

  /// A form field's label at rest, before it floats on focus.
  static const fieldLabel = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.inkMuted,
  );

  /// A form field's label once floated (focused or filled).
  static const fieldLabelFloating = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.inkMuted,
    letterSpacing: 0.1,
  );

  /// Primary button label.
  static const button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  /// Quiet inline links: "Log in", "Forgot password?" - colored so they
  /// read as tappable without needing a button's weight.
  static const link = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.primary,
  );

  /// Smallest print - footer legal links, dismissive actions like "Skip".
  static const smallPrint = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.inkFaint,
  );
}
