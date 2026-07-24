import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/fake_chat_repository.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/entities/chat_session.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../domain/usecases/end_chat_usecase.dart';
import '../../domain/usecases/request_chat_usecase.dart';
import '../../domain/usecases/send_message_usecase.dart';
import '../../domain/usecases/watch_chat_messages_usecase.dart';
import '../../domain/usecases/watch_chat_session_usecase.dart';

/// The single place a real backend gets plugged in later - swap
/// `FakeChatRepository()` for a real matching/transport implementation and
/// every use case, controller, and page above it keeps working unchanged.
final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final repository = FakeChatRepository();
  ref.onDispose(repository.dispose);
  return repository;
});

final requestChatUsecaseProvider = Provider<RequestChatUsecase>((ref) {
  return RequestChatUsecase(ref.watch(chatRepositoryProvider));
});

final sendMessageUsecaseProvider = Provider<SendMessageUsecase>((ref) {
  return SendMessageUsecase(ref.watch(chatRepositoryProvider));
});

final endChatUsecaseProvider = Provider<EndChatUsecase>((ref) {
  return EndChatUsecase(ref.watch(chatRepositoryProvider));
});

final watchChatSessionUsecaseProvider = Provider<WatchChatSessionUsecase>((ref) {
  return WatchChatSessionUsecase(ref.watch(chatRepositoryProvider));
});

final watchChatMessagesUsecaseProvider = Provider<WatchChatMessagesUsecase>((ref) {
  return WatchChatMessagesUsecase(ref.watch(chatRepositoryProvider));
});

/// The current chat session, if any (`null` = no session requested yet).
final chatSessionProvider = StreamProvider<ChatSession?>((ref) {
  return ref.watch(watchChatSessionUsecaseProvider)();
});

/// Messages in the current session, in send order.
final chatMessagesProvider = StreamProvider<List<ChatMessage>>((ref) {
  return ref.watch(watchChatMessagesUsecaseProvider)();
});
