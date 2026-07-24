import 'package:fpdart/fpdart.dart';

import 'package:whispr/core/error/result.dart';
import '../entities/chat_session.dart';
import '../repositories/chat_repository.dart';

class RequestChatUsecase {
  final ChatRepository _repository;

  const RequestChatUsecase(this._repository);

  Future<Result<Unit>> call({required ChatRole role}) {
    return _repository.requestChat(role: role);
  }
}
