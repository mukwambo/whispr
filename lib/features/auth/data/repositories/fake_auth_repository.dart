import 'dart:async';

import 'package:fpdart/fpdart.dart';

import 'package:whispr/core/error/failure.dart';
import 'package:whispr/core/error/result.dart';
import 'package:whispr/core/utils/validators.dart';
import '../../domain/entities/auth_result.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

class _StoredAccount {
  final User user;
  final String password;

  const _StoredAccount(this.user, this.password);
}

/// In-memory implementation of [AuthRepository]. Ships today so the app is
/// runnable and testable end-to-end before a real backend (Firebase,
/// Supabase, custom REST API) is chosen. Swapping backends later means
/// writing a new class implementing [AuthRepository] - nothing above the
/// data layer changes.
class FakeAuthRepository implements AuthRepository {
  final Map<String, _StoredAccount> _accountsByUsername = {};
  final Map<String, _StoredAccount> _accountsByEmail = {};
  final _authStateController = StreamController<User?>.broadcast();
  User? _currentUser;

  @override
  Stream<User?> watchAuthState() => _authStateController.stream;

  @override
  Future<Result<AuthResult>> signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    final usernameError = Validators.username(username);
    if (usernameError != null) return Left(ValidationFailure(usernameError));

    final emailError = Validators.email(email);
    if (emailError != null) return Left(ValidationFailure(emailError));

    final passwordError = Validators.password(password);
    if (passwordError != null) return const Left(WeakPasswordFailure());

    final normalizedUsername = username.trim().toLowerCase();
    final normalizedEmail = email.trim().toLowerCase();

    if (_accountsByUsername.containsKey(normalizedUsername)) {
      return const Left(UsernameAlreadyInUseFailure());
    }
    if (_accountsByEmail.containsKey(normalizedEmail)) {
      return const Left(EmailAlreadyInUseFailure());
    }

    final user = User(
      id: 'user-${_accountsByUsername.length + 1}',
      username: username.trim(),
      email: email.trim(),
    );
    final account = _StoredAccount(user, password);
    _accountsByUsername[normalizedUsername] = account;
    _accountsByEmail[normalizedEmail] = account;

    _setCurrentUser(user);
    return Right(AuthResult(user: user, isNewUser: true));
  }

  @override
  Future<Result<AuthResult>> logIn({
    required String identifier,
    required String password,
  }) async {
    final normalized = identifier.trim().toLowerCase();
    final account = _accountsByUsername[normalized] ?? _accountsByEmail[normalized];

    if (account == null || account.password != password) {
      return const Left(InvalidCredentialsFailure());
    }

    _setCurrentUser(account.user);
    return Right(AuthResult(user: account.user, isNewUser: false));
  }

  @override
  Future<Result<Unit>> sendRecoveryEmail({required String email}) async {
    final emailError = Validators.email(email);
    if (emailError != null) return Left(ValidationFailure(emailError));

    // A real backend would dispatch an email here; the fake just accepts it.
    return const Right(unit);
  }

  @override
  Future<Result<Unit>> skipRecovery() async => const Right(unit);

  @override
  Future<Result<Unit>> signOut() async {
    _setCurrentUser(null);
    return const Right(unit);
  }

  /// Releases the auth-state stream. Call when the repository instance is
  /// no longer needed (e.g. from the owning provider's `ref.onDispose`).
  void dispose() {
    _authStateController.close();
  }

  void _setCurrentUser(User? user) {
    _currentUser = user;
    _authStateController.add(_currentUser);
  }
}
