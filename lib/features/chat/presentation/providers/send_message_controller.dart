import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'chat_providers.dart';

/// `AsyncData(null)` is idle/success (the messages stream carries the sent
/// message); `AsyncError(failure, ...)` means the send was rejected (e.g.
/// an empty message).
class SendMessageController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> submit({required String text}) async {
    state = const AsyncLoading();
    final usecase = ref.read(sendMessageUsecaseProvider);
    final result = await usecase(text: text);
    state = result.match(
      (failure) => AsyncError<void>(failure, StackTrace.current),
      (_) => const AsyncData<void>(null),
    );
  }
}

final sendMessageControllerProvider = AsyncNotifierProvider<SendMessageController, void>(
  SendMessageController.new,
);
