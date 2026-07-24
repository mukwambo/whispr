import '../entities/chat_session.dart';
import '../repositories/chat_repository.dart';

class WatchChatSessionUsecase {
  final ChatRepository _repository;

  const WatchChatSessionUsecase(this._repository);

  Stream<ChatSession?> call() => _repository.watchSession();
}
