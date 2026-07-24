import 'package:fpdart/fpdart.dart';

import 'package:whispr/core/error/result.dart';
import '../entities/chat_message.dart';
import '../entities/chat_session.dart';

/// Abstraction over however chat is actually implemented (a real-time
/// backend with matching, message relay, and encryption in transit/at
/// rest). Presentation and domain code depend only on this interface, so a
/// real backend can be swapped in later without touching use cases or UI -
/// same pattern as `AuthRepository`.
///
/// Scoped to a single active session for this MVP (no `sessionId`
/// parameters or family providers) - a real backend would need to
/// generalize this to support switching between sessions.
abstract class ChatRepository {
  Stream<ChatSession?> watchSession();

  Stream<List<ChatMessage>> watchMessages();

  Future<Result<Unit>> requestChat({required ChatRole role});

  Future<Result<Unit>> sendMessage({required String text});

  Future<Result<Unit>> endChat();
}
