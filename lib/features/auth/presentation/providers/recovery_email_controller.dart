import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_providers.dart';

/// `AsyncData(null)` means the step is complete (sent or skipped);
/// `AsyncError(failure, ...)` means the recovery email was rejected.
class RecoveryEmailController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> sendRecoveryEmail({required String email}) async {
    state = const AsyncLoading();
    final usecase = ref.read(sendRecoveryEmailUsecaseProvider);
    final result = await usecase(email: email);
    state = result.match(
      (failure) => AsyncError<void>(failure, StackTrace.current),
      (_) => const AsyncData<void>(null),
    );
  }

  Future<void> skip() async {
    state = const AsyncLoading();
    final usecase = ref.read(skipRecoveryUsecaseProvider);
    final result = await usecase();
    state = result.match(
      (failure) => AsyncError<void>(failure, StackTrace.current),
      (_) => const AsyncData<void>(null),
    );
  }
}

final recoveryEmailControllerProvider = AsyncNotifierProvider<RecoveryEmailController, void>(
  RecoveryEmailController.new,
);
