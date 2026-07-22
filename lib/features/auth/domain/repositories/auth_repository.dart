import 'package:fpdart/fpdart.dart';

import 'package:whispr/core/error/result.dart';
import '../entities/auth_result.dart';
import '../entities/user.dart';

/// Abstraction over however auth is actually implemented (Firebase,
/// Supabase, a custom REST API, or - today - an in-memory fake). Presentation
/// and domain code depend only on this interface, never on a concrete
/// implementation, so the backend can be swapped in later without touching
/// use cases or UI.
abstract class AuthRepository {
  /// Emits the current user whenever auth state changes (`null` = signed out).
  Stream<User?> watchAuthState();

  Future<Result<AuthResult>> signUp({
    required String username,
    required String email,
    required String password,
  });

  Future<Result<AuthResult>> logIn({
    required String identifier,
    required String password,
  });

  Future<Result<Unit>> sendRecoveryEmail({required String email});

  Future<Result<Unit>> skipRecovery();

  Future<Result<Unit>> signOut();
}
