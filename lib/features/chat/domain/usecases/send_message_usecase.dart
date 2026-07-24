import 'package:fpdart/fpdart.dart';

import 'package:whispr/core/error/result.dart';
import '../repositories/chat_repository.dart';

class SendMessageUsecase {
  final ChatRepository _repository;

  const SendMessageUsecase(this._repository);

  Future<Result<Unit>> call({required String text}) {
    return _repository.sendMessage(text: text);
  }
}
