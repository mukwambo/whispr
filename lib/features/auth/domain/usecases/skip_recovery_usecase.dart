import 'package:fpdart/fpdart.dart';

import 'package:whispr/core/error/result.dart';
import '../repositories/auth_repository.dart';

class SkipRecoveryUsecase {
  final AuthRepository _repository;

  const SkipRecoveryUsecase(this._repository);

  Future<Result<Unit>> call() {
    return _repository.skipRecovery();
  }
}
