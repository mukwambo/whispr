import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/chat_session.dart' show ChatRole;
import 'chat_providers.dart';

/// State carries the *requested role* on success so a genuine success is
/// distinguishable from the idle `null` initial state - `AsyncData(null)`
/// is idle, `AsyncData(role)` is "just succeeded", `AsyncError` is a
/// rejected request (e.g. a chat is already active).
class RequestChatController extends AsyncNotifier<ChatRole?> {
  @override
  FutureOr<ChatRole?> build() => null;

  Future<void> submit({required ChatRole role}) async {
    state = const AsyncLoading();
    final usecase = ref.read(requestChatUsecaseProvider);
    final result = await usecase(role: role);
    state = result.match(
      (failure) => AsyncError<ChatRole?>(failure, StackTrace.current),
      (_) => AsyncData<ChatRole?>(role),
    );
  }
}

final requestChatControllerProvider = AsyncNotifierProvider<RequestChatController, ChatRole?>(
  RequestChatController.new,
);
