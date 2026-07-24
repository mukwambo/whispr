import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'chat_providers.dart';

class EndChatController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> submit() async {
    state = const AsyncLoading();
    final usecase = ref.read(endChatUsecaseProvider);
    final result = await usecase();
    state = result.match(
      (failure) => AsyncError<void>(failure, StackTrace.current),
      (_) => const AsyncData<void>(null),
    );
  }
}

final endChatControllerProvider = AsyncNotifierProvider<EndChatController, void>(
  EndChatController.new,
);
