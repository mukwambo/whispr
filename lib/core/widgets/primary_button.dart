import 'package:flutter/material.dart';

import 'package:whispr/core/theme/app_colors.dart';

/// The app's primary call-to-action button, styled by `textButtonTheme`.
/// Shows a spinner and disables itself while [isLoading] is true, so async
/// auth actions (sign up, log in, ...) get a consistent busy state.
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.onPrimary,
              ),
            )
          : Text(label),
    );
  }
}
