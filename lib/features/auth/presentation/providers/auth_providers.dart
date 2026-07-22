import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/fake_auth_repository.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/log_in_usecase.dart';
import '../../domain/usecases/send_recovery_email_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';
import '../../domain/usecases/sign_up_usecase.dart';
import '../../domain/usecases/skip_recovery_usecase.dart';
import '../../domain/usecases/watch_auth_state_usecase.dart';

/// The single place a real backend gets plugged in later: swap
/// `FakeAuthRepository()` for e.g. `FirebaseAuthRepository(...)` and every
/// use case, controller, and page above it keeps working unchanged.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final repository = FakeAuthRepository();
  ref.onDispose(repository.dispose);
  return repository;
});

final signUpUsecaseProvider = Provider<SignUpUsecase>((ref) {
  return SignUpUsecase(ref.watch(authRepositoryProvider));
});

final logInUsecaseProvider = Provider<LogInUsecase>((ref) {
  return LogInUsecase(ref.watch(authRepositoryProvider));
});

final sendRecoveryEmailUsecaseProvider = Provider<SendRecoveryEmailUsecase>((ref) {
  return SendRecoveryEmailUsecase(ref.watch(authRepositoryProvider));
});

final skipRecoveryUsecaseProvider = Provider<SkipRecoveryUsecase>((ref) {
  return SkipRecoveryUsecase(ref.watch(authRepositoryProvider));
});

final signOutUsecaseProvider = Provider<SignOutUsecase>((ref) {
  return SignOutUsecase(ref.watch(authRepositoryProvider));
});

final watchAuthStateUsecaseProvider = Provider<WatchAuthStateUsecase>((ref) {
  return WatchAuthStateUsecase(ref.watch(authRepositoryProvider));
});

/// App-wide auth state, exposed as an `AsyncValue<User?>`. `null` data means
/// signed out. Anything (pages, routing redirects) can `ref.watch` this.
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(watchAuthStateUsecaseProvider)();
});
