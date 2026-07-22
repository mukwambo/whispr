/// Central registry of route paths so page/route strings are never
/// hand-typed at each call site.
class RoutePaths {
  const RoutePaths._();

  static const intro = '/';
  static const signIn = '/sign-in';
  static const createAccount = '/create-account';
  static const login = '/login';
  static const recoveryEmail = '/recovery-email';
  static const home = '/home';
}
