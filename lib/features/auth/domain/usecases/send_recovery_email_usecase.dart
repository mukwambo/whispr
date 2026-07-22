import 'package:fpdart/fpdart.dart';

import 'package:whispr/core/error/result.dart';
import '../repositories/auth_repository.dart';

class SendRecoveryEmailUsecase {
  final AuthRepository _repository;

  const SendRecoveryEmailUsecase(this._repository);

  Future<Result<Unit>> call({required String email}) {
    return _repository.sendRecoveryEmail(email: email);
  }
}
