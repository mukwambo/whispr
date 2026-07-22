import 'package:flutter/material.dart';

/// Standard form field used across auth screens. Uses a floating label
/// (rather than a separate caption above a hint that repeats the same
/// word) so each field only says its name once, and styled by the app's
/// `inputDecorationTheme`. No leading icon by default - once the label
/// floats, an icon is decoration rather than information; pass one only
/// if a specific field genuinely needs it.
class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String labelText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final AutovalidateMode autovalidateMode;

  const AppTextField({
    super.key,
    this.controller,
    required this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.obscureText = false,
    this.validator,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      autovalidateMode: autovalidateMode,
      decoration: InputDecoration(
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        suffixIcon: suffixIcon,
        labelText: labelText,
      ),
    );
  }
}
