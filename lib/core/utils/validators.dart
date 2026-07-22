/// Client-side field validators, shared by forms (as `TextFormField`
/// validators, which pass a nullable value) and the fake repository (so the
/// fake behaves like a real backend would). Each method returns `null` when
/// the value is valid, or an error message.
class Validators {
  const Validators._();

  static final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  static String? email(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return 'Email is required';
    if (!_emailPattern.hasMatch(trimmed)) return 'Enter a valid email address';
    return null;
  }

  static String? username(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return 'Username is required';
    if (trimmed.length < 3) return 'Username must be at least 3 characters';
    return null;
  }

  static String? password(String? value) {
    final actual = value ?? '';
    if (actual.isEmpty) return 'Password is required';
    if (actual.length < 8) return 'Password must be at least 8 characters';
    return null;
  }

  static String? identifier(String? value) {
    if ((value?.trim() ?? '').isEmpty) return 'Username or email is required';
    return null;
  }
}
