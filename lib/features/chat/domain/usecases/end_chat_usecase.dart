import 'package:fpdart/fpdart.dart';

import 'package:whispr/core/error/result.dart';
import '../repositories/chat_repository.dart';

class EndChatUsecase {
  final ChatRepository _repository;

  const EndChatUsecase(this._repository);

  Future<Result<Unit>> call() {
    return _repository.endChat();
  }
}
