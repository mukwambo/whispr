import 'package:flutter/material.dart';

import 'package:whispr/core/theme/app_text_styles.dart';

/// A quiet, inline tappable link (e.g. "Log in", "Forgot password?").
/// Used instead of a second filled button so a screen keeps one clear
/// primary action instead of two competing blocks.
class TextLink extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final TextStyle? style;

  const TextLink({
    super.key,
    required this.text,
    required this.onPressed,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      behavior: HitTestBehavior.opaque,
      child: Text(text, style: style ?? AppTextStyles.link),
    );
  }
}
