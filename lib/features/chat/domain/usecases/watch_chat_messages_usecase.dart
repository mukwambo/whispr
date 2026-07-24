import '../entities/chat_message.dart';
import '../repositories/chat_repository.dart';

class WatchChatMessagesUsecase {
  final ChatRepository _repository;

  const WatchChatMessagesUsecase(this._repository);

  Stream<List<ChatMessage>> call() => _repository.watchMessages();
}
