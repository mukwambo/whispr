import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/auth_result.dart';
import 'auth_providers.dart';

/// `AsyncData(authResult)` on success, `AsyncError(failure, ...)` on failure.
/// The initial/idle state is `AsyncData(null)`.
class LogInController extends AsyncNotifier<AuthResult?> {
  @override
  FutureOr<AuthResult?> build() => null;

  Future<void> submit({
    required String identifier,
    required String password,
  }) async {
    state = const AsyncLoading();
    final usecase = ref.read(logInUsecaseProvider);
    final result = await usecase(identifier: identifier, password: password);
    state = result.match(
      (failure) => AsyncError<AuthResult?>(failure, StackTrace.current),
      (authResult) => AsyncData<AuthResult?>(authResult),
    );
  }
}

final logInControllerProvider = AsyncNotifierProvider<LogInController, AuthResult?>(
  LogInController.new,
);
